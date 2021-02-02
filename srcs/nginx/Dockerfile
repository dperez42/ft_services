FROM alpine:latest

# Install Nginx and dependencies
RUN apk update && apk add openrc \
&& apk add --no-cache --upgrade bash \
&& apk add nginx openssl openssh \
&& rm -rf /var/cache/ap/*

ADD /srcs/nginx.conf		/etc/nginx/nginx.conf
RUN mkdir www
ADD /srcs/index.html		/www/index.html
ADD /srcs/grafana_icon.png	/www/grafana_icon.png
ADD /srcs/phpmyadmin_icon.png	/www/phpmyadmin_icon.png
ADD /srcs/wordpress_icon.png	/www/wordpress_icon.png
ADD /srcs/nginx_icon.png	/www/nginx_icon.png
ADD /srcs/isalivenginx.sh     /live/isalivenginx.sh   

# CONFIG SSL
RUN openssl req -x509 -nodes -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=127.0.0.1" \
		 -days 365 -newkey rsa:2048 \
		 -keyout /etc/ssl/private/nginx-selfsigned.key \
		 -out /etc/ssl/certs/nginx-selfsigned.crt && \
		openssl dhparam -out /etc/nginx/dhparam.pem 1000

# CONGIF SSH
ADD /srcs/sshd_config 		/etc/ssh/
#ADD /srcs/id_rsa_key_ssh 	/etc/ssh/ssh_host_rsa_key
#RUN chmod 600 /etc/ssh/ssh_host_rsa_key

EXPOSE 22 80 443

# Nginx starting y # SSH starting

CMD echo -e "$PASSWORD\n$PASSWORD" | adduser $USER &&\
	openrc && \
	touch /run/openrc/softlevel && \
	service nginx start && \
	service sshd start && \
	tail -f /dev/null 
