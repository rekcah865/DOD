## From Oracle Linux 6
FROM oraclelinux:6.7

MAINTAINER Wei.Shen <rekcah865@gmail.com>

## Base setting
RUN echo "proxy=http://10.40.3.249:3128" >> /etc/yum.conf
RUN ln -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo ZONE="Asia/Shanghai" > /etc/sysconfig/clock

## SSH
RUN yum -y install openssh-server passwd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
EXPOSE 22

## Oracle User 
RUN mkdir -p /u01/usr 
RUN groupadd -g 300 dba
RUN useradd -u 3001 -s /bin/bash -d /u01/usr/oracle -g dba oracle
RUN echo "oracle:oracle"|chapasswd
ADD oracle_profile /u01/usr/oracle/.bash_profile

## Oracle 11gR2 
RUN yum -y install oracle-rdbms-server-11gR2-preinstall perl unzip
RUN mkdir -p /u01/source
ADD p13390677_112040_Linux-x86-64_1of7.zip /tmp/p13390677_112040_Linux-x86-64_1of7.zip
ADD p13390677_112040_Linux-x86-64_2of7.zip /tmp/p13390677_112040_Linux-x86-64_2of7.zip
WORKDIR /u01/source
RUN unzip /tmp/p13390677_112040_Linux-x86-64_1of7.zip && rm /tmp/p13390677_112040_Linux-x86-64_1of7.zip
RUN unzip /tmp/p13390677_112040_Linux-x86-64_2of7.zip && rm /tmp/p13390677_112040_Linux-x86-64_2of7.zip
RUN chown -R oracle:dba /u01/source/database
USER oracle
ADD 11204_db_install.rsp /tmp/11204_db_install.rsp
RUN /u01/source/database/runInstaller -silent -force -waitforcompletion -responsefile /tmp/11204_db_install.rsp -ignoresysprereqs -ignoreprereq

USER root
RUN /u01/app/oraInventory/orainstRoot.sh
RUN /u01/app/oracle/product/11.2.0/root.sh -silent

ENTRYPOINT ["/usr/sbin/sshd", "-D"]




