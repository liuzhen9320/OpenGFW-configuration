# 🔥 OpenGFW Configuration

## ✨ Overview

We provide a complete, unattended installation of OpenGFW v0.4.1 with the following features:

- 🤖 **Unattended Installation**: Fully automated with comprehensive error handling
- 🛠️ **Robust Error Handling**: Includes retry mechanisms and cleanup procedures
- 📊 **Logging**: Colored output with timestamps for better visibility
- ✅ **System Validation**: Checks system requirements before installation
- ⚙️ **Service Management**: Automatically configures and starts systemd service

## 📋 Prerequisites

- 🐧 **Operating System**: Linux with systemd support (Ubuntu, Debian, CentOS, etc.)
- 🔧 **Architecture**: `x86_64` (amd64)
- 👑 **Privileges**: Root or sudo access
- 🌐 **Network**: Internet connection to download components from GitHub

## 🚀 Quick Start

1. **📥 Download the installation script**:
   ```bash
   wget https://raw.githubusercontent.com/liuzhen9320/OpenGFW-configuration/main/scripts/install.sh
   chmod +x install.sh
   ```

2. **🎯 Run the installation**:
   ```bash
   sudo ./install.sh
   ```

3. **🔍 Verify installation**:
   ```bash
   systemctl status opengfw.service
   ```

## 📦 What Gets Installed

The script performs the following actions:

1. 🔄 **System Updates**: Updates package lists and installs required dependencies
2. 📂 **Directory Creation**: Creates `/opt/opengfw` for installation files
3. ⬇️ **Binary Download**: Downloads OpenGFW v0.4.0 binary for Linux AMD64
4. 📝 **Configuration Files**: Downloads default configuration and rules files
5. 🔧 **Service Setup**: Installs and configures systemd service
6. ▶️ **Service Start**: Enables and starts the OpenGFW service

## 📁 File Locations

After installation, you'll find the following files:

```
/opt/opengfw/
├── OpenGFW          # 🚀 Main executable binary
├── config.yml       # ⚙️ Main configuration file
└── rules.yml        # 🔍 Filtering rules configuration

/usr/lib/systemd/system/
└── opengfw.service  # 🔧 Systemd service file
```

## 🔧 Configuration

### 🎨 Customizing Configuration

After installation, you can modify the configuration files:

1. **⚙️ Main configuration**: Edit `/opt/opengfw/config.yml`
2. **🔍 Filter rules**: Edit `/opt/opengfw/rules.yml`
3. **🔄 Restart service**: `sudo systemctl restart opengfw.service`

## 🎛️ Service Management

### 🔧 Common Commands

```bash
# 🔍 Check service status
systemctl status opengfw.service

# ▶️ Start the service
sudo systemctl start opengfw.service

# ⏹️ Stop the service
sudo systemctl stop opengfw.service

# 🔄 Restart the service
sudo systemctl restart opengfw.service

# 🚀 Enable auto-start on boot
sudo systemctl enable opengfw.service

# 🚫 Disable auto-start on boot
sudo systemctl disable opengfw.service

# 📜 View service logs
journalctl -u opengfw.service -f
```

### 📊 Service Logs

Monitor OpenGFW logs in real-time:
```bash
journalctl -u opengfw.service -f
```

View recent logs:
```bash
journalctl -u opengfw.service --since "1 hour ago"
```

## 🔧 Troubleshooting

### 🚨 Installation Issues

1. **🚫 Permission Denied**:
   - Ensure you're running the script with sudo or as root
   - Check file permissions: `chmod +x install.sh`

2. **💔 Download Failures**:
   - Verify internet connectivity
   - Check if GitHub is accessible from your server
   - Retry the installation (script has built-in retry mechanisms)

3. **⚠️ Service Start Issues**:
   - Check service status: `systemctl status opengfw.service`
   - Review logs: `journalctl -u opengfw.service`
   - Verify configuration files are valid

### 💡 Common Solutions

1. **🔍 Check System Requirements**:
   ```bash
   # Verify architecture
   uname -m
   
   # Check systemd
   systemctl --version
   ```

2. **🔄 Manual Service Restart**:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl restart opengfw.service
   ```

## 🗑️ Uninstallation

To remove OpenGFW:

```bash
# ⏹️ Stop and disable service
sudo systemctl stop opengfw.service
sudo systemctl disable opengfw.service

# 🗑️ Remove service file
sudo rm /usr/lib/systemd/system/opengfw.service

# 📂 Remove installation directory
sudo rm -rf /opt/opengfw

# 🔄 Reload systemd
sudo systemctl daemon-reload
```

## 🔒 Security Considerations

- 🛡️ OpenGFW is a network analysis tool that can inspect and filter network traffic
- 🔥 Ensure proper firewall configuration and access controls
- 📋 Review and customize filtering rules according to your security requirements
- 👀 Monitor service logs for security events

## 🤝 Contributing

1. 🍴 Fork the repository
2. 🌿 Create a feature branch
3. ✨ Make your changes
4. 🧪 Test thoroughly
5. 📤 Submit a pull request

## 📄 License

This installation script is provided as-is. Please refer to the original OpenGFW project for licensing information.

## 💬 Support

For issues related to:
- 🛠️ **Installation Script**: Create an issue in this repository
- 🔧 **OpenGFW Core**: Visit [OpenGFW GitHub](https://github.com/apernet/OpenGFW)
- ⚙️ **Configuration**: Check [OpenGFW Configuration](https://github.com/liuzhen9320/OpenGFW-configuration)

---

**⚠️ Note**: This tool is for educational and legitimate network analysis purposes only. Please ensure compliance with local laws and regulations. 🏛️
