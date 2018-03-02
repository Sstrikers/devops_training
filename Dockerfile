FROM tomcat:alpine
ARG currentVersion
RUN wget -P /usr/local/tomcat/webapps/ http://192.168.56.10:8081/nexus/content/repositories/snapshots/task7/${currentVersion}/test.war 
