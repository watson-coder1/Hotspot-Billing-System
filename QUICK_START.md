# WiFi Billing System - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites
- Docker Desktop installed
- Git installed
- A modern web browser

### Step 1: Clone the Repository
```bash
git clone --recursive https://github.com/reduzersolutions/radius-billing-system.git
cd radius-billing-system
```

### Step 2: Create Environment File
Copy the example environment file:
```bash
# On Linux/Mac:
cp env.example .env

# On Windows:
copy env.example .env
```

### Step 3: Configure Environment
Edit the `.env` file with your settings:
```env
# Database Configuration
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=billing
DB_USERNAME=billing_user
DB_PASSWORD=your_secure_password_here
RADIUS_DATABASE=radius

# M-pesa Configuration (Optional for testing)
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

### Step 4: Start the System
```bash
docker-compose up -d
```

### Step 5: Access the System
1. Open your browser and go to `http://localhost`
2. Follow the PHPNuxBill installation wizard
3. Login with default credentials: `admin@yourdomain.com` / `admin123`

## 🔧 Configuration

### PHPNuxBill Setup
1. Complete the installation wizard
2. Go to Settings → General Settings → FreeRADIUS
3. Enable RADIUS integration
4. Save changes

### MikroTik Configuration
1. Use the generated `mikrotik_setup.rsc` file
2. Import it into your MikroTik router
3. Configure your wireless interface
4. Test the hotspot connection

### M-pesa Integration (Optional)
1. Get API credentials from Safaricom Developer Portal
2. Update `.env` file with your credentials
3. Configure PHPNuxBill payment gateway
4. Test with sandbox environment

## 📊 Monitoring

### Check System Status
```bash
# View running containers
docker-compose ps

# Check logs
docker-compose logs app
docker-compose logs freeradius
docker-compose logs mysql

# Monitor system
docker stats
```

### Common Commands
```bash
# Start system
docker-compose up -d

# Stop system
docker-compose down

# Restart system
docker-compose restart

# Update system
git pull
docker-compose down
docker-compose up -d

# View logs
docker-compose logs -f
```

## 🛠️ Troubleshooting

### Containers Not Starting
```bash
# Check Docker status
docker ps -a

# View detailed logs
docker-compose logs

# Restart containers
docker-compose down && docker-compose up -d
```

### Database Issues
```bash
# Check MySQL status
docker-compose exec mysql mysqladmin ping

# Reset database
docker-compose down -v
docker-compose up -d
```

### RADIUS Issues
```bash
# Test RADIUS connection
docker-compose exec freeradius radtest testing password localhost 0 testing123

# Check RADIUS logs
docker-compose logs freeradius
```

## 📱 M-pesa Testing

### Local Testing with Ngrok
1. Install ngrok: https://ngrok.com/download
2. Start ngrok: `ngrok http 80`
3. Update callback URL in `.env` with ngrok URL
4. Test M-pesa integration

### Sandbox Testing
1. Use Safaricom sandbox environment
2. Test with sandbox phone numbers
3. Verify payment callbacks
4. Check PHPNuxBill logs

## 🔒 Security

### Basic Security Setup
1. Change default passwords
2. Enable SSL/TLS in production
3. Configure firewall rules
4. Set up regular backups
5. Monitor system logs

### Production Deployment
For production deployment, use the deployment script:
```bash
# Linux only
sudo ./deploy.sh
```

## 📚 Next Steps

1. **Complete PHPNuxBill Setup**
   - Configure user plans
   - Set up payment methods
   - Create user accounts

2. **Configure MikroTik Router**
   - Import configuration script
   - Test hotspot functionality
   - Verify RADIUS authentication

3. **Set Up M-pesa Integration**
   - Get production API credentials
   - Configure payment gateway
   - Test payment flow

4. **Security Hardening**
   - Change all default passwords
   - Enable SSL/TLS
   - Configure firewall
   - Set up monitoring

5. **Production Deployment**
   - Use proper domain name
   - Set up SSL certificates
   - Configure backups
   - Monitor system health

## 🆘 Support

### Getting Help
- Check the troubleshooting section
- Review system logs
- Create GitHub issue
- Contact support team

### Useful Links
- [PHPNuxBill Documentation](https://github.com/hotspotbilling/phpnuxbill/wiki)
- [FreeRADIUS Documentation](https://wiki.freeradius.org/)
- [MikroTik Documentation](https://help.mikrotik.com/)
- [M-pesa API Documentation](https://developer.safaricom.co.ke/)

### System Information
- **Web Interface**: http://localhost
- **Admin Panel**: http://localhost/admin
- **RADIUS Server**: localhost:1812
- **Database**: localhost:33060

---

## 🌟 Mission

This system aims to make internet access affordable and accessible to everyone. Even 1Mbps can change lives!

**Happy Billing! 🌐💰** 