import QtQuick 2.15
import QtQuick.Effects
import SddmComponents 2.0

Item {
    id: dataSlate
    width: 420
    height: 680
    
    property alias username: usernameInput.text
    property alias password: passwordInput.text
    property bool authenticationFailed: false
    property bool hardwareKeyDetected: false
    property string systemStatus: "SECURE"
    
    signal loginRequested(string username, string password)
    signal powerOffRequested()
    signal rebootRequested()
    
    // Main HUD Container
    Rectangle {
        id: hudBackground
        anchors.fill: parent
        radius: 12
        color: "#1a2040"
        border.width: 2
        border.color: "#4a9eff"
        opacity: 0.9
        
        // Frosted glass effect background
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#3a4a7a40" }
                GradientStop { position: 0.5; color: "#2a3a6a60" }
                GradientStop { position: 1.0; color: "#1a2a5a80" }
            }
        }
        
        // Animated border glow
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 1
            border.color: glowAnimation.active ? "#6ab7ff" : "#4a9eff"
            
            SequentialAnimation {
                id: glowAnimation
                running: true
                loops: Animation.Infinite
                property bool active: false
                
                PauseAnimation { duration: 2000 }
                ScriptAction { script: glowAnimation.active = true }
                PauseAnimation { duration: 200 }
                ScriptAction { script: glowAnimation.active = false }
                PauseAnimation { duration: 200 }
                ScriptAction { script: glowAnimation.active = true }
                PauseAnimation { duration: 200 }
                ScriptAction { script: glowAnimation.active = false }
            }
        }
    }
    
    // Content Container
    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 25
        
        // Header Section
        Item {
            width: parent.width
            height: 80
            
            // LANCER Protocol Header
            Text {
                id: headerText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                text: "◢ LANCER PROTOCOL ◣"
                font.family: "monospace"
                font.pointSize: 16
                font.bold: true
                color: "#4af2ff"
                
                // Subtle text glow
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width + 4
                    height: parent.height + 4
                    color: "transparent"
                    z: -1
                    opacity: 0.3
                    
                    Text {
                        anchors.centerIn: parent
                        text: headerText.text
                        font: headerText.font
                        color: "#4af2ff"
                    }
                }
            }
            
            // System Status Indicator
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                spacing: 8
                
                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: systemStatus === "SECURE" ? "#00ff41" : 
                           systemStatus === "ALERT" ? "#ff4500" : "#ffff00"
                    
                    SequentialAnimation on opacity {
                        running: systemStatus !== "SECURE"
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.3; duration: 500 }
                        NumberAnimation { to: 1.0; duration: 500 }
                    }
                }
                
                Text {
                    text: "SYS STATUS: " + systemStatus
                    font.family: "monospace"
                    font.pointSize: 10
                    color: "#8aa8d4"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        
        // Authentication Section
        Rectangle {
            width: parent.width
            height: 200
            radius: 8
            color: "#0f1a35"
            border.width: 1
            border.color: "#2a4a8a"
            
            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15
                
                Text {
                    text: "▸ AUTHENTICATION REQUIRED"
                    font.family: "monospace"
                    font.pointSize: 12
                    color: "#4af2ff"
                    font.bold: true
                }
                
                // Username Field
                Column {
                    width: parent.width
                    spacing: 5
                    
                    Text {
                        text: "PILOT_ID:"
                        font.family: "monospace"
                        font.pointSize: 9
                        color: "#8aa8d4"
                    }
                    
                    Rectangle {
                        width: parent.width
                        height: 35
                        radius: 4
                        color: "#1a2550"
                        border.width: usernameInput.activeFocus ? 2 : 1
                        border.color: usernameInput.activeFocus ? "#4af2ff" : "#3a5a9a"
                        
                        TextInput {
                            id: usernameInput
                            anchors.fill: parent
                            anchors.margins: 8
                            font.family: "monospace"
                            font.pointSize: 11
                            color: "#ffffff"
                            verticalAlignment: TextInput.AlignVCenter
                            selectByMouse: true
                            
                            KeyNavigation.tab: passwordInput
                        }
                        
                        // Cursor blink simulation for terminal feel
                        Rectangle {
                            width: 2
                            height: 16
                            color: "#4af2ff"
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            anchors.verticalCenter: parent.verticalCenter
                            visible: usernameInput.activeFocus
                            
                            SequentialAnimation on opacity {
                                running: usernameInput.activeFocus
                                loops: Animation.Infinite
                                NumberAnimation { to: 0; duration: 500 }
                                NumberAnimation { to: 1; duration: 500 }
                            }
                        }
                    }
                }
                
                // Password Field
                Column {
                    width: parent.width
                    spacing: 5
                    
                    Text {
                        text: "AUTH_CODE:"
                        font.family: "monospace"
                        font.pointSize: 9
                        color: "#8aa8d4"
                    }
                    
                    Rectangle {
                        width: parent.width
                        height: 35
                        radius: 4
                        color: "#1a2550"
                        border.width: passwordInput.activeFocus ? 2 : 1
                        border.color: authenticationFailed ? "#ff4444" : 
                                     passwordInput.activeFocus ? "#4af2ff" : "#3a5a9a"
                        
                        TextInput {
                            id: passwordInput
                            anchors.fill: parent
                            anchors.margins: 8
                            font.family: "monospace"
                            font.pointSize: 11
                            color: "#ffffff"
                            verticalAlignment: TextInput.AlignVCenter
                            echoMode: TextInput.Password
                            passwordCharacter: "●"
                            selectByMouse: true
                            
                            KeyNavigation.backtab: usernameInput
                            
                            Keys.onPressed: {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    dataSlate.loginRequested(usernameInput.text, passwordInput.text)
                                    event.accepted = true
                                }
                            }
                        }
                        
                        // Authentication failed indicator
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: "transparent"
                            border.width: 2
                            border.color: "#ff4444"
                            visible: authenticationFailed
                            
                            SequentialAnimation on opacity {
                                running: authenticationFailed
                                NumberAnimation { to: 0.5; duration: 100 }
                                NumberAnimation { to: 1.0; duration: 100 }
                                NumberAnimation { to: 0.5; duration: 100 }
                                NumberAnimation { to: 1.0; duration: 100 }
                            }
                        }
                    }
                }
            }
        }
        
        // Hardware Key Status Section
        Rectangle {
            width: parent.width
            height: 120
            radius: 8
            color: "#0f1a35"
            border.width: 1
            border.color: "#2a4a8a"
            
            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10
                
                Text {
                    text: "▸ HARDWARE AUTHENTICATION"
                    font.family: "monospace"
                    font.pointSize: 12
                    color: "#4af2ff"
                    font.bold: true
                }
                
                Row {
                    width: parent.width
                    spacing: 15
                    
                    // Hardware Key Indicator
                    Rectangle {
                        width: 12
                        height: 12
                        radius: 6
                        color: hardwareKeyDetected ? "#00ff41" : "#444444"
                        
                        SequentialAnimation on scale {
                            running: hardwareKeyDetected
                            loops: Animation.Infinite
                            NumberAnimation { to: 1.2; duration: 800 }
                            NumberAnimation { to: 1.0; duration: 800 }
                        }
                    }
                    
                    Text {
                        text: hardwareKeyDetected ? "YUBIKEY DETECTED" : "NO HARDWARE KEY"
                        font.family: "monospace"
                        font.pointSize: 10
                        color: hardwareKeyDetected ? "#00ff41" : "#8aa8d4"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                Row {
                    width: parent.width
                    spacing: 15
                    
                    Rectangle {
                        width: 12
                        height: 12
                        radius: 6
                        color: "#ffaa00"
                        
                        SequentialAnimation on opacity {
                            running: true
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.3; duration: 1200 }
                            NumberAnimation { to: 1.0; duration: 1200 }
                        }
                    }
                    
                    Text {
                        text: "BIOMETRIC SCANNER READY"
                        font.family: "monospace"
                        font.pointSize: 10
                        color: "#ffaa00"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
        
        // System Time & Info
        Rectangle {
            width: parent.width
            height: 80
            radius: 8
            color: "#0f1a35"
            border.width: 1
            border.color: "#2a4a8a"
            
            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 8
                
                Text {
                    text: "▸ SYSTEM CHRONOMETER"
                    font.family: "monospace"
                    font.pointSize: 12
                    color: "#4af2ff"
                    font.bold: true
                }
                
                Text {
                    id: timeDisplay
                    text: Qt.formatDateTime(new Date(), "yyyy.MM.dd // hh:mm:ss")
                    font.family: "monospace"
                    font.pointSize: 14
                    color: "#ffffff"
                    
                    Timer {
                        running: true
                        repeat: true
                        interval: 1000
                        onTriggered: {
                            timeDisplay.text = Qt.formatDateTime(new Date(), "yyyy.MM.dd // hh:mm:ss")
                        }
                    }
                }
            }
        }
        
        // Action Buttons
        Row {
            width: parent.width
            spacing: 15
            
            Rectangle {
                width: (parent.width - 30) / 3
                height: 45
                radius: 6
                color: "#2a4a8a"
                border.width: 1
                border.color: "#4a9eff"
                
                Text {
                    anchors.centerIn: parent
                    text: "AUTHENTICATE"
                    font.family: "monospace"
                    font.pointSize: 9
                    font.bold: true
                    color: "#ffffff"
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: dataSlate.loginRequested(usernameInput.text, passwordInput.text)
                    
                    onPressed: parent.color = "#1a3a7a"
                    onReleased: parent.color = "#2a4a8a"
                }
            }
            
            Rectangle {
                width: (parent.width - 30) / 3
                height: 45
                radius: 6
                color: "#8a4a2a"
                border.width: 1
                border.color: "#ff9e4a"
                
                Text {
                    anchors.centerIn: parent
                    text: "REBOOT"
                    font.family: "monospace"
                    font.pointSize: 9
                    font.bold: true
                    color: "#ffffff"
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: dataSlate.rebootRequested()
                    
                    onPressed: parent.color = "#7a3a1a"
                    onReleased: parent.color = "#8a4a2a"
                }
            }
            
            Rectangle {
                width: (parent.width - 30) / 3
                height: 45
                radius: 6
                color: "#8a2a2a"
                border.width: 1
                border.color: "#ff4a4a"
                
                Text {
                    anchors.centerIn: parent
                    text: "SHUTDOWN"
                    font.family: "monospace"
                    font.pointSize: 9
                    font.bold: true
                    color: "#ffffff"
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: dataSlate.powerOffRequested()
                    
                    onPressed: parent.color = "#7a1a1a"
                    onReleased: parent.color = "#8a2a2a"
                }
            }
        }
    }
}
