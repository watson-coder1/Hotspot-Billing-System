# WiFi Billing System with M-pesa Integration

An MVP setup for Hotspot Billing using PHPNuxBill and FreeRADIUS

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

# Make setup script executable (Linux/Mac only)
chmod +x setup.sh

# Run automated setup (Linux/Mac only)
./setup.sh
```

**For Windows users, see [QUICK_START.md](QUICK_START.md) for Windows-specific instructions.**

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

# PHPNuxBill Configuration
PHPNUXBILL_ADMIN_EMAIL=admin@yourdomain.com
PHPNUXBILL_ADMIN_PASSWORD=admin123

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

### 1. PHPNuxBill Installation
1. Open your browser and navigate to `http://localhost`
2. Follow the PHPNuxBill installation wizard
3. Once logged in, go to:
    - Settings → General Settings → FreeRADIUS
    - Enable RADIUS integration
    - Save changes

### 2. NAS Configuration
1. Navigate to Settings → General Settings → FreeRADIUS
2. Turn on Radius
3. Go to RADIUS → RADIUS NAS
4. Add your router details:
    - Name: [Your Router Name]
    - IP Address: [Router IP]
    - Secret Key: [Your Secret] // We will use this when setting up radius on Mikrotik

### 3. MikroTik Hotspot Setup
For detailed MikroTik configuration, watch this tutorial: [How to create a Hotspot with Radius Server Authentication](https://www.youtube.com/watch?v=bH_6MS9T_n4)

**Important**: Do not use MikroTik's UserManager as PHPNuxBill will handle user management.

## M-pesa Integration

The system includes M-pesa integration for automated payments. Configure your M-pesa credentials in PHPNuxBill's payment settings.

**NB**: You can use Ngrok for testing M-pesa integration on your local machine.

## 🛡️ Enhanced Features

### Automated Setup Scripts
- **setup.sh**: Complete automated setup (Linux/Mac)
- **security_config.sh**: Security hardening and monitoring
- **deploy.sh**: Production deployment script
- **monitor.sh**: System monitoring and health checks

### Security Features
- SSL/TLS encryption
- Firewall configuration
- Security monitoring
- Automated backups
- User management tools

### Management Tools
- **user_management.sh**: User administration
- **backup.sh**: Automated backups
- **security_monitor.sh**: Security monitoring

## 📚 Documentation

### Quick Start Guides
- **[QUICK_START.md](QUICK_START.md)**: 5-minute setup guide
- **[README_ENHANCED.md](README_ENHANCED.md)**: Comprehensive documentation

### Configuration Guides
- **[MPESA_SETUP.md](MPESA_SETUP.md)**: M-pesa integration guide
- **[PRODUCTION_GUIDE.md](PRODUCTION_GUIDE.md)**: Production deployment guide

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

