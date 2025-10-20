# Docker Setup Guide

This guide explains how to run the Spring Boot project with PostgreSQL using Docker.

## Prerequisites

- Docker installed (20.10+)
- Docker Compose installed (2.0+)

## Structure

- `Dockerfile`: Multi-stage image for application build and runtime
- `docker-compose.yml`: Service orchestration (app + PostgreSQL)
- `application-docker.properties`: Docker-specific configurations
- `docker-run.sh`: Convenience script for common operations

## Quick Start

### 1. Start Services

```bash
docker-compose up -d
```

This command will:
- Build the Spring Boot application image
- Create and start the PostgreSQL container
- Create and start the application container
- Initialize the database with the `spring_course_postgres.sql` script

### 2. View Logs

```bash
# All services logs
docker-compose logs -f

# Application logs only
docker-compose logs -f app

# PostgreSQL logs only
docker-compose logs -f postgres
```

### 3. Access the Application

The application will be available at: http://localhost:8080

**Default Credentials:**
- Username: `admin` / Password: `admin`
- Username: `user` / Password: `user`

### 4. Stop Services

```bash
docker-compose down
```

To also remove volumes (database data):
```bash
docker-compose down -v
```

## Convenience Script

The `docker-run.sh` script provides easy access to common Docker operations:

```bash
# Start all services
./docker-run.sh start

# Stop all services
./docker-run.sh stop

# Restart services
./docker-run.sh restart

# Rebuild application
./docker-run.sh rebuild

# View all logs
./docker-run.sh logs

# View application logs
./docker-run.sh logs-app

# View database logs
./docker-run.sh logs-db

# Check container status
./docker-run.sh status

# Access PostgreSQL console
./docker-run.sh psql

# Clean up everything (containers, networks, volumes)
./docker-run.sh clean

# Show help
./docker-run.sh help
```

## Useful Commands

### Rebuild Application

If you make code changes:
```bash
docker-compose up -d --build app

# Or using the script
./docker-run.sh rebuild
```

### Access Application Container

```bash
docker exec -it spring-course-app sh
```

### Access PostgreSQL

```bash
# Using the script
./docker-run.sh psql

# Or directly
docker exec -it spring-course-postgres psql -U springcourse -d springcourse
```

### View Container Status

```bash
docker-compose ps

# Or using the script
./docker-run.sh status
```

### View Resource Usage

```bash
docker stats spring-course-app spring-course-postgres
```

## Configuration

### Database Settings

- **Host**: postgres (internally) / localhost (externally)
- **Port**: 5432
- **Database**: springcourse
- **Username**: springcourse
- **Password**: springcourse123

### Application Settings

- **Port**: 8080
- **Profile**: Uses environment variables for Docker configuration

## Environment Variables

You can customize settings by editing `docker-compose.yml` or creating a `.env` file:

```env
# PostgreSQL Configuration
POSTGRES_DB=springcourse
POSTGRES_USER=springcourse
POSTGRES_PASSWORD=springcourse123

# Spring Boot Configuration
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/springcourse
SPRING_DATASOURCE_USERNAME=springcourse
SPRING_DATASOURCE_PASSWORD=springcourse123
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_JPA_DATABASE_PLATFORM=org.hibernate.dialect.PostgreSQLDialect
SPRING_JPA_SHOW_SQL=true
```

## Troubleshooting

### Application Not Connecting to Database

1. Check if PostgreSQL is healthy:
   ```bash
   docker-compose ps
   ```

2. View PostgreSQL logs:
   ```bash
   docker-compose logs postgres
   ```

3. Ensure the database is fully initialized:
   ```bash
   docker-compose exec postgres pg_isready -U springcourse
   ```

### Rebuild Everything from Scratch

```bash
# Stop and remove everything
docker-compose down -v

# Rebuild without cache
docker-compose build --no-cache

# Start services
docker-compose up -d
```

### Clean Up Old Images and Volumes

```bash
# Remove unused containers, networks, images
docker system prune -a

# Remove unused volumes
docker volume prune

# Or clean everything
docker system prune -a --volumes
```

### Port Already in Use

If port 8080 or 5432 is already in use, you can change them in `docker-compose.yml`:

```yaml
services:
  postgres:
    ports:
      - "5433:5432"  # Change host port
  
  app:
    ports:
      - "8081:8080"  # Change host port
```

### Database Data Persistence

Database data is stored in a Docker volume named `postgres-data`. To backup:

```bash
# Backup database
docker exec spring-course-postgres pg_dump -U springcourse springcourse > backup.sql

# Restore database
docker exec -i spring-course-postgres psql -U springcourse springcourse < backup.sql
```

## Docker Image Optimization

The Dockerfile uses multi-stage builds for optimization:

1. **Build Stage**: Uses Maven to compile the application
2. **Runtime Stage**: Uses JRE-only image to reduce size
3. **Non-root User**: Runs application with restricted permissions
4. **Health Check**: Monitors application health

## Production Deployment

For production, consider:

1. **Update passwords** in environment variables
2. **Enable SSL/TLS** for database connections
3. **Configure resource limits**:

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

4. **Use secrets** instead of environment variables:

```yaml
services:
  postgres:
    secrets:
      - db_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

5. **Enable logging drivers** for centralized logging
6. **Set up monitoring** with health checks and alerts

## Health Checks

The application includes health checks:

```bash
# Check application health
curl http://localhost:8080/actuator/health

# Docker health status
docker inspect --format='{{.State.Health.Status}}' spring-course-app
```

## Networking

Both containers run on the same network (`spring-network`), allowing them to communicate using service names:

- Application connects to database using hostname `postgres`
- External access uses `localhost`

## Volume Management

```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect java-spring-boot_postgres-data

# Backup volume
docker run --rm -v java-spring-boot_postgres-data:/data -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz /data

# Restore volume
docker run --rm -v java-spring-boot_postgres-data:/data -v $(pwd):/backup alpine tar xzf /backup/postgres-backup.tar.gz -C /
```

## Further Reading

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Docker Image](https://hub.docker.com/_/postgres)
- [Spring Boot Docker Guide](https://spring.io/guides/gs/spring-boot-docker/)

---

For general application documentation, see [README.md](README.md)
