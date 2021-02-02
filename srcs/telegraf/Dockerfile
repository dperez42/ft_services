FROM alpine:latest

RUN apk add openrc

# Install Telegraf
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz \
&& tar -zxf telegraf-1.15.2_linux_amd64.tar.gz \
&& mv telegraf-1.15.2 telegraf \
&& rm telegraf-1.15.2_linux_amd64.tar.gz
RUN cp -rf telegraf/etc/* /etc/
RUN cp -rf telegraf/usr/* /usr/

# Required by telegraf
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
ADD /srcs/isalivetelegraf.sh     /live/isalivetelegraf.sh
ADD /srcs/telegraf.conf 	/etc/telegraf/telegraf.conf
ADD /srcs/setup.sh 				/srcs/setup.sh

EXPOSE 8125

CMD ["sh", "/srcs/setup.sh"]