FROM centos:7

MAINTAINER Ryng.G.Sun 

# install tools
RUN yum -y update ;\
    yum -y install git openssh-server openssh-clients wget sudo vim ; \
    yum clean all  

# create user jenkinsbuild
RUN set -eux &&\ 
    useradd --create-home --no-log-init --shell /bin/bash jenkinsbuild \
    && echo 'jenkinsbuild:jenkinsbuild' | chpasswd \
    && groupadd docker \
    && usermod -aG docker jenkinsbuild \
    && usermod -aG root jenkinsbuild \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key  \
    && sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config \
    && sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config \
    && echo 'AllowUsers jenkinsbuild' >> /etc/ssh/sshd_config \
    && mkdir /var/run/sshd \
    && sed -i 's/root	ALL=(ALL) 	ALL/root	ALL=(ALL) 	ALL\njenkinsbuild	ALL=(ALL) 	NOPASSWD: ALL/g' /etc/sudoers \
    && echo 'source /etc/profile' >> /home/jenkinsbuild/.bashrc 

   
WORKDIR /home/jenkinsbuild/ci-jenkins

# install entrypoint
COPY entrypoint.sh /usr/local/bin/ 
RUN set -eux &&\
    chown -R jenkinsbuild:jenkinsbuild /home/jenkinsbuild/ci-jenkins \
    && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22 
   
ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
