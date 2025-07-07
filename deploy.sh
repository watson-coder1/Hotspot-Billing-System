#!/bin/bash

# WiFi Billing System Production Deployment Script
# This script helps deploy the system to production with proper security

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root for production deployment"
        exit 1
    fi
}

# Check system requirements
check_requirements() {
    print_status "Checking system requirements..."
    
    # Check OS
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        print_error "This script is designed for Linux systems"
        exit 1
    fi
    
    # Check available memory
    mem_total=$(free -m | awk 'NR==2{printf "%.0f", $2}')
    if [ $mem_total -lt 2048 ]; then
        print_warning "System has less than 2GB RAM. Performance may be affected."
    fi
    
    # Check available disk space
    disk_free=$(df / | awk 'NR==2 {print $4}')
    if [ $disk_free -lt 10485760 ]; then  # 10GB in KB
        print_error "Insufficient disk space. Need at least 10GB free."
        exit 1
    fi
    
    print_success "System requirements check passed"
}

# Install dependencies
install_dependencies() {
    print_status "Installing system dependencies..."
    
    # Update package list
    apt-get update
    
    # Install required packages
    apt-get install -y \
        curl \
        wget \
        git \
        unzip \
        openssl \
        iptables-persistent \
        fail2ban \
        ufw \
        htop \
        nginx \
        certbot \
        python3-certbot-nginx
    
    print_success "Dependencies installed"
}

# Configure firewall
configure_firewall() {
    print_status "Configuring firewall..."
    
    # Enable UFW
    ufw --force enable
    
    # Allow SSH
    ufw allow ssh
    
    # Allow HTTP/HTTPS
    ufw allow 80/tcp
    ufw allow 443/tcp
    
    # Allow RADIUS
    ufw allow 1812/udp
    ufw allow 1813/udp
    
    # Allow Docker ports
    ufw allow 33060/tcp  # MySQL external access if needed
    
    print_success "Firewall configured"
}

# Setup SSL certificates
setup_ssl() {
    print_status "Setting up SSL certificates..."
    
    read -p "Enter your domain name: " DOMAIN_NAME
    
    if [ -z "$DOMAIN_NAME" ]; then
        print_warning "No domain provided. Using self-signed certificates."
        mkdir -p ssl
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout ssl/nginx.key -out ssl/nginx.crt \
            -subj "/C=KE/ST=Nairobi/L=Nairobi/O=WiFiBilling/CN=$DOMAIN_NAME"
    else
        print_status "Setting up Let's Encrypt SSL for $DOMAIN_NAME"
        
        # Stop nginx if running
        systemctl stop nginx 2>/dev/null || true
        
        # Get SSL certificate
        certbot certonly --standalone -d $DOMAIN_NAME --non-interactive --agree-tos --email admin@$DOMAIN_NAME
        
        # Copy certificates to project directory
        mkdir -p ssl
        cp /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem ssl/nginx.key
        cp /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem ssl/nginx.crt
        
        # Setup auto-renewal
        echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -
    fi
    
    print_success "SSL certificates configured"
}

# Configure environment for production
configure_production_env() {
    print_status "Configuring production environment..."
    
    # Generate strong passwords
    DB_PASSWORD=$(openssl rand -base64 32)
    RADIUS_SECRET=$(openssl rand -base64 32)
    ADMIN_PASSWORD=$(openssl rand -base64 16)
    
    # Create production .env
    cat > .env << EOF
# Production Environment Configuration
# Generated on $(date)

# Database Configuration
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=billing
DB_USERNAME=billing_user
DB_PASSWORD=$DB_PASSWORD
RADIUS_DATABASE=radius

# M-pesa Configuration (Update with your credentials)
MPESA_CONSUMER_KEY=your_mpesa_consumer_key
MPESA_CONSUMER_SECRET=your_mpesa_consumer_secret
MPESA_PASSKEY=your_mpesa_passkey
MPESA_SHORTCODE=your_mpesa_shortcode
MPESA_ENVIRONMENT=live
MPESA_CALLBACK_URL=https://$DOMAIN_NAME/mpesa/callback

# FreeRADIUS Configuration
RADIUS_SECRET=$RADIUS_SECRET
RADIUS_DEBUG=no

# PHPNuxBill Configuration
PHPNUXBILL_ADMIN_EMAIL=admin@$DOMAIN_NAME
PHPNUXBILL_ADMIN_PASSWORD=$ADMIN_PASSWORD

# Network Configuration
ROUTER_IP=192.168.1.1
ROUTER_SECRET=$(openssl rand -base64 32)

# SSL Configuration
SSL_CERT_PATH=/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem
SSL_KEY_PATH=/etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem

# Backup Configuration
BACKUP_ENABLED=true
BACKUP_RETENTION_DAYS=30
BACKUP_PATH=/backups

# Monitoring Configuration
MONITORING_ENABLED=true
ALERT_EMAIL=alerts@$DOMAIN_NAME
EOF
    
    print_success "Production environment configured"
    print_warning "Please update M-pesa credentials in .env file"
}

