# Directory Sharing App

**Directory Sharing App** is a simple utility for sharing directory contents via a web interface. It allows you to easily share files from a specified folder by running a local server with support for file uploads and downloads. Ideal for quick data sharing in a local network or personal use.

---

## Features
- View a list of files in the specified directory.
- Download files through the web interface.
- Upload new files to the directory.
- Customizable port and directory path via command-line arguments.

---

## Requirements
The following tools are required to run the application:
- **Java**: Version 17 or higher (OpenJDK or Oracle JDK recommended).
- **Maven**: For building the project from source.
- Ensure Java and Maven are installed and added to your PATH:
  - Check Java:
    ```bash
    java -version
  - Check Java:
    ```bash
    mvn -version
    
---

## Installation for Linux
- git clone https://github.com/solomyuri/directory-sharing-app
- cd directory-sharing-app  
- Run the linux_install.sh script to build and install:
    - chmod +x linux_install.sh
    - sudo ./linux_install.sh
    
## Installation for Windows
- git clone https://github.com/solomyuri/directory-sharing-app
- cd directory-sharing-app  
- Run the windows_install.bat script with administrator privileges

### Run application
- dir-share -p <port> -d </path/to/share>
    - -p default value: 8080
    - -d default value: current directory

---