#!/bin/bash

# Bunker Doors Animation Launcher
# This script launches the standalone animation as a detached process

# Set up environment
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

# Path to the QML animation file
QML_FILE="/usr/share/sddm/themes/lancer/bunker-doors-standalone.qml"

# Log for debugging
echo "$(date): Starting bunker doors animation" >> /tmp/bunker-doors.log

# Launch QML application detached from parent process
# This ensures it survives SDDM termination
nohup qml "$QML_FILE" > /tmp/bunker-doors.log 2>&1 &

# Alternative using qt6-declarative tools if available:
# nohup qml6 "$QML_FILE" > /tmp/bunker-doors.log 2>&1 &

# Get the PID for logging
PID=$!
echo "$(date): Bunker doors animation started with PID $PID" >> /tmp/bunker-doors.log

# Optional: Write PID file for cleanup if needed
echo $PID > /tmp/bunker-doors.pid

# Exit immediately, leaving animation running independently
exit 0