# Setup monitoring and logging
setup_monitoring() {
    print_status "Setting up monitoring and logging..."
    
    # Create log directories
    mkdir -p /var/log/wifi_billing
    chmod 755 /var/log/wifi_billing
    
    # Setup logrotate
    cat > /etc/logrotate.d/wifi_billing << EOF
/var/log/wifi_billing/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 root root
}
EOF
    
    # Setup systemd service for monitoring
    cat > /etc/systemd/system/wifi-billing-monitor.service << EOF
[Unit]
Description=WiFi Billing System Monitor
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash $(pwd)/monitor.sh
User=root

[Install]
WantedBy=multi-user.target
EOF
    
    # Setup cron job for monitoring
    echo "*/5 * * * * /bin/bash $(pwd)/monitor.sh >> /var/log/wifi_billing/monitor.log 2>&1" | crontab -
    
    print_success "Monitoring configured"
}

# Setup backup system
setup_backup() {
    print_status "Setting up backup system..."
    
    # Create backup directory
    mkdir -p /backups
    chmod 700 /backups
    
    # Setup backup cron job
    echo "0 2 * * * /bin/bash $(pwd)/backup.sh >> /var/log/wifi_billing/backup.log 2>&1" | crontab -
    
    print_success "Backup system configured"
}

# Start the system
start_system() {
    print_status "Starting WiFi billing system..."
    
    # Start containers
    docker-compose up -d
    
    # Wait for services to be ready
    print_status "Waiting for services to start..."
    sleep 30
    
    # Check if services are running
    if docker-compose ps | grep -q "Up"; then
        print_success "System started successfully"
    else
        print_error "Some services failed to start"
        docker-compose logs
        exit 1
    fi
}

# Create production documentation
create_production_docs() {
    print_status "Creating production documentation..."
    
    cat > PRODUCTION_GUIDE.md << EOF
# Production Deployment Guide

## System Information
- **Domain**: $DOMAIN_NAME
- **Admin Email**: admin@$DOMAIN_NAME
- **Admin Password**: $ADMIN_PASSWORD
- **Database Password**: $DB_PASSWORD
- **RADIUS Secret**: $RADIUS_SECRET

## Access Information
- **Web Interface**: https://$DOMAIN_NAME
- **Admin Panel**: https://$DOMAIN_NAME/admin
- **RADIUS Server**: $DOMAIN_NAME:1812

## Security Information
- SSL certificates are automatically renewed
- Firewall is configured and active
- Monitoring is enabled
- Backups run daily at 2 AM

## Maintenance Commands
\`\`\`bash
# Check system status
./monitor.sh

# View logs
docker-compose logs

# Create backup
./backup.sh

# Update system
git pull
docker-compose down
docker-compose up -d
\`\`\`

## Emergency Contacts
- System Administrator: admin@$DOMAIN_NAME
- Technical Support: support@$DOMAIN_NAME

## Important Notes
1. Change default passwords immediately
2. Configure M-pesa credentials
3. Set up monitoring alerts
4. Test backup restoration
5. Document network topology
EOF
    
    print_success "Production documentation created: PRODUCTION_GUIDE.md"
}

# Main deployment function
main() {
    echo "=========================================="
    echo "WiFi Billing System Production Deployment"
    echo "=========================================="
    
    check_root
    check_requirements
    install_dependencies
    configure_firewall
    setup_ssl
    configure_production_env
    setup_monitoring
    setup_backup
    start_system
    create_production_docs
    
    echo "=========================================="
    echo "Production deployment completed!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Update M-pesa credentials in .env"
    echo "2. Configure your MikroTik router"
    echo "3. Test the system thoroughly"
    echo "4. Change default passwords"
    echo "5. Review PRODUCTION_GUIDE.md"
    echo ""
    echo "System is now running at:"
    echo "- Web Interface: https://$DOMAIN_NAME"
    echo "- Admin Panel: https://$DOMAIN_NAME/admin"
    echo ""
    echo "Default credentials:"
    echo "- Admin: admin@$DOMAIN_NAME / $ADMIN_PASSWORD"
    echo "- Database: billing_user / $DB_PASSWORD"
    echo ""
    echo "Security features enabled:"
    echo "- SSL/TLS encryption"
    echo "- Firewall protection"
    echo "- Automated monitoring"
    echo "- Daily backups"
    echo "- Log rotation"
    echo ""
    echo "For support, check:"
    echo "- System logs: /var/log/wifi_billing/"
    echo "- Container logs: docker-compose logs"
    echo "- Monitoring: ./monitor.sh"
}

# Run main function
main "$@" 