FROM debian:12

RUN apt-get update && apt-get upgrade -y && apt-get install -y vim vsftpd netcat openssl

COPY conf/vsftpd.conf /etc/vsftpd.conf

COPY /tools/ftp.sh /

EXPOSE 20 21 22 40000:40005

RUN chmod +x /ftp.sh

CMD ["/ftp.sh"]