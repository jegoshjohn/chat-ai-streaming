#!/bin/bash

# Docker deployment script for chat application
# Usage: ./deploy.sh [dev|prod|local]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Function to check environment variables
check_env() {
    if [ -z "$OPENAI_API_KEY" ]; then
        print_warning "OPENAI_API_KEY environment variable is not set"
        print_status "Please set it with: export OPENAI_API_KEY='your-api-key'"
        read -p "Do you want to continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "Environment variables are set"
    fi
}

# Function to clean up containers and images
cleanup() {
    print_status "Cleaning up old containers and images..."
    docker-compose down --remove-orphans
    docker system prune -f
}

# Function to build and start services
deploy() {
    local environment=$1
    
    print_status "Deploying in $environment mode..."
    
    case $environment in
        "dev")
            NODE_ENV=development docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build
            ;;
        "prod")
            NODE_ENV=production docker-compose up --build -d
            ;;
        "local")
            docker-compose up --build
            ;;
        *)
            print_error "Invalid environment. Use: dev, prod, or local"
            exit 1
            ;;
    esac
}

# Function to show logs
show_logs() {
    print_status "Showing logs..."
    docker-compose logs -f
}

# Function to stop services
stop_services() {
    print_status "Stopping services..."
    docker-compose down
    print_success "Services stopped"
}

# Function to show status
show_status() {
    print_status "Container status:"
    docker-compose ps
}

# Function to show help
show_help() {
    echo "Usage: $0 [COMMAND] [ENVIRONMENT]"
    echo ""
    echo "Commands:"
    echo "  deploy [dev|prod|local]  Deploy the application"
    echo "  logs                     Show logs"
    echo "  stop                     Stop services"
    echo "  status                   Show container status"
    echo "  cleanup                  Clean up containers and images"
    echo "  help                     Show this help message"
    echo ""
    echo "Environments:"
    echo "  dev                      Development mode with hot reload"
    echo "  prod                     Production mode"
    echo "  local                    Local mode (default docker-compose)"
    echo ""
    echo "Examples:"
    echo "  $0 deploy dev"
    echo "  $0 deploy prod"
    echo "  $0 logs"
    echo "  $0 stop"
}

# Main script logic
main() {
    local command=$1
    local environment=$2
    
    # Check prerequisites
    check_docker
    check_env
    
    case $command in
        "deploy")
            if [ -z "$environment" ]; then
                print_error "Please specify environment: dev, prod, or local"
                exit 1
            fi
            cleanup
            deploy $environment
            print_success "Deployment completed!"
            print_status "Frontend: http://localhost:3000"
            print_status "Backend: http://localhost:8000"
            print_status "API Docs: http://localhost:8000/docs"
            ;;
        "logs")
            show_logs
            ;;
        "stop")
            stop_services
            ;;
        "status")
            show_status
            ;;
        "cleanup")
            cleanup
            print_success "Cleanup completed!"
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            print_error "No command specified"
            show_help
            exit 1
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@" 