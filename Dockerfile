# Multi-stage build for Online Bookstore Servlet/JSP WAR application
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy dependency definition and source code
COPY pom.xml .
COPY src ./src

# Build the WAR package
RUN mvn clean package -DskipTests

# Run stage using Apache Tomcat 9 (supports javax.servlet 4.0)
FROM tomcat:9.0-jdk17-temurin

# Clear default Tomcat sample apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy application as ROOT webapp so it's accessible at '/'
COPY --from=builder /app/target/online-bookstore.war /usr/local/tomcat/webapps/ROOT.war

# Cloud PaaS port binding (e.g., Render sets $PORT dynamically)
ENV PORT=8080
EXPOSE 8080

# Dynamically bind Tomcat HTTP connector to $PORT and start catalina
CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'\"$PORT\"'\"/g' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
