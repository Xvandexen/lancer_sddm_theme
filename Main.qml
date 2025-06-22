import QtQuick 2.0
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
            console.log("LOGIN SUCCEEDED - continuing doors animation")
            dataSlateHUD.systemStatus = "ACCESS GRANTED"
            // Animation continues to completion
        }
        onLoginFailed: {
            console.log("LOGIN FAILED - stopping and resetting doors")
            dataSlateHUD.authenticationFailed = true
            dataSlateHUD.systemStatus = "ACCESS DENIED"
            // Stop and reset the doors animation
            bunkerDoors.abortAnimation()
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
        onLoginRequested: {
            console.log("Login requested - starting doors animation")
            // Start animation BEFORE calling sddm.login
            bunkerDoors.startAnimation()
            // Brief delay then trigger actual login
            loginDelayTimer.start()
        }
        
        onPowerOffRequested: {
            sddm.powerOff()
        }
        
        onRebootRequested: {
            sddm.reboot()
        }
        
        // Store login credentials for delayed execution
        property string pendingUsername: ""
        property string pendingPassword: ""
        
        // Timer to delay actual login call after animation starts
        Timer {
            id: loginDelayTimer
            interval: 500  // Half second delay for animation to start
            onTriggered: {
                console.log("Executing delayed login")
                sddm.login(dataSlateHUD.pendingUsername, dataSlateHUD.pendingPassword, sessionIndex)
            }
        }
    }
    
    // Update the login signal connection to store credentials
    Connections {
        target: dataSlateHUD
        onLoginRequested: {
            // Store credentials for delayed execution
            dataSlateHUD.pendingUsername = username
            dataSlateHUD.pendingPassword = password
        }
    }
    
    // Hidden session selector (keep for compatibility)
    ComboBox {
        id: session
        visible: false
        model: sessionModel
        index: sessionModel.lastIndex
    }
    
    // Bunker Doors Opening Animation - loads above everything
    BunkerDoorsOverlay {
        id: bunkerDoors
        
        onAnimationComplete: {
            // Animation is complete, session should be started by now
            // If needed, we could add additional cleanup here
        }
    }
    
    // Focus management
    Component.onCompleted: {
        // Focus on the HUD when loaded
        dataSlateHUD.forceActiveFocus()
        console.log("Lancer theme loaded - Press F12 to test bunker doors")
    }
    
    // Test trigger for debugging
    Keys.onPressed: {
        if (event.key === Qt.Key_F12) {
            console.log("F12 pressed - Testing bunker doors animation")
            bunkerDoors.startAnimation()
            event.accepted = true
        }
    }
}
