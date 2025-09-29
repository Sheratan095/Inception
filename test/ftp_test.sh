#!/bin/bash

# Simple FTP Upload Test Script

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# FTP Configuration
FTP_HOST="localhost"
FTP_USER="marco"
FTP_PASSWORD="1234"

echo -e "${BLUE}FTP Upload Test${NC}"
echo "=================="

# Create test file
TEST_FILE="/test.jpeg"
echo "Hello from FTP upload test - $(date)" > "$TEST_FILE"
echo "→ Created test file: $TEST_FILE"

# Upload file via FTP
echo "→ Uploading file to FTP server..."
if lftp -e "set ssl:verify-certificate no; put $TEST_FILE; quit" -u "$FTP_USER,$FTP_PASSWORD" $FTP_HOST 2>/dev/null; then
    echo -e "${GREEN}✓ SUCCESS: File uploaded successfully!${NC}"
    
    # Verify file exists on server
    echo "→ Verifying file on server..."
    FILENAME=$(basename "$TEST_FILE")
    if lftp -e "set ssl:verify-certificate no; ls $FILENAME; quit" -u "$FTP_USER,$FTP_PASSWORD" $FTP_HOST 2>/dev/null | grep -q "$FILENAME"; then
        echo -e "${GREEN}✓ SUCCESS: File verified on FTP server${NC}"
        
        # Clean up
        rm -f "$TEST_FILE"
        lftp -e "set ssl:verify-certificate no; rm $FILENAME; quit" -u "$FTP_USER,$FTP_PASSWORD" $FTP_HOST 2>/dev/null
        echo "→ Cleanup completed"
        echo -e "${GREEN}FTP upload test PASSED!${NC}"
    else
        echo -e "${RED}✗ FAILED: File not found on server${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ FAILED: Could not upload file${NC}"
    rm -f "$TEST_FILE"
    exit 1
fi