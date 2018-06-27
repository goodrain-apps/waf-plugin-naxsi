FROM centos:7.4.1708

RUN yum makecache fast && \
    yum install -y epel-release && \
    yum install -y wget bzip2 gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel libxml2 libxml2-devel && \
    yum clean all

WORKDIR /opt/

RUN wget https://src.fedoraproject.org/lookaside/pkgs/jemalloc/jemalloc-3.4.0.tar.bz2/c4fa3da0096d5280924a5f7ebc8dbb1c/jemalloc-3.4.0.tar.bz2 && \
    tar xjf jemalloc-3.4.0.tar.bz2 && \
    cd jemalloc-3.4.0 && \
    ./configure && make && make install && \
    echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf && \
    ldconfig && \
    cd .. && \
    rm -rf ./jemalloc-3.4.0*

RUN wget http://nginx.org/download/nginx-1.14.0.tar.gz && \
    wget https://github.com/nbs-system/naxsi/archive/0.55.3.tar.gz && \
    tar xf nginx-1.14.0.tar.gz && \
    tar xf 0.55.3.tar.gz && \
    cd nginx-1.14.0 && \
    ./configure --conf-path=/etc/nginx/nginx.conf  --add-module=../naxsi-0.55.3/naxsi_src/  --error-log-path=/var/log/nginx/error.log  --http-client-body-temp-path=/usr/local/nginx/body  --http-fastcgi-temp-path=/usr/local/nginx/fastcgi  --http-uwsgi-temp-path=/usr/local/nginx/uwsgi  --http-scgi-temp-path=/usr/local/nginx/scgi  --http-log-path=/var/log/nginx/access.log  --http-proxy-temp-path=/usr/local/nginx/proxy  --lock-path=/var/run/nginx.lock  --pid-path=/var/run/nginx.pid  --with-http_ssl_module --with-stream  --with-ld-opt="-ljemalloc"  --with-http_addition_module  --with-http_realip_module  --with-http_gunzip_module  --without-mail_pop3_module  --without-mail_smtp_module  --without-mail_imap_module  --without-http_uwsgi_module  --without-http_scgi_module  --sbin-path=/usr/sbin/nginx  --prefix=/usr/share/nginx && \
    make && make install && \
    cp /opt/naxsi-0.55.3/naxsi_config/naxsi_core.rules /etc/nginx/ && \
    cd .. && rm -rf /opt/*

RUN mkdir -p /usr/local/nginx/body && \
    mkdir -p /var/www/html && \
    echo "# Waiting..." > /var/www/html/index.html

WORKDIR /etc/nginx
COPY nginx.conf nginx.conf.template /etc/nginx/

COPY bootstrap.sh confd /usr/local/bin/
CMD bootstrap.sh
