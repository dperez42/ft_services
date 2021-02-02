FROM alpine:latest

# Install Influxdb and Telegraf
RUN apk update 
RUN apk add openrc influxdb

ADD /srcs/setup.sh 		/srcs/setup.sh
ADD /srcs/isaliveinfluxdb.sh     /live/isaliveinfluxdb.sh

EXPOSE 8086

CMD ["sh", "/srcs/setup.sh"]