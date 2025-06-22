import QtQuick 2.0

Column {
    id: authChecklist
    width: parent.width
    spacing: 8
    
    // Authentication states
    property bool usernameComplete: false
    property bool passwordComplete: false
    property bool fidoKeyWaiting: false
    property bool fidoKeyComplete: false
    property bool fidoKeyFailed: false
    property int fidoTimeout: 30
    property bool biometricPending: false
    property bool biometricComplete: false
    
    // Header
    Text {
        text: "PILOT AUTHENTICATION SEQUENCE"
        font.family: "Courier New, monospace"
        font.pixelSize: 14
        font.bold: true
        color: "#a0cfff"
    }
    
    // Username check
    Row {
        spacing: 10
        
        Text {
            text: "┌─"
            font.family: "Courier New, monospace"
            font.pixelSize: 14
            color: "#6a8aa8"
        }
        
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: usernameComplete ? "#4ade80" : "#6b7280"
            border.width: 1
            border.color: usernameComplete ? "#22c55e" : "#4b5563"
            anchors.verticalCenter: parent.verticalCenter
            
            // Inner dot for completed state
            Rectangle {
                anchors.centerIn: parent
                width: 6
                height: 6
                radius: 3
                color: usernameComplete ? "#16a34a" : "transparent"
            }
        }
        
        Text {
            text: "USER ID" + (usernameComplete ? "         [CONFIRMED]" : "         [PENDING]")
            font.family: "Courier New, monospace"
            font.pixelSize: 14
            color: usernameComplete ? "#4ade80" : "#6a8aa8"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    // Password check
    Row {
        spacing: 10
        
        Text {
            text: "├─"
            font.family: "Courier New, monospace"
            font.pixelSize: 14
            color: "#6a8aa8"
        }
        
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: passwordComplete ? "#4ade80" : "#6b7280"
            border.width: 1
            border.color: passwordComplete ? "#22c55e" : "#4b5563"
            anchors.verticalCenter: parent.verticalCenter
            
            Rectangle {
                anchors.centerIn: parent
                width: 6
                height: 6
                radius: 3
                color: passwordComplete ? "#16a34a" : "transparent"
            }
        }
        
        Text {
            text: "PASSWORD" + (passwordComplete ? "      [CONFIRMED]" : "      [PENDING]")
            font.family: "Courier New, monospace"
            font.pixelSize: 14
            color: passwordComplete ? "#4ade80" : "#6a8aa8"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    // Hardware key check
    Column {
        spacing: 3
        
        Row {
            spacing: 10
            
            Text {
                text: "├─"
                font.family: "Courier New, monospace"
                font.pixelSize: 14
                color: "#6a8aa8"
            }
            
            Rectangle {
                width: 12
                height: 12
                radius: 6
                color: fidoKeyFailed ? "#ef4444" :
                       fidoKeyComplete ? "#4ade80" :
                       fidoKeyWaiting ? "#fbbf24" : "#6b7280"
                border.width: 1
                border.color: fidoKeyFailed ? "#dc2626" :
                             fidoKeyComplete ? "#22c55e" :
                             fidoKeyWaiting ? "#f59e0b" : "#4b5563"
                anchors.verticalCenter: parent.verticalCenter
                
                // Pulsing animation for waiting state
                Rectangle {
                    anchors.centerIn: parent
                    width: fidoKeyWaiting ? 8 : 6
                    height: fidoKeyWaiting ? 8 : 6
                    radius: fidoKeyWaiting ? 4 : 3
                    color: fidoKeyFailed ? "#dc2626" :
                           fidoKeyComplete ? "#16a34a" :
                           fidoKeyWaiting ? "#f59e0b" : "transparent"
                    
                    // Pulsing animation
                    SequentialAnimation on opacity {
                        running: fidoKeyWaiting
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.3; duration: 800 }
                        NumberAnimation { to: 1.0; duration: 800 }
                    }
                }
                
                // Failed state X
                Text {
                    anchors.centerIn: parent
                    text: "✗"
                    font.pixelSize: 8
                    color: "#ffffff"
                    visible: fidoKeyFailed
                }
            }
            
            Text {
                text: {
                    if (fidoKeyFailed) return "HARDWARE KEY    [FAILED]"
                    if (fidoKeyComplete) return "HARDWARE KEY    [CONFIRMED]"
                    if (fidoKeyWaiting) return "HARDWARE KEY    [TOUCH SECURITY KEY NOW]"
                    return "HARDWARE KEY    [PENDING]"
                }
                font.family: "Courier New, monospace"
                font.pixelSize: 14
                color: fidoKeyFailed ? "#ef4444" :
                       fidoKeyComplete ? "#4ade80" :
                       fidoKeyWaiting ? "#fbbf24" : "#6a8aa8"
                anchors.verticalCenter: parent.verticalCenter
                font.bold: fidoKeyWaiting
            }
        }
        
        // Timeout display for FIDO waiting
        Row {
            spacing: 10
            visible: fidoKeyWaiting
            
            Text {
                text: "│"
                font.family: "Courier New, monospace"
                font.pixelSize: 14
                color: "#6a8aa8"
            }
            
            Text {
                text: "                  └─ TIMEOUT: " + fidoTimeout + "s"
                font.family: "Courier New, monospace"
                font.pixelSize: 12
                color: "#fbbf24"
            }
        }
    }
    
    // Biometric check (placeholder for future expansion)
    Row {
        spacing: 10
        
        Text {
            text: "└─"
            font.family: "Courier New, monospace"
            font.pixelSize: 14
            color: "#6a8aa8"
        }
        
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: biometricComplete ? "#4ade80" : "#6b7280"
            border.width: 1
            border.color: biometricComplete ? "#22c55e" : "#4b5563"
            anchors.verticalCenter: parent.verticalCenter
            
            Rectangle {
                anchors.centerIn: parent
                width: 6
                height: 6
                radius: 3
                color: biometricComplete ? "#16a34a" : "transparent"
            }
        }
        
        Text {
            text: "BIOMETRIC" + (biometricComplete ? "     [CONFIRMED]" : "     [OFFLINE]")
            font.family: "Courier New, monospace"
            font.pixelSize: 14
            color: biometricComplete ? "#4ade80" : "#6a8aa8"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    // Timeout countdown timer for FIDO
    Timer {
        id: fidoTimer
        interval: 1000
        repeat: true
        running: fidoKeyWaiting && fidoTimeout > 0
        onTriggered: {
            fidoTimeout--
            if (fidoTimeout <= 0) {
                fidoKeyWaiting = false
                fidoKeyFailed = true
            }
        }
    }
    
    // Public functions to control the checklist
    function setUsernameComplete(complete) {
        usernameComplete = complete
    }
    
    function setPasswordComplete(complete) {
        passwordComplete = complete
    }
    
    function startFidoChallenge(timeoutSeconds) {
        fidoTimeout = timeoutSeconds || 30
        fidoKeyWaiting = true
        fidoKeyComplete = false
        fidoKeyFailed = false
    }
    
    function completeFidoChallenge() {
        fidoKeyWaiting = false
        fidoKeyComplete = true
        fidoKeyFailed = false
    }
    
    function failFidoChallenge() {
        fidoKeyWaiting = false
        fidoKeyComplete = false
        fidoKeyFailed = true
    }
    
    function resetFido() {
        fidoKeyWaiting = false
        fidoKeyComplete = false
        fidoKeyFailed = false
        fidoTimeout = 30
    }
    
    function setBiometricComplete(complete) {
        biometricComplete = complete
    }
    
    function resetAll() {
        usernameComplete = false
        passwordComplete = false
        resetFido()
        biometricComplete = false
    }
}
