FROM alpine:latest

# Install FTPS and dependencis
RUN apk update \
&& apk add --no-cache --upgrade bash \
&& apk add vsftpd && apk add openssl curl \
&& rm -rf /var/cache/apk/*

ADD /srcs/vsftpd.conf			/etc/vsftpd/vsftpd.conf
ADD /srcs/isaliveftps.sh     	/live/isaliveftps.sh
ADD /srcs/setup.sh				/srcs/setup.sh

# CONFIG OPENSSL
RUN openssl req -x509 -nodes -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=1localhost" \
		 -days 365 -newkey rsa:2048 \
		 -keyout /etc/ssl/private/vsftpd.key \
		 -out /etc/ssl/certs/vsftpd.crt

EXPOSE 20 21 21000-21010

CMD ["sh", "/srcs/setup.sh"]