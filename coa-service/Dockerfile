FROM debian:bullseye-slim

# Install PHP and FreeRADIUS client
RUN apt-get update && apt-get install -y \
    php-cli \
    php-json \
    freeradius-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create directory for the script
WORKDIR /app

# Copy our CoA handler
COPY coa_handler.php /app/

# Run a simple PHP server to handle requests
EXPOSE 8080
CMD ["php", "-S", "0.0.0.0:8080", "/app/coa_handler.php"] 