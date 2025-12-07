# Script to build the web server to configure Nginx when the instance startups. It is called by ec2_instances.tf via the user_data parameter 

set -e  # Exit on error

echo "Starting web server setup..."

# Update system packages
yum update -y

# Install Nginx web server
yum install -y nginx

# Start and enable Nginx service
systemctl start nginx
systemctl enable nginx

# Create a simple HTML page showing which server is serving the request
cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Web Server</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container {
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        h1 { color: #333; margin: 0; }
        p { color: #666; margin: 10px 0 0 0; }
        .highlight { color: #667eea; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Hello</h1>
        <p>This instance is running Nginx and is part of a load-balanced cluster.</p>
    </div>
</body>
</html>
EOF

echo "Web server setup complete!"