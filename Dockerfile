FROM ubuntu:14.04
# Keep upstart from complaining
#RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list

RUN apt-get install -y nginx
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update


RUN apt-get install -y php5-fpm php5-mysql


# Install Nginx

# Install MySQL.
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
  echo "mysqld_safe &" > /tmp/config && \
  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
  bash /tmp/config && \
  rm -f /tmp/config


RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
#RUN apt-get install -y wget
#RUN wget -O /etc/nginx/sites-available/default https://gist.github.com/darron/6159214/
#raw/30a60885df6f677bfe6f2ff46078629a8913d0bc/gistfile1.txt
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD nginx-site.conf /etc/nginx/sites-available/default
ADD index.php /usr/share/nginx/www/index.php



ADD run.sh /run.sh
RUN chmod u+x /run.sh
WORKDIR /

CMD ["/run.sh"]


