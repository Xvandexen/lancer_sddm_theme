import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    width: Screen.width
    height: Screen.height
    color: "#0a0a0a"
    
    property int sessionIndex: session.index
    
    TextConstants { id: textConstants }
    
    Connections {
        target: sddm
        onLoginSucceeded: {
            dataSlateHUD.systemStatus = "ACCESS GRANTED"
            // Add success animation here later
        }
    
    // Timer for resetting failed authentication state
    Timer {
        id: failedTimer
        interval: 2000
        onTriggered: {
            dataSlateHUD.authenticationFailed = false
            dataSlateHUD.systemStatus = "SECURE"
        }
    }
        onLoginFailed: {
            dataSlateHUD.authenticationFailed = true
            dataSlateHUD.systemStatus = "ACCESS DENIED"
            
            // Reset failed state after animation
            failedTimer.start()
        }
    }
    
    // Temporary background - will be replaced with bunker door
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a1a2e" }
            GradientStop { position: 0.5; color: "#16213e" }
            GradientStop { position: 1.0; color: "#0f1419" }
        }
        
        // Add some subtle grid pattern for sci-fi feel
        Repeater {
            model: 20
            Rectangle {
                width: parent.width
                height: 1
                y: index * (parent.height / 20)
                color: "#ffffff"
                opacity: 0.02
            }
        }
        
        Repeater {
            model: 30
            Rectangle {
                width: 1
                height: parent.height
                x: index * (parent.width / 30)
                color: "#ffffff"
                opacity: 0.02
            }
        }
    }
    
    // Large "LANCER" text in background
    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -100
        text: "LANCER"
        font.family: "monospace"
        font.pointSize: 120
        font.bold: true
        color: "#ffffff"
        opacity: 0.03
        transform: Rotation { angle: -15 }
    }
    
    // DataSlate HUD positioned on the right
    DataSlateHUD {
        id: dataSlateHUD
        anchors.right: parent.right
        anchors.rightMargin: 50
        anchors.verticalCenter: parent.verticalCenter
        
        // Connect HUD signals to SDDM actions
        onLoginRequested: function(username, password) {
            sddm.login(username, password, sessionIndex)
        }
        
        onPowerOffRequested: {
            sddm.powerOff()
        }
        
        onRebootRequested: {
            sddm.reboot()
        }
        
        // Simulate hardware key detection
        // In real implementation, this would check for actual hardware
        hardwareKeyDetected: Math.random() > 0.5
    }
    
    // Hidden session selector (keep for compatibility)
    ComboBox {
        id: session
        visible: false
        model: sessionModel
        index: sessionModel.lastIndex
    }
    
    // Focus management
    Component.onCompleted: {
        if (dataSlateHUD.username === "")
            dataSlateHUD.children[1].children[1].children[1].children[1].children[1].focus = true
        else
            dataSlateHUD.children[1].children[1].children[2].children[1].children[1].focus = true
    }
}
