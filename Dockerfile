FROM htmlgraphic/base
MAINTAINER Jason Gegere <jason@htmlgraphic.com>

# Install packages then remove cache package list information
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    supervisor \
    rsyslog \
    postfix && rm -rf /var/lib/apt/lists/*


# SUPERVISOR
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/

# POSTFIX
ADD ./build_tests.sh /opt/build_tests.sh
ADD ./postfix.sh /opt/postfix.sh
RUN chmod 755 /opt/build_tests.sh && chmod 755 /opt/postfix.sh && cp /etc/hostname /etc/mailname

ADD preseed.txt .
RUN debconf-set-selections preseed.txt && rm preseed.txt

ADD virtual /etc/postfix/virtual
RUN sudo postmap /etc/postfix/virtual


# Note that EXPOSE only works for inter-container links. It doesn't make ports accessible from the host. To expose port(s) to the host, at runtime, use the -p flag.
EXPOSE 25


ADD run.sh .
RUN chmod 755 /run.sh
CMD ["/bin/bash", "/run.sh"]