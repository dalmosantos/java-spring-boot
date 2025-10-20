# Spring Boot Course Management System

[![Build and Test](https://github.com/dalmosantos/java-spring-boot/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/dalmosantos/java-spring-boot/actions/workflows/build-and-test.yml)
[![Docker Build](https://github.com/dalmosantos/java-spring-boot/actions/workflows/docker-build-push.yml/badge.svg)](https://github.com/dalmosantos/java-spring-boot/actions/workflows/docker-build-push.yml)
[![Java Version](https://img.shields.io/badge/Java-21-orange)](https://openjdk.org/projects/jdk/21/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3.4-brightgreen)](https://spring.io/projects/spring-boot)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A modern course registration and management system built with Spring Boot 3, Java 21, and containerized with Docker.

## Features

- **Complete CRUD Operations** - Create, Read, Update, Delete for courses, students, and users
- **Access Control List (ACL)** - Role-based security with Spring Security
- **User Authentication** - Secure login system with encrypted passwords
- **Form Validation** - Server-side validation for data integrity
- **Responsive Design** - Bootstrap-based UI that works on all devices
- **RESTful Architecture** - Clean and maintainable code structure
- **Docker Support** - Easy deployment with Docker Compose
- **Database Flexibility** - Support for both PostgreSQL and MySQL

## Requirements

### Docker Installation (Recommended)
- Docker 20.10+
- Docker Compose 2.0+

### Traditional Installation
- Java JDK 21 (LTS)
- Maven 3.9+
- PostgreSQL 12+ or MySQL 5.7+

## Technologies

- **Backend**: Java 21, Spring Boot 3.3.4
- **Persistence**: Spring Data JPA, Hibernate
- **Security**: Spring Security 6
- **Template Engine**: Thymeleaf
- **Build Tool**: Maven 3.9+
- **Database**: PostgreSQL 16 / MySQL 8
- **Frontend**: Bootstrap 5, CSS3
- **Containerization**: Docker, Docker Compose

## Installation

### Option 1: Using Docker (Recommended)

The easiest way to run the application with all dependencies:

```bash
# Clone the repository
git clone https://github.com/dalmosantos/java-spring-boot.git
cd java-spring-boot

# Start all services (app + PostgreSQL)
docker-compose up -d

# Or use the convenience script
./docker-run.sh start
```

The application will be available at: **http://localhost:8080**

**Default Credentials:**
- Username: `admin`
- Password: `admin`

**Additional User:**
- Username: `user`
- Password: `user`

For detailed Docker commands and troubleshooting, see [DOCKER.md](DOCKER.md)

### Option 2: Traditional Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/dalmosantos/java-spring-boot.git
cd java-spring-boot
```

#### 2. Set Up Database

**For PostgreSQL:**

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database and import schema
CREATE DATABASE springcourse;
\c springcourse
\i spring_course_postgres.sql
\q
```

**For MySQL:**

```bash
# Connect to MySQL
mysql -u root -p

# Create database and import schema
CREATE DATABASE spring_course;
USE spring_course;
SOURCE spring_course.sql;
exit;
```

#### 3. Configure Database Connection

Edit `src/main/resources/application.properties`:

**For PostgreSQL:**
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/springcourse
spring.datasource.username=your_username
spring.datasource.password=your_password
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
```

**For MySQL:**
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/spring_course
spring.datasource.username=your_username
spring.datasource.password=your_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
```

#### 4. Set Up Java 21

Ensure Java 21 is installed and configured:

```bash
# Set JAVA_HOME (Linux/Mac)
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"

# Verify installation
java -version
```

#### 5. Build and Run

```bash
# Build the project
mvn clean package

# Run the application
mvn spring-boot:run

# Or run the JAR directly
java -jar target/spring-course-1.0.jar
```

Access the application at: **http://localhost:8080**

## Project Structure

```
java-spring-boot/
├── src/
│   ├── main/
│   │   ├── java/course/
│   │   │   ├── controller/      # MVC Controllers
│   │   │   ├── entity/          # JPA Entities
│   │   │   ├── repository/      # Data Access Layer
│   │   │   ├── service/         # Business Logic
│   │   │   ├── WebSecurityConfig.java
│   │   │   └── CrudbootApplication.java
│   │   └── resources/
│   │       ├── templates/       # Thymeleaf templates
│   │       ├── static/          # CSS, JS, fonts
│   │       └── application.properties
│   └── test/                    # Unit tests
├── docker-compose.yml           # Docker orchestration
├── Dockerfile                   # Container image
├── pom.xml                      # Maven configuration
└── docker-run.sh               # Convenience script
```

## Default Users

The application comes with two pre-configured users:

| Username | Password | Role  | Permissions     |
|----------|----------|-------|----------------|
| admin    | admin    | ADMIN | Full access    |
| user     | user     | USER  | Limited access |

**Note:** Change these credentials in production!

## Docker Quick Reference

```bash
# Start services
./docker-run.sh start

# View application logs
./docker-run.sh logs-app

# View database logs
./docker-run.sh logs-db

# Restart services
./docker-run.sh restart

# Stop services
./docker-run.sh stop

# Rebuild application
./docker-run.sh rebuild

# Access PostgreSQL console
./docker-run.sh psql

# View container status
./docker-run.sh status

# Clean up everything
./docker-run.sh clean
```

## Testing

Run the test suite:

```bash
# Run all tests
mvn test

# Run tests with coverage
mvn test jacoco:report

# Skip tests during build
mvn clean package -DskipTests
```

## Database Schema

The application manages three main entities:

- **Course** - Course information (ID, name)
- **Student** - Student details (ID, name, email, department)
- **User** - Authentication (ID, username, password, role)
- **Student_Course** - Many-to-many relationship between students and courses

## Configuration

### Application Properties

Key configuration options in `application.properties`:

```properties
# Server port
server.port=8080

# Database connection
spring.datasource.url=jdbc:postgresql://localhost:5432/springcourse
spring.datasource.username=springcourse
spring.datasource.password=springcourse123

# JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect

# Thymeleaf
spring.thymeleaf.cache=false
```

### Environment Variables (Docker)

You can override settings using environment variables:

```bash
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/springcourse
SPRING_DATASOURCE_USERNAME=springcourse
SPRING_DATASOURCE_PASSWORD=springcourse123
SPRING_JPA_HIBERNATE_DDL_AUTO=update
```

## Deployment

### Using Docker Compose (Production)

1. Update `docker-compose.yml` with production settings
2. Set strong passwords in environment variables
3. Configure proper volumes for data persistence
4. Deploy:

```bash
docker-compose -f docker-compose.yml up -d
```

### Traditional Deployment

1. Build the JAR:
   ```bash
   mvn clean package -DskipTests
   ```

2. Run with production profile:
   ```bash
   java -jar target/spring-course-1.0.jar --spring.profiles.active=prod
   ```

## Security

- Passwords are encrypted using BCrypt
- CSRF protection enabled
- Role-based access control (RBAC)
- SQL injection prevention via JPA
- XSS protection via Thymeleaf escaping

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🚀 CI/CD and Deployment

This project includes comprehensive GitHub Actions workflows for continuous integration and deployment:

### Available Workflows

- **Build and Test** - Automatic testing and building on every push/PR
- **Docker Build and Push** - Automated Docker image building and publishing to GitHub Container Registry
- **Deploy** - Manual deployment to different environments (dev/staging/production)
- **Release** - Automated release creation when tags are pushed

### Quick Start with CI/CD

```bash
# Build and test automatically triggered on push
git push origin main

# Create a release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# Deploy manually via GitHub Actions UI
# Go to Actions → Deploy Application → Run workflow
```

### Pull Docker Image

```bash
# Pull the latest image
docker pull ghcr.io/dalmosantos/java-spring-boot:latest

# Run the container
docker run -p 8080:8080 ghcr.io/dalmosantos/java-spring-boot:latest
```

For detailed deployment instructions, see:
- 📖 [Deployment Guide](.github/DEPLOYMENT_GUIDE.md) - Complete guide for deployment
- 🛠️ [Commands Reference](.github/COMMANDS.md) - Useful commands and scripts

## Contact

**Original Developer:** Danilo Meneghel
- Email: danilo.meneghel@gmail.com
- Website: http://danilomeneghel.github.io/

**Current Maintainer:** dalmosantos
- Repository: https://github.com/dalmosantos/java-spring-boot

## Acknowledgments

- Spring Framework team for excellent documentation
- Thymeleaf for the powerful template engine
- Bootstrap for responsive UI components
- The open-source community

## Screenshots

![Course List](screenshots/screenshot01.png)
*Course management interface*

![Student Management](screenshots/screenshot02.png)
*Student registration and editing*

![Login Page](screenshots/screenshot03.png)
*Secure authentication system*

![Course Details](screenshots/screenshot04.png)
*Detailed course information*

![User Management](screenshots/screenshot05.png)
*User administration panel*

![Student Details](screenshots/screenshot06.png)
*Student profile and enrolled courses*

![Add Course to Student](screenshots/screenshot07.png)
*Enroll students in courses*

![Responsive Design](screenshots/screenshot08.png)
*Mobile-friendly interface*

---

**If you find this project useful, please consider giving it a star!**
