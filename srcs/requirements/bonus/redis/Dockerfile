FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y vim redis-server

EXPOSE 6379

# Create data directory
RUN mkdir -p /data && chown redis:redis /data

# Set working directory for Redis data
WORKDIR /data

CMD ["redis-server", "--bind", "0.0.0.0", "--port", "6379", "--protected-mode", "no", "--save", "60", "1", "--dir", "/data"]