# fetch basic image
FROM maven:3.9.5-eclipse-temurin-11

# install nginx
RUN apt-get update && apt-get install -y nginx

# application placed into /opt/app
RUN mkdir -p /app
WORKDIR /app

# selectively add the POM file and
# install dependencies
COPY pom.xml /app/
RUN mvn install

# rest of the project
COPY src /app/src
RUN mvn package

# copy nginx configuration file
COPY nginx.conf /etc/nginx

# local application port
EXPOSE 8000

# start nginx and run the application
CMD service nginx start && java -jar target/cqlTranslationServer-2.4.0.jar -d
# CMD service nginx start || cat /var/log/nginx/error.log
