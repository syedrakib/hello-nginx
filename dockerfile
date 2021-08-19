FROM ubuntu:21.10
RUN apt-get update

# Set TimeZone
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Kuala_Lumpur
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Download nginx
ARG NGINX_VERSION="1.21.1"
WORKDIR /
RUN apt-get install -y wget
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar -zxf nginx-${NGINX_VERSION}.tar.gz
RUN rm nginx-${NGINX_VERSION}.tar.gz
WORKDIR /nginx-${NGINX_VERSION}

# Install nginx
ARG NGINX_PATH="/etc/nginx"
RUN apt-get install -y build-essential # "needed for compiler to 'configure' nginx source"
RUN apt-get install -y libpcre3-dev # libpcre3 # "needed to 'configure' nginx source"
RUN apt-get install -y zlib1g-dev # zlib1g # "needed to 'configure' nginx source"
RUN apt-get install -y libssl-dev # "needed for http_ssl_module"
RUN ./configure \
  --prefix=${NGINX_PATH} \
  --with-pcre \
  --with-http_ssl_module
RUN make
RUN make install
RUN ln -s ${NGINX_PATH}/sbin/nginx /usr/sbin/nginx

# Run nginx
CMD echo "NGINX is listening..." && nginx -g "daemon off;" # to run in foreground
