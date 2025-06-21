import QtQuick 2.0
import SddmComponents 2.0

Item {
    id: mechHUD
    width: 900
    height: 1000
    
    property alias username: usernameInput.text
    property alias password: passwordInput.text
    property bool authenticationFailed: false
    property bool bootComplete: false
    property int bootStep: 0
    
    signal loginRequested(string username, string password)
    signal powerOffRequested()
    signal rebootRequested()
    
    // Single unified HUD unit with enhanced steel frame
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        
        // Main steel frame border - thicker on right side
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 4
            border.color: "#3a3f45"
            radius: 8
        }
        
        // Thicker right edge for mounting connection
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 12
            color: "#2a2e33"
            radius: 8
            
            // Right edge gradient for depth
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: parent.radius - 1
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#34383d" }
                    GradientStop { position: 0.5; color: "#2a2e33" }
                    GradientStop { position: 1.0; color: "#20242a" }
                }
            }
        }
        
        // Corner rivets around the entire border
        Repeater {
            model: 4
            Rectangle {
                width: 16
                height: 16
                color: "#2a2e33"
                border.width: 2
                border.color: "#1a1a1a"
                radius: 8
                x: (index % 2) * (parent.width - 16)
                y: Math.floor(index / 2) * (parent.height - 16)
                
                Rectangle {
                    anchors.centerIn: parent
                    width: 6
                    height: 6
                    color: "#4a4a4a"
                    radius: 3
                }
            }
        }
        
        // Additional rivets along the right edge
        Repeater {
            model: 6
            Rectangle {
                width: 12
                height: 12
                color: "#2a2e33"
                border.width: 1
                border.color: "#1a1a1a"
                radius: 6
                x: parent.width - 6
                y: 50 + index * 150
                
                Rectangle {
                    anchors.centerIn: parent
                    width: 4
                    height: 4
                    color: "#4a4a4a"
                    radius: 2
                }
            }
        }
        
        // Connection ports on right edge
        Rectangle {
            x: parent.width - 8
            y: parent.height * 0.3
            width: 16
            height: 8
            color: "#1a1a1a"
            radius: 4
            border.width: 1
            border.color: "#0a0a0a"
        }
        
        Rectangle {
            x: parent.width - 8
            y: parent.height * 0.7
            width: 16
            height: 8
            color: "#1a1a1a"
            radius: 4
            border.width: 1
            border.color: "#0a0a0a"
        }
        
        // Single unified frosted glass surface inside the steel frame
        Rectangle {
            anchors.fill: parent
            anchors.margins: 12  // More margin for thicker frame
            radius: 6
            
            // Steel blue frosted glass
            color: "#2a2e33"
            opacity: 0.4
            border.width: 1
            border.color: "#a0cfff"
        }
            
            // Content areas within the unified glass surface
            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                // Header Section
                Row {
                    width: parent.width
                    height: 70
                    spacing: 30
                    
                    Column {
                        width: parent.width * 0.65
                        spacing: 5
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            text: "COMP/CON AUTHENTICATION TERMINAL"
                            font.family: "Courier New, monospace"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#a0cfff"
                        }
                        
                        Text {
                            text: "GMS UNIT MK XI REV 11.4.1C // POLICY ZONE: 28::FALLEN VEIL"
                            font.family: "Courier New, monospace"
                            font.pixelSize: 11
                            color: "#6a8aa8"
                        }
                        
                        Text {
                            text: "STATUS: " + (bootComplete ? "READY" : "INITIALIZING...")
                            font.family: "Courier New, monospace"
                            font.pixelSize: 12
                            color: bootComplete ? "#a0cfff" : "#a0cfff"  // Keep blue, not yellow
                            font.bold: true
                        }
                    }
                    
                    Column {
                        width: parent.width * 0.3
                        spacing: 3
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            text: Qt.formatDateTime(new Date(), "yyyy.MM.dd")
                            font.family: "Courier New, monospace"
                            font.pixelSize: 11
                            color: "#6a8aa8"
                            horizontalAlignment: Text.AlignRight
                            width: parent.width
                        }
                        
                        Text {
                            id: timeDisplay
                            text: Qt.formatDateTime(new Date(), "hh:mm:ss")
                            font.family: "Courier New, monospace"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#a0cfff"
                            horizontalAlignment: Text.AlignRight
                            width: parent.width
                            
                            Timer {
                                running: true
                                repeat: true
                                interval: 1000
                                onTriggered: timeDisplay.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
                            }
                        }
                    }
                }
                
                // Divider line
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#a0cfff"
                    opacity: 0.3
                }
                
                // Main Terminal Display Area
                Flickable {
                    id: terminalScroll
                    width: parent.width
                    height: 420
                    contentHeight: bootLog.height
                    clip: true
                    
                    Column {
                        id: bootLog
                        width: parent.width
                        spacing: 4
                        
                        Text {
                            width: parent.width
                            text: "Initializing semantic manifold . . . " + (bootStep >= 1 ? "done" : "")
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            color: "#a0cfff"  // Always blue
                            font.bold: bootStep < 1
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 2 ? "Initializing logic gradients . . . done" : 
                                  bootStep >= 1 ? "Initializing logic gradients . . ." : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            color: "#a0cfff"  // Always blue
                            font.bold: bootStep >= 1 && bootStep < 2
                            visible: bootStep >= 1
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 3 ? "1.0255EB FREE (3.6EB TOTAL)" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            color: "#a0cfff"
                            visible: bootStep >= 3
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 3 ? "KERNEL supported CPUs:" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            color: "#a0cfff"
                            visible: bootStep >= 3
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 3 ? "  GMS MISSISSIPPI Series (MkII+)" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 13
                            color: "#6a8aa8"
                            visible: bootStep >= 3
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 3 ? "  IPS-N Carronade v9.1+" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 13
                            color: "#6a8aa8"
                            visible: bootStep >= 3
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 3 ? "  SSC Premier IV-XIV" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 13
                            color: "#6a8aa8"
                            visible: bootStep >= 3
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 4 ? "Establishing encrypted link (24::BLUE CASCADE) . . . done" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            color: "#a0cfff"
                            visible: bootStep >= 4
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 5 ? "WARNING: FRAME NOT PRESENT OR INVALID" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            color: "#ffc266"  // Yellow for warnings only
                            font.bold: true
                            visible: bootStep >= 5
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 6 ? "No sensory bridge found // manual input mode enabled" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            color: "#ffc266"  // Yellow for warnings only
                            visible: bootStep >= 6
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 7 ? "" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            visible: bootStep >= 7
                        }
                        
                        Text {
                            width: parent.width
                            text: bootStep >= 7 ? ">//[COMP/CON: Authentication Required. Input Credentials.]" : ""
                            font.family: "Courier New, monospace"
                            font.pixelSize: 16
                            color: "#a0cfff"
                            font.bold: true
                            visible: bootStep >= 7
                        }
                    }
                }
                
                // Divider line
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#a0cfff"
                    opacity: 0.3
                    visible: bootStep >= 7
                }
                
                // Authentication Section
                Column {
                    width: parent.width
                    spacing: 15
                    visible: bootStep >= 7
                    
                    Text {
                        text: "PILOT AUTHENTICATION"
                        font.family: "Courier New, monospace"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#a0cfff"
                    }
                    
                    Row {
                        width: parent.width
                        spacing: 15
                        
                        Text {
                            text: "USER:"
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            color: "#6a8aa8"
                            width: 80
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Rectangle {
                            width: 300
                            height: 28
                            radius: 4
                            color: "#1a1e2180"
                            border.width: 1
                            border.color: usernameInput.activeFocus ? "#a0cfff" : "#4a4f55"
                            
                            TextInput {
                                id: usernameInput
                                anchors.fill: parent
                                anchors.margins: 6
                                font.family: "Courier New, monospace"
                                font.pixelSize: 14
                                color: "#a0cfff"
                                verticalAlignment: TextInput.AlignVCenter
                                selectByMouse: true
                                KeyNavigation.tab: passwordInput
                            }
                        }
                    }
                    
                    Row {
                        width: parent.width
                        spacing: 15
                        
                        Text {
                            text: "PASS:"
                            font.family: "Courier New, monospace"
                            font.pixelSize: 14
                            color: "#6a8aa8"
                            width: 80
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Rectangle {
                            width: 300
                            height: 28
                            radius: 4
                            color: "#1a1e2180"
                            border.width: 1
                            border.color: authenticationFailed ? "#ff5c5c" : 
                                         passwordInput.activeFocus ? "#a0cfff" : "#4a4f55"
                            
                            TextInput {
                                id: passwordInput
                                anchors.fill: parent
                                anchors.margins: 6
                                font.family: "Courier New, monospace"
                                font.pixelSize: 14
                                color: "#a0cfff"
                                verticalAlignment: TextInput.AlignVCenter
                                echoMode: TextInput.Password
                                passwordCharacter: "*"
                                selectByMouse: true
                                KeyNavigation.backtab: usernameInput
                                
                                Keys.onPressed: {
                                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                        mechHUD.loginRequested(usernameInput.text, passwordInput.text)
                                        event.accepted = true
                                    }
                                }
                            }
                        }
                    }
                    
                    Text {
                        text: authenticationFailed ? "AUTH FAILED: INVALID CREDENTIALS" : ""
                        font.family: "Courier New, monospace"
                        font.pixelSize: 12
                        color: "#ff5c5c"
                        font.bold: true
                        visible: authenticationFailed
                    }
                }
                
                // Divider line
                Rectangle {
                    width: parent.width
                    height: 1
                    color: "#a0cfff"
                    opacity: 0.3
                }
                
                // Status and Control Section
                Row {
                    width: parent.width
                    height: 100
                    spacing: 30
                    
                    // System Status
                    Column {
                        width: (parent.width - 30) * 0.6
                        spacing: 8
                        
                        Text {
                            text: "SYSTEM STATUS"
                            font.family: "Courier New, monospace"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#a0cfff"
                        }
                        
                        Row {
                            spacing: 10
                            Rectangle {
                                width: 10
                                height: 10
                                radius: 5
                                color: "#a0cfff"  // Blue for normal status
                            }
                            Text {
                                text: "POWER: NOMINAL"
                                font.family: "Courier New, monospace"
                                font.pixelSize: 11
                                color: "#6a8aa8"
                            }
                        }
                        
                        Row {
                            spacing: 10
                            Rectangle {
                                width: 10
                                height: 10
                                radius: 5
                                color: "#a0cfff"  // Blue for normal status
                            }
                            Text {
                                text: "COOLING: 73%"
                                font.family: "Courier New, monospace"
                                font.pixelSize: 11
                                color: "#6a8aa8"
                            }
                        }
                        
                        Row {
                            spacing: 10
                            Rectangle {
                                width: 10
                                height: 10
                                radius: 5
                                color: "#666666"  // Gray for offline
                            }
                            Text {
                                text: "BIOMETRIC: OFFLINE"
                                font.family: "Courier New, monospace"
                                font.pixelSize: 11
                                color: "#6a8aa8"
                            }
                        }
                    }
                    
                    // Controls
                    Column {
                        width: (parent.width - 30) * 0.4
                        spacing: 10
                        
                        Text {
                            text: "OPERATIONS"
                            font.family: "Courier New, monospace"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#a0cfff"
                        }
                        
                        Rectangle {
                            width: parent.width
                            height: 30
                            radius: 4
                            color: "#4f83aa60"
                            border.width: 1
                            border.color: "#a0cfff"
                            
                            Text {
                                anchors.centerIn: parent
                                text: "LOGIN"
                                font.family: "Courier New, monospace"
                                font.pixelSize: 12
                                font.bold: true
                                color: "#a0cfff"
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: mechHUD.loginRequested(usernameInput.text, passwordInput.text)
                            }
                        }
                        
                        Row {
                            width: parent.width
                            spacing: 8
                            
                            Rectangle {
                                width: (parent.width - 8) / 2
                                height: 25
                                radius: 3
                                color: "#aa6a4f60"
                                border.width: 1
                                border.color: "#ffc266"  // Amber border for shutdown
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "SHUTDOWN"
                                    font.family: "Courier New, monospace"
                                    font.pixelSize: 9
                                    font.bold: true
                                    color: "#ffc266"  // Amber text for shutdown
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: mechHUD.powerOffRequested()
                                }
                            }
                            
                            Rectangle {
                                width: (parent.width - 8) / 2
                                height: 25
                                radius: 3
                                color: "#aa8a4f60"
                                border.width: 1
                                border.color: "#ffc266"  // Amber border for reboot
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "REBOOT"
                                    font.family: "Courier New, monospace"
                                    font.pixelSize: 9
                                    font.bold: true
                                    color: "#ffc266"  // Amber text for reboot
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: mechHUD.rebootRequested()
                                }
                            }
                        }
                    }
                }
            }
        }
    
    // Boot sequence animation
    SequentialAnimation {
        id: bootSequence
        running: true
        
        PauseAnimation { duration: 500 }
        ScriptAction { script: bootStep = 1 }
        PauseAnimation { duration: 600 }
        ScriptAction { script: bootStep = 2 }
        PauseAnimation { duration: 400 }
        ScriptAction { script: bootStep = 3 }
        PauseAnimation { duration: 800 }
        ScriptAction { script: bootStep = 4 }
        PauseAnimation { duration: 600 }
        ScriptAction { script: bootStep = 5 }
        PauseAnimation { duration: 400 }
        ScriptAction { script: bootStep = 6 }
        PauseAnimation { duration: 300 }
        ScriptAction { script: { bootStep = 7; bootComplete = true } }
    }
}
