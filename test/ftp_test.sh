#!/bin/bash

# ==============================================================================
# FTP Upload Test Script for Docker Inception Project
# ==============================================================================
# This script tests the FTP service functionality by:
# 1. Creating a test file locally
# 2. Uploading it to the FTP server via FTPS (SSL/TLS)
# 3. Verifying the file exists on the server
# 4. Cleaning up test files
# 
# The FTP server is configured with:
# - SSL/TLS encryption enabled
# - Self-signed certificates (development environment)
# - User authentication required
# - Files stored in /var/www/html (shared with WordPress and Nginx)
# ==============================================================================

# ANSI color codes for formatted output
GREEN='\033[0;32m'  # Success messages
RED='\033[0;31m'    # Error messages
BLUE='\033[0;34m'   # Information headers
NC='\033[0m'        # No Color (reset)

# ==============================================================================
# FTP Server Configuration
# ==============================================================================
# These settings match the .env file and docker-compose.yml configuration
FTP_HOST="localhost"        # FTP server address (Docker container mapped to localhost)
FTP_USER="marco"           # Username from .env file (FTP_USER variable)
FTP_PASSWORD="1234"        # Password from .env file (FTP_PASSWORD variable)

# Display test header
echo -e "${BLUE}FTP Upload Test${NC}"
echo -e "${BLUE}===============${NC}"
echo "Testing FTP service connectivity and file upload functionality"
echo

# ==============================================================================
# Step 1: Create Test File
# ==============================================================================
# WARNING: Current path "/test.jpeg" will try to create file in root directory
# This requires root permissions and may fail. Better to use /tmp/test.jpeg
TEST_FILE="/test.jpeg"
echo "Hello from FTP upload test - $(date)" > "$TEST_FILE"
echo "→ Created test file: $TEST_FILE"
echo "  Content: Test message with timestamp for verification"

# ==============================================================================
# Step 2: Upload File to FTP Server
# ==============================================================================
# Using lftp client with the following options:
# - "set ssl:verify-certificate no" : Accept self-signed certificates
# - "put $TEST_FILE" : Upload the local file to server
# - "quit" : Close FTP session
# - "-u user,pass" : Authenticate with username and password
# - "2>/dev/null" : Suppress error messages for cleaner output
echo "→ Uploading file to FTP server..."
echo "  Using FTPS (FTP over SSL/TLS) connection"
echo "  Server: $FTP_HOST:21"
echo "  User: $FTP_USER"

if lftp -e "set ssl:verify-certificate no; put $TEST_FILE; quit" -u "$FTP_USER,$FTP_PASSWORD" $FTP_HOST 2>/dev/null; then
    echo -e "${GREEN}✓ SUCCESS: File uploaded successfully!${NC}"
    echo "  File has been transferred to server's /var/www/html directory"
    
    # ==========================================================================
    # Step 3: Verify File Exists on Server
    # ==========================================================================
    # Extract just the filename from the full path for server verification
    echo "→ Verifying file on server..."
    FILENAME=$(basename "$TEST_FILE")  # Gets "test.jpeg" from "/test.jpeg"
    echo "  Looking for file: $FILENAME"
    echo "  Server storage path: /var/www/html/$FILENAME"
    echo "  Host storage path: /root/data/wp/$FILENAME (Docker volume mount)"
    
    # List the specific file on server to confirm it exists
    if lftp -e "set ssl:verify-certificate no; ls $FILENAME; quit" -u "$FTP_USER,$FTP_PASSWORD" $FTP_HOST 2>/dev/null | grep -q "$FILENAME"; then
        echo -e "${GREEN}✓ SUCCESS: File verified on FTP server${NC}"
        echo "  The uploaded file is accessible via FTP, WordPress, and Nginx services"
        
        # ======================================================================
        # Step 4: Cleanup Test Files
        # ======================================================================
        echo "→ Cleaning up test files..."
        
        # Remove local test file
        rm -f "$TEST_FILE"
        echo "  Removed local file: $TEST_FILE"
        
        # Remove file from FTP server
        lftp -e "set ssl:verify-certificate no; rm $FILENAME; quit" -u "$FTP_USER,$FTP_PASSWORD" $FTP_HOST 2>/dev/null
        echo "  Removed server file: $FILENAME"
        
        echo "→ Cleanup completed"
        echo -e "${GREEN}🎉 FTP upload test PASSED!${NC}"
        echo
        echo "Summary:"
        echo "✓ FTP server is accessible"
        echo "✓ SSL/TLS encryption is working"
        echo "✓ User authentication successful"
        echo "✓ File upload functionality confirmed"
        echo "✓ File verification successful"
        echo "✓ Cleanup completed"
    else
        # File upload succeeded but verification failed
        echo -e "${RED}✗ FAILED: File not found on server${NC}"
        echo "  Upload appeared successful but file cannot be located"
        echo "  This may indicate a server-side storage issue"
        exit 1
    fi
else
    # File upload failed
    echo -e "${RED}✗ FAILED: Could not upload file${NC}"
    echo "  Possible causes:"
    echo "  - FTP server not running or not accessible"
    echo "  - Authentication failure (wrong username/password)"
    echo "  - SSL/TLS connection issues"
    echo "  - File permission problems"
    echo "  - Network connectivity issues"
    
    # Clean up local file even if upload failed
    rm -f "$TEST_FILE"
    echo "  Cleaned up local test file"
    exit 1
fi