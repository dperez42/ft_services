FROM alpine:latest

# Install Grafana
RUN apk update && apk add openrc \
&& apk add --no-cache --upgrade bash \
&& rm -rf /var/cache/apk/*

# Wordpress from my computer
COPY	srcs/grafana-7.1.5 ./grafana-7.1.5/

# Wordpress from www
#RUN wget https://dl.grafana.com/oss/release/grafana-7.1.5.linux-amd64.tar.gz \
#&& tar -zxf grafana-7.1.5.linux-amd64.tar.gz \
#&& rm -r grafana-7.1.5.linux-amd64.tar.gz

RUN mv grafana-7.1.5 grafana 

# Required by grafana-server dependency to run grafana binary
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

ADD /srcs/datasource.yaml 			grafana/conf/provisioning/datasources/
ADD /srcs/dashboard.yaml 			grafana/conf/provisioning/dashboards/
ADD /srcs/dashboard_overview.json 	/var/lib/grafana/dashboards/
ADD /srcs/isalivegrafana.sh         /live/isalivegrafana.sh
ADD /srcs/setup.sh 			        /srcs/setup.sh

RUN rm  -rf ./grafana-7.1.5

EXPOSE 3000

#USER grafana

CMD ["sh", "/srcs/setup.sh"]
