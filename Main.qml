import QtQuick 2.0
import SddmComponents 2.0
import Qt.labs.platform 1.1

Rectangle {
    width: Screen.width
    height: Screen.height
    color: "#0a0a0a"
    
    property int sessionIndex: session.index
    
    TextConstants { id: textConstants }
    
    function launchExternalAnimation() {
        console.log("Main: Launching external bunker doors animation")
        
        // Try to launch the external animation script
        try {
            var process = Qt.createQmlObject('
                import Qt.labs.platform 1.1
                Process {
                    id: animationProcess
                    program: "/usr/share/sddm/themes/lancer/bunker-doors-launcher.sh"
                    
                    onFinished: {
                        console.log("Animation launcher finished with code:", exitCode)
                    }
                    
                    onErrorOccurred: {
                        console.log("Animation launcher error:", error)
                    }
                    
                    Component.onCompleted: {
                        console.log("Starting external animation process")
                        start()
                    }
                }
            ', root);
        } catch (e) {
            console.log("Failed to create external process:", e)
            
            // Fallback: try direct qml execution
            try {
                var fallbackProcess = Qt.createQmlObject('
                    import Qt.labs.platform 1.1
                    Process {
                        program: "qml"
                        arguments: ["/usr/share/sddm/themes/lancer/bunker-doors-standalone.qml"]
                        
                        Component.onCompleted: {
                            console.log("Starting fallback QML process")
                            startDetached()
                        }
                    }
                ', root);
            } catch (e2) {
                console.log("Fallback process also failed:", e2)
            }
        }
    }
    
    Connections {
        target: sddm
        onLoginSucceeded: {
            console.log("LOGIN SUCCEEDED - launching external animation")
            dataSlateHUD.systemStatus = "ACCESS GRANTED"
            // Launch the external animation that will survive SDDM termination
            launchExternalAnimation()
        }
        onLoginFailed: {
            console.log("LOGIN FAILED")
            dataSlateHUD.authenticationFailed = true
            dataSlateHUD.systemStatus = "ACCESS DENIED"
        }
    }
    
    // Background
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
        
        // Connect HUD signals to SDDM actions (no animation logic here)
        onLoginRequested: {
            console.log("Login requested - calling sddm.login")
            sddm.login(username, password, sessionIndex)
        }
        
        onPowerOffRequested: {
            sddm.powerOff()
        }
        
        onRebootRequested: {
            sddm.reboot()
        }
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
        // Focus on the HUD when loaded
        dataSlateHUD.forceActiveFocus()
        console.log("Lancer theme loaded - external animation ready")
    }
}
