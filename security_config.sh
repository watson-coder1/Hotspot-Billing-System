#!/bin/bash

# WiFi Billing System Security Configuration
# This script enhances the security of the system

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

# Generate SSL certificates
generate_ssl_certs() {
    print_status "Generating SSL certificates..."
    
    mkdir -p ssl
    
    # Generate self-signed certificate for development
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ssl/nginx.key -out ssl/nginx.crt \
        -subj "/C=KE/ST=Nairobi/L=Nairobi/O=WiFiBilling/CN=localhost"
    
    print_success "SSL certificates generated"
}

# Configure firewall rules
configure_firewall() {
    print_status "Configuring firewall rules..."
    
    # Create firewall configuration
    cat > firewall.rules << 'EOF'
# WiFi Billing System Firewall Rules

# Allow SSH
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP/HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow RADIUS
iptables -A INPUT -p udp --dport 1812 -j ACCEPT
iptables -A INPUT -p udp --dport 1813 -j ACCEPT

# Allow MySQL (only from localhost)
iptables -A INPUT -p tcp --dport 3306 -s 127.0.0.1 -j ACCEPT

# Allow Docker network
iptables -A INPUT -s 172.16.0.0/12 -j ACCEPT
iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT

# Drop all other incoming traffic
iptables -A INPUT -j DROP

# Save rules
iptables-save > /etc/iptables/rules.v4
EOF
    
    print_success "Firewall rules created: firewall.rules"
}

# Create security monitoring script
create_security_monitor() {
    print_status "Creating security monitoring script..."
    
    cat > security_monitor.sh << 'EOF'
#!/bin/bash

# WiFi Billing System Security Monitor

LOG_FILE="/var/log/security_monitor.log"
ALERT_EMAIL="alerts@yourdomain.com"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_message() {
    echo "$(date): $1" >> $LOG_FILE
}

check_failed_logins() {
    echo "=== Checking Failed Login Attempts ==="
    
    # Check for failed login attempts
    failed_logins=$(docker-compose logs app | grep -i "failed login" | wc -l)
    
    if [ $failed_logins -gt 10 ]; then
        echo -e "${RED}⚠ High number of failed login attempts: $failed_logins${NC}"
        log_message "WARNING: High number of failed login attempts: $failed_logins"
    else
        echo -e "${GREEN}✓ Failed login attempts: $failed_logins${NC}"
    fi
}

check_suspicious_activity() {
    echo "=== Checking for Suspicious Activity ==="
    
    # Check for unusual RADIUS requests
    unusual_radius=$(docker-compose logs freeradius | grep -i "reject" | wc -l)
    
    if [ $unusual_radius -gt 5 ]; then
        echo -e "${RED}⚠ Unusual RADIUS activity detected${NC}"
        log_message "WARNING: Unusual RADIUS activity detected"
    else
        echo -e "${GREEN}✓ RADIUS activity normal${NC}"
    fi
}

check_disk_space() {
    echo "=== Checking Disk Space ==="
    
    disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ $disk_usage -gt 80 ]; then
        echo -e "${RED}⚠ Disk usage high: ${disk_usage}%${NC}"
        log_message "WARNING: Disk usage high: ${disk_usage}%"
    else
        echo -e "${GREEN}✓ Disk usage: ${disk_usage}%${NC}"
    fi
}

check_memory_usage() {
    echo "=== Checking Memory Usage ==="
    
    memory_usage=$(free | awk 'NR==2{printf "%.2f", $3*100/$2}')
    
    if (( $(echo "$memory_usage > 80" | bc -l) )); then
        echo -e "${RED}⚠ Memory usage high: ${memory_usage}%${NC}"
        log_message "WARNING: Memory usage high: ${memory_usage}%"
    else
        echo -e "${GREEN}✓ Memory usage: ${memory_usage}%${NC}"
    fi
}

# Main monitoring function
main() {
    echo "WiFi Billing System Security Monitor"
    echo "===================================="
    
    check_failed_logins
    check_suspicious_activity
    check_disk_space
    check_memory_usage
    
    echo "===================================="
    echo "Security check completed"
}

