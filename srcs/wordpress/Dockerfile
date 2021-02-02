FROM alpine:latest

# Install Wordpress and dependencies
RUN apk update \
&& apk add php7 php7-fpm php7-opcache \
php7-gd php7-mysqli php7-zlib php7-curl \
php7-mbstring php7-json php7-session

# Wordpress from my computer
COPY	srcs/wordpress ./wordpress/

# Wordpress from www
#RUN wget https://wordpress.org/latest.tar.gz \
#&& tar -xvf latest.tar.gz \
#&& rm latest.tar.gz 

RUN mkdir /www \
    && mv wordpress/ www/ \
    && rm /www/wordpress/wp-config-sample.php \
        /www/wordpress/license.txt \
        /www/wordpress/readme.html

ADD /srcs/setup.sh 			/srcs/setup.sh
ADD /srcs/isalivewordpress.sh     /live/isalivewordpress.sh

RUN rm  -rf ./wordpress

EXPOSE 5050
CMD ["sh", "/srcs/setup.sh"]