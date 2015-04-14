FROM phusion/baseimage:0.9.9

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh


RUN sed -i -e "s/http:\/\/archive.ubuntu.com/http:\/\/eu-west-1.ec2.archive.ubuntu.com/" /etc/apt/sources.list
RUN sed -i -e "s/^deb-src/# deb-src/" /etc/apt/sources.list
ADD nginx.list /etc/apt/sources.list.d/nginx.list
RUN gpg --keyserver keyserver.ubuntu.com --recv C300EE8C
RUN gpg --export --armor --output /tmp/8B3981E7A6852F782CC4951600A6F0A3C300EE8C.key 8B3981E7A6852F782CC4951600A6F0A3C300EE8C
RUN apt-key add /tmp/8B3981E7A6852F782CC4951600A6F0A3C300EE8C.key
RUN rm /tmp/8B3981E7A6852F782CC4951600A6F0A3C300EE8C.key

RUN apt-get update
RUN apt-get -y install python-pip python2.7-dev subversion libffi-dev nginx
RUN pip install Twisted 
RUN pip install Jinja2
RUN pip install pyOpenSSL
RUN svn export http://svn.codingteam.net/mysearch/src /opt/mysearch

RUN mkdir /etc/service/mysearch
ADD mysearch.sh /etc/service/mysearch/run

RUN mkdir /etc/service/nginx
ADD nginx.sh /etc/service/nginx/run
ADD nginx.conf /etc/nginx/nginx.conf
ADD mysearch.conf /etc/nginx/sites-available/default

EXPOSE 80
CMD ["/sbin/my_init"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