main "$@"
EOF
    
    chmod +x security_monitor.sh
    print_success "Security monitoring script created: security_monitor.sh"
}

# Create user management script
create_user_management() {
    print_status "Creating user management script..."
    
    cat > user_management.sh << 'EOF'
#!/bin/bash

# WiFi Billing System User Management

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Database connection
DB_HOST="mysql"
DB_USER="billing_user"
DB_PASS="${DB_PASSWORD}"
DB_NAME="billing"

# Function to add user
add_user() {
    local username=$1
    local password=$2
    local plan=$3
    
    echo -e "${BLUE}Adding user: $username${NC}"
    
    # Add user to PHPNuxBill database
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "
        INSERT INTO tbl_customers (username, password, plan_id, status) 
        VALUES ('$username', '$password', '$plan', 'active')
        ON DUPLICATE KEY UPDATE status='active';"
    
    echo -e "${GREEN}User $username added successfully${NC}"
}

# Function to suspend user
suspend_user() {
    local username=$1
    
    echo -e "${YELLOW}Suspending user: $username${NC}"
    
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "
        UPDATE tbl_customers SET status='suspended' WHERE username='$username';"
    
    echo -e "${GREEN}User $username suspended${NC}"
}

# Function to delete user
delete_user() {
    local username=$1
    
    echo -e "${RED}Deleting user: $username${NC}"
    
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "
        DELETE FROM tbl_customers WHERE username='$username';"
    
    echo -e "${GREEN}User $username deleted${NC}"
}

# Function to list users
list_users() {
    echo -e "${BLUE}Current Users:${NC}"
    
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "
        SELECT username, status, created_at FROM tbl_customers ORDER BY created_at DESC;"
}

# Function to show usage
show_usage() {
    local username=$1
    
    echo -e "${BLUE}Usage for user: $username${NC}"
    
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "
        SELECT username, data_usage, time_usage FROM tbl_usage WHERE username='$username';"
}

# Main menu
show_menu() {
    echo "WiFi Billing System User Management"
    echo "==================================="
    echo "1. Add user"
    echo "2. Suspend user"
    echo "3. Delete user"
    echo "4. List users"
    echo "5. Show user usage"
    echo "6. Exit"
    echo ""
    read -p "Select option: " choice
    
    case $choice in
        1)
            read -p "Username: " username
            read -s -p "Password: " password
            echo
            read -p "Plan ID: " plan
            add_user $username $password $plan
            ;;
        2)
            read -p "Username: " username
            suspend_user $username
            ;;
        3)
            read -p "Username: " username
            delete_user $username
            ;;
        4)
            list_users
            ;;
        5)
            read -p "Username: " username
            show_usage $username
            ;;
        6)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

# Check if running interactively
if [ "$1" = "add" ]; then
    add_user $2 $3 $4
elif [ "$1" = "suspend" ]; then
    suspend_user $2
elif [ "$1" = "delete" ]; then
    delete_user $2
elif [ "$1" = "list" ]; then
    list_users
elif [ "$1" = "usage" ]; then
    show_usage $2
else
    show_menu
fi
EOF
    
    chmod +x user_management.sh
    print_success "User management script created: user_management.sh"
}

# Create automated MikroTik configuration
create_mikrotik_auto_config() {
    print_status "Creating automated MikroTik configuration..."
    
    cat > mikrotik_auto_setup.sh << 'EOF'
#!/bin/bash

# Automated MikroTik Configuration Script
# This script configures MikroTik router for WiFi billing

MIKROTIK_IP="192.168.88.1"
MIKROTIK_USER="admin"
MIKROTIK_PASS=""
RADIUS_SERVER_IP=""
RADIUS_SECRET=""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to get user input
get_config() {
    echo "MikroTik Configuration Setup"
    echo "============================"
    
    read -p "MikroTik IP Address [$MIKROTIK_IP]: " input
    MIKROTIK_IP=${input:-$MIKROTIK_IP}
    
    read -p "MikroTik Username [$MIKROTIK_USER]: " input
    MIKROTIK_USER=${input:-$MIKROTIK_USER}
    
    read -s -p "MikroTik Password: " MIKROTIK_PASS
    echo
    
    read -p "RADIUS Server IP: " RADIUS_SERVER_IP
    read -s -p "RADIUS Secret: " RADIUS_SECRET
    echo
}

# Function to configure MikroTik
configure_mikrotik() {
    print_status "Configuring MikroTik router..."
    
    # Create configuration script
    cat > mikrotik_config.rsc << EOF
# MikroTik Hotspot Configuration
# Generated on $(date)

# Set system identity
/system identity set name="WiFi-Billing-Router"

# Configure RADIUS
/radius add service=hotspot address=$RADIUS_SERVER_IP secret=$RADIUS_SECRET auth-port=1812 acct-port=1813 timeout=3s retransmit=3

# Create hotspot profile
/ip hotspot profile add name="billing" hotspot-address=0.0.0.0/0 dns-name="" login-page="" login-page-timeout=5m idle-timeout=1h keepalive-timeout=2m login-timeout=1m mac-cookie-timeout=1h split-user-domain=no use-radius=yes radius-accounting=yes radius-interim-update=5m nas-port-type=wireless-802.11

# Configure hotspot on wireless interface
/ip hotspot add interface=wlan1 profile=billing

# Configure DNS
/ip dns set servers=8.8.8.8,8.8.4.4

# Configure NAT
/ip firewall nat add chain=srcnat out-interface=ether1 action=masquerade

# Configure firewall rules
/ip firewall filter add chain=input protocol=tcp dst-port=80 action=accept comment="Allow HTTP"
/ip firewall filter add chain=input protocol=tcp dst-port=443 action=accept comment="Allow HTTPS"
/ip firewall filter add chain=input protocol=udp dst-port=1812 action=accept comment="Allow RADIUS Auth"
/ip firewall filter add chain=input protocol=udp dst-port=1813 action=accept comment="Allow RADIUS Acct"

print "MikroTik configuration completed successfully"
EOF
    
    print_success "MikroTik configuration script created: mikrotik_config.rsc"
    print_status "Please import this script into your MikroTik router"
}

# Function to test connection
test_connection() {
    print_status "Testing connection to MikroTik..."
    
    if ping -c 1 $MIKROTIK_IP > /dev/null 2>&1; then
        print_success "MikroTik is reachable"
        return 0
    else
        print_error "Cannot reach MikroTik at $MIKROTIK_IP"
        return 1
    fi
}

# Main function
main() {
    echo "Automated MikroTik Configuration"
    echo "================================"
    
    get_config
    
    if test_connection; then
        configure_mikrotik
        print_success "Configuration completed!"
        echo ""
        echo "Next steps:"
        echo "1. Import mikrotik_config.rsc into your MikroTik router"
        echo "2. Test the hotspot connection"
        echo "3. Verify RADIUS authentication"
    else
        print_error "Cannot proceed without connection to MikroTik"
        exit 1
    fi
}

main "$@"
EOF
    
    chmod +x mikrotik_auto_setup.sh
    print_success "Automated MikroTik configuration script created: mikrotik_auto_setup.sh"
}

# Main security configuration function
main() {
    echo "WiFi Billing System Security Configuration"
    echo "========================================="
    
    generate_ssl_certs
    configure_firewall
    create_security_monitor
    create_user_management
    create_mikrotik_auto_config
    
    echo "========================================="
    echo "Security configuration completed!"
    echo ""
    echo "Generated files:"
    echo "- ssl/ (SSL certificates)"
    echo "- firewall.rules (firewall configuration)"
    echo "- security_monitor.sh (security monitoring)"
    echo "- user_management.sh (user management)"
    echo "- mikrotik_auto_setup.sh (automated MikroTik config)"
    echo ""
    echo "Security recommendations:"
    echo "1. Change default passwords"
    echo "2. Enable SSL/TLS encryption"
    echo "3. Configure firewall rules"
    echo "4. Set up regular backups"
    echo "5. Monitor system logs"
    echo "6. Keep software updated"
}

main "$@" 