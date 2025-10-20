#!/bin/bash

# Script to manage Spring Boot application with Docker

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_help() {
    cat << EOF
Usage: ./docker-run.sh [COMMAND]

Available commands:
  start       - Start services (app + PostgreSQL)
  stop        - Stop services
  restart     - Restart services
  rebuild     - Rebuild and restart application
  logs        - Show logs for all services
  logs-app    - Show application logs only
  logs-db     - Show PostgreSQL logs only
  status      - Show container status
  clean       - Stop and remove containers, networks and volumes
  psql        - Access PostgreSQL console
  help        - Show this help message

Examples:
  ./docker-run.sh start
  ./docker-run.sh logs-app
  ./docker-run.sh rebuild

EOF
}

case "$1" in
    start)
        print_info "Starting services..."
        docker-compose up -d
        print_info "Waiting for application to initialize..."
        sleep 5
        print_info "Application available at: http://localhost:8080"
        ;;
    
    stop)
        print_info "Stopping services..."
        docker-compose down
        print_info "Services stopped successfully"
        ;;
    
    restart)
        print_info "Restarting services..."
        docker-compose restart
        print_info "Services restarted successfully"
        ;;
    
    rebuild)
        print_info "Rebuilding application..."
        docker-compose build --no-cache app
        print_info "Restarting application..."
        docker-compose up -d app
        print_info "Application rebuilt and restarted"
        ;;
    
    logs)
        docker-compose logs -f
        ;;
    
    logs-app)
        docker-compose logs -f app
        ;;
    
    logs-db)
        docker-compose logs -f postgres
        ;;
    
    status)
        docker-compose ps
        ;;
    
    clean)
        print_warn "This will remove all containers, networks and volumes!"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Removing everything..."
            docker-compose down -v
            print_info "Cleanup completed"
        else
            print_info "Operation cancelled"
        fi
        ;;
    
    psql)
        print_info "Connecting to PostgreSQL..."
        docker exec -it spring-course-postgres psql -U springcourse -d springcourse
        ;;
    
    help|--help|-h)
        show_help
        ;;
    
    *)
        print_error "Invalid command: $1"
        echo
        show_help
        exit 1
        ;;
esac
