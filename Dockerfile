FROM ubuntu:14.04
MAINTAINER David Muto <david.muto@gmail.com>
ENV REFRESHED_AT 2016-08-27-v1

# Prerequisite packages
RUN apt-get -y update && apt-get -y install curl psmisc

RUN curl -s http://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/cloudera.list \
      > /etc/apt/sources.list.d/cloudera.list

RUN curl -s http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key | apt-key add -

# Update apt sources
RUN apt-get -y update

# Install Oracle JDK
RUN apt-get -y install oracle-j2sdk1.7

# Install CDM Server packages
RUN apt-get -y install cloudera-manager-server-db-2 cloudera-manager-daemons cloudera-manager-server

RUN echo "#!/bin/bash\nset -xeuo pipefail\nservice cloudera-scm-server-db start" > /usr/bin/launch
RUN echo "service cloudera-scm-server start\n" >> /usr/bin/launch
RUN echo "less +F /var/log/cloudera-scm-server/cloudera-scm-server.log" >> /usr/bin/launch
RUN chmod u+x /usr/bin/launch

ENV _JAVA_OPTIONS "-d64 -Xmx2G -XX:MaxPermSize=256m"
EXPOSE 7180
EXPOSE 7183

ENTRYPOINT /usr/bin/launch
