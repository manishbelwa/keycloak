
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

ENV JAVA /usr/lib/jvm/java/bin/java

ENV JAVA_OPTS -server -Xms64m -Xmx512m -XX:MetaspaceSize=96M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.byteman -Djava.awt.headless=true

#ADD tools /opt/jboss/tools
#COPY . /opt/jboss
#RUN /opt/jboss/tools/build-keycloak.sh

#USER 1000
RUN chmod +rwx /server/bin/standalone.sh
RUN chmod +rwx /server/bin/add-user.sh
RUN chmod +rwx /server/bin/add-user-keycloak.sh
EXPOSE 8080
EXPOSE 8443

### To disable cache
#RUN sed -i -E "s/(<staticMaxAge>)2592000(<\/staticMaxAge>)/\1\-1\2/" /opt/jboss/keycloak/standalone/configuration/standalone.xml
#RUN sed -i -E "s/(<cacheThemes>)true(<\/cacheThemes>)/\1false\2/" /opt/jboss/keycloak/standalone/configuration/standalone.xml
#RUN sed -i -E "s/(<cacheTemplates>)true(<\/cacheTemplates>)/\1false\2/" /opt/jboss/keycloak/standalone/configuration/standalone.xml

### To enable cache
#RUN sed -i -E "s/(<staticMaxAge>)-1(<\/staticMaxAge>)/\1\2592000\2/" /opt/jboss/keycloak/standalone/configuration/standalone.xml
#RUN sed -i -E "s/(<cacheThemes>)false(<\/cacheThemes>)/\1true\2/" /opt/jboss/keycloak/standalone/configuration/standalone.xml
#RUN sed -i -E "s/(<cacheTemplates>)false(<\/cacheTemplates>)/\1true\2/" /opt/jboss/keycloak/standalone/configuration/standalone.xml

RUN /server/bin/add-user.sh admin India@123 --silent
RUN /server/bin/add-user-keycloak.sh -r master -u admin -p India@123
CMD ["/server/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
