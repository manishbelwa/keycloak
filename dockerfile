
FROM registry.access.redhat.com/ubi8-minimal
FROM jboss/base-jdk:8

ENV KEYCLOAK_VERSION 13.0.0

ENV KEYCLOAK_USER admin
ENV KEYCLOAK_PASSWORD India@123

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING true

WORKDIR /server
ADD . /server
USER root
RUN chmod +rwx /server

ENV JBOSS_HOME /server
ENV LANG en_US.UTF-8

#ARG GIT_REPO
#ARG GIT_BRANCH
#ARG KEYCLOAK_DIST=https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz

ENV JAVA /usr/lib/jvm/java/bin/java

ENV JAVA_OPTS -server -Xms64m -Xmx512m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true



#RUN microdnf update -y && microdnf install -y glibc-langpack-en gzip hostname java-8-openjdk-headless openssl tar which && microdnf clean all

#ADD tools /opt/jboss/tools
#COPY . /opt/jboss
#RUN /opt/jboss/tools/build-keycloak.sh

#USER 1000
RUN chmod +rwx /server/bin/standalone.sh
RUN chmod +rwx /server/bin/add-user.sh
RUN chmod +rwx /server/bin/add-user-keycloak.sh
EXPOSE 8080
#EXPOSE 8443


#ENTRYPOINT [ "/bin/standalone.sh" ]

#CMD ["-b", "0.0.0.0"]
RUN /server/bin/add-user.sh admin India@123 --silent
RUN /server/bin/add-user-keycloak.sh -r master -u admin -p India@123
CMD ["/server/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
