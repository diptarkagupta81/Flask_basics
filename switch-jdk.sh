#!/bin/bash

# JDK Version Switcher Script
# Usage: ./switch-jdk.sh [version]
# Available versions: 11, 17, 21

show_usage() {
    echo "JDK Version Switcher"
    echo "Usage: $0 [version]"
    echo ""
    echo "Available versions:"
    echo "  11  - OpenJDK 11"
    echo "  17  - OpenJDK 17" 
    echo "  21  - OpenJDK 21 (default)"
    echo ""
    echo "Examples:"
    echo "  $0 17        # Switch to OpenJDK 17"
    echo "  $0           # Show current version and available options"
}

show_current() {
    echo "Current Java version:"
    java -version
    echo ""
    echo "Current JAVA_HOME: $JAVA_HOME"
    echo ""
    echo "Available alternatives:"
    update-alternatives --list java
}

switch_jdk() {
    local version=$1
    local java_path=""
    
    case $version in
        11)
            java_path="/usr/lib/jvm/java-11-openjdk-amd64"
            ;;
        17)
            java_path="/usr/lib/jvm/java-17-openjdk-amd64"
            ;;
        21)
            java_path="/usr/lib/jvm/java-21-openjdk-amd64"
            ;;
        *)
            echo "Error: Unsupported version '$version'"
            show_usage
            return 1
            ;;
    esac
    
    if [ ! -d "$java_path" ]; then
        echo "Error: JDK $version is not installed at $java_path"
        echo "Install it with: sudo apt install openjdk-$version-jdk"
        return 1
    fi
    
    echo "Switching to OpenJDK $version..."
    
    # Update alternatives
    sudo update-alternatives --set java "$java_path/bin/java"
    sudo update-alternatives --set javac "$java_path/bin/javac"
    
    # Update JAVA_HOME in current session
    export JAVA_HOME="$java_path"
    
    # Update JAVA_HOME in bashrc for future sessions
    sed -i '/export JAVA_HOME=/d' ~/.bashrc
    echo "export JAVA_HOME=$java_path" >> ~/.bashrc
    
    echo "Successfully switched to OpenJDK $version"
    echo "New JAVA_HOME: $JAVA_HOME"
    echo ""
    echo "Verifying installation:"
    java -version
}

# Main script logic
if [ $# -eq 0 ]; then
    show_current
    echo ""
    show_usage
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
else
    switch_jdk "$1"
fi