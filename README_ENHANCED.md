# WiFi Billing System with M-pesa Integration

A comprehensive WiFi billing solution using PHPNuxBill and FreeRADIUS with automated setup scripts and enhanced security features.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Linux/Unix system (Ubuntu 20.04+ recommended)
- MikroTik router with hotspot capability
- M-pesa API credentials (for payment integration)

### 1. Clone and Setup
```bash
# Clone the repository
git clone --recursive https://github.com/reduzersolutions/radius-billing-system.git
cd radius-billing-system

# Make setup script executable
chmod +x setup.sh

# Run automated setup
./setup.sh
```

### 2. Configure Environment
The setup script will create a `.env` file. Edit it with your specific values:

```env
# Database Configuration
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=billing
DB_USERNAME=billing_user
DB_PASSWORD=your_secure_password_here
RADIUS_DATABASE=radius

# M-pesa Configuration
MPESA_CONSUMER_KEY=your_mpesa_consumer_key
MPESA_CONSUMER_SECRET=your_mpesa_consumer_secret
MPESA_PASSKEY=your_mpesa_passkey
MPESA_SHORTCODE=your_mpesa_shortcode
MPESA_ENVIRONMENT=sandbox
MPESA_CALLBACK_URL=https://your-domain.com/mpesa/callback

# FreeRADIUS Configuration
RADIUS_SECRET=your_radius_secret_key
RADIUS_DEBUG=yes

# Network Configuration
ROUTER_IP=192.168.1.1
ROUTER_SECRET=your_router_secret
```

### 3. Start the System
```bash
# Start all services
docker-compose up -d

# Check status
./monitor.sh
```

## 📋 System Components

### Core Services
- **PHPNuxBill**: Web-based billing and user management
- **FreeRADIUS**: Authentication and accounting server
- **MySQL**: Database backend
- **Nginx**: Web server with SSL support
- **COA Service**: Change of Authorization service

### Additional Services
- **Omada Controller**: TP-Link Omada management
- **UniFi Controller**: Ubiquiti UniFi management
- **MongoDB**: Database for UniFi controller

## 🔧 Configuration

### 1. PHPNuxBill Setup
1. Open `http://localhost` in your browser
2. Follow the installation wizard
3. Login with default credentials: `admin@yourdomain.com` / `admin123`
4. Go to Settings → General Settings → FreeRADIUS
5. Enable RADIUS integration and save

### 2. MikroTik Configuration
Use the automated configuration script:
```bash
./mikrotik_auto_setup.sh
```

Or manually configure:
1. Import the generated `mikrotik_setup.rsc` file
2. Configure your wireless interface
3. Test the hotspot connection

### 3. M-pesa Integration
1. Get API credentials from Safaricom Developer Portal
2. Update `.env` file with your credentials
3. Configure PHPNuxBill payment gateway
4. Test with sandbox environment first

## 🛡️ Security Features

### Automated Security Setup
```bash
# Run security configuration
chmod +x security_config.sh
./security_config.sh
```

### Security Features
- **SSL/TLS Encryption**: Self-signed certificates for development
- **Firewall Rules**: Restrictive iptables configuration
- **Security Monitoring**: Automated threat detection
- **User Management**: Secure user administration
- **Backup System**: Automated database and config backups

### Security Best Practices
1. Change all default passwords
2. Use strong, unique passwords
3. Enable SSL/TLS in production
4. Regular security updates
5. Monitor system logs
6. Implement rate limiting
7. Use VPN for remote access

## 📊 Monitoring and Management

### System Monitoring
```bash
# Check system status
./monitor.sh

# Security monitoring
./security_monitor.sh

# View logs
docker-compose logs app
docker-compose logs freeradius
docker-compose logs mysql
```

### User Management
```bash
# Interactive user management
./user_management.sh

# Command line operations
./user_management.sh add username password plan_id
./user_management.sh suspend username
./user_management.sh list
```

