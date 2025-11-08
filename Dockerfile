FROM tomcat:latest
COPY webapp-VERSION.war /usr/local/tomcat/webapps/
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps