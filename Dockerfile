FROM gradle:7.3.1-jdk17-alpine AS builder
COPY --chown=gradle:gradle . /home/gradle/src
ADD https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.14/bin/apache-tomcat-10.0.14.tar.gz /home/gradle/src/
WORKDIR /home/gradle/src
RUN tar xvf apache-tomcat*.tar.gz
RUN gradle bootJar --no-daemon


FROM openjdk:8u181-jdk-alpine
EXPOSE 8080
RUN mkdir /app
COPY --from=builder /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar
COPY --from=builder /home/gradle/src/apache-tomcat-10.0.14/lib/*.jar /app/lib/
CMD ["java", "-cp", "/app/lib/el-api.jar", "-jar", "/app/spring-boot-application.jar"]