### Backup and Recovery
```bash
# Create backup
./backup.sh

# Restore from backup
docker-compose exec mysql mysql -u root -p < backup_file.sql
```

## 🔄 M-pesa Integration

### Setup Process
1. **Register for Safaricom Developer Account**
   - Visit https://developer.safaricom.co.ke/
   - Create a new app
   - Get your API credentials

2. **Configure PHPNuxBill**
   - Login to admin panel
   - Go to Settings → Payment Gateway
   - Enable M-pesa gateway
   - Enter your credentials

3. **Test Integration**
   - Create test user
   - Try payment process
   - Check logs for errors

### Production Setup
1. Change `MPESA_ENVIRONMENT` to "live"
2. Update callback URL to production domain
3. Ensure SSL is properly configured
4. Test thoroughly before going live

## 🚨 Troubleshooting

### Common Issues

#### 1. Containers Not Starting
```bash
# Check Docker status
docker ps -a

# View container logs
docker-compose logs

# Restart containers
docker-compose down && docker-compose up -d
```

#### 2. Database Connection Issues
```bash
# Check MySQL status
docker-compose exec mysql mysqladmin ping

# Reset database
docker-compose down -v
docker-compose up -d
```

#### 3. RADIUS Authentication Failing
```bash
# Test RADIUS connection
docker-compose exec freeradius radtest testing password localhost 0 testing123

# Check RADIUS logs
docker-compose logs freeradius
```

#### 4. M-pesa Integration Issues
- Verify API credentials
- Check callback URL accessibility
- Use ngrok for local testing
- Review PHPNuxBill logs

### Log Locations
- **Application**: `docker-compose logs app`
- **RADIUS**: `docker-compose logs freeradius`
- **Database**: `docker-compose logs mysql`
- **Security**: `/var/log/security_monitor.log`

## 📈 Performance Optimization

### System Requirements
- **Minimum**: 2GB RAM, 20GB storage
- **Recommended**: 4GB RAM, 50GB storage
- **Production**: 8GB RAM, 100GB+ storage

### Optimization Tips
1. **Database Optimization**
   - Regular database maintenance
   - Optimize MySQL configuration
   - Monitor query performance

2. **Network Optimization**
   - Use SSD storage
   - Optimize network settings
   - Implement caching

3. **Security Optimization**
   - Regular security updates
   - Monitor system resources
   - Implement rate limiting

## 🔧 Advanced Configuration

### Custom RADIUS Configuration
Edit `raddb/config_data/radiusd.conf` for advanced RADIUS settings.

### Custom PHPNuxBill Configuration
Modify `conf/php.ini` for PHP optimization.

### SSL Certificate Management
For production, replace self-signed certificates with proper SSL certificates.

## 📚 Additional Resources

### Documentation
- [PHPNuxBill Wiki](https://github.com/hotspotbilling/phpnuxbill/wiki)
- [FreeRADIUS Documentation](https://wiki.freeradius.org/)
- [MikroTik Documentation](https://help.mikrotik.com/)

### Community Support
- GitHub Issues
- Stack Overflow
- MikroTik Forum

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

### Development Setup
```bash
# Clone for development
git clone --recursive https://github.com/reduzersolutions/radius-billing-system.git
cd radius-billing-system

# Install development dependencies
# (Add development tools as needed)

# Run tests
# (Add test suite as needed)
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- PHPNuxBill team for the billing system
- FreeRADIUS community for the authentication server
- MikroTik for router capabilities
- Safaricom for M-pesa API

## 🌟 Mission Statement

This project aims to make internet access affordable and accessible to everyone. By providing a simple, secure, and scalable WiFi billing solution, we hope to help communities connect to the digital world.

**Remember**: Even 1Mbps can change lives. Make internet accessible to your community!

---

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Check the troubleshooting section
- Review the logs for error messages
- Contact the development team

**Happy Billing! 🌐💰** 