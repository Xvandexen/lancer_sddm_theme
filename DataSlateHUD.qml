import QtQuick 2.0
import SddmComponents 2.0

Item {
    id: mechHUD
    width: 900
    height: 1000
    
    property alias username: usernameInput.text
    property alias password: passwordInput.text
    property bool authenticationFailed: false
    property bool bootComplete: true  // Changed to true for instant login
    property int bootStep: 0
    property string currentTypingText: ""
    property int typingIndex: 0
    property bool isTyping: false
    property var terminalHistory: []
    property var typingQueue: []
    
    signal loginRequested(string username, string password)
    signal powerOffRequested()
    signal rebootRequested()
    
    // Enhanced typing animation function with queue support
    function startTyping(text) {
        // If currently typing, add to queue instead of blocking
        if (isTyping) {
            typingQueue.push(text)
            return
        }
        
        currentTypingText = text
        typingIndex = 0
        isTyping = true
        
        // Add new line to history
        terminalHistory.push("")
        updateTerminalDisplay()
        typingTimer.start()
    }
    
    // Process next item in typing queue
    function processNextTyping() {
        if (typingQueue.length > 0) {
            var nextText = typingQueue.shift()
            // Small delay before starting next typing for readability
            Qt.callLater(function() {
                startTyping(nextText)
            })
        }
    }
    
    function updateTerminalDisplay() {
        var displayText = ""
        for (var i = 0; i < terminalHistory.length; i++) {
            if (displayText !== "") displayText += "<br>"
            
            // Color code the terminal output
            var line = terminalHistory[i]
            if (line.indexOf("[COMP/CON:") !== -1) {
                // COMP/CON responses - find and color the bracketed part
                var beforeBracket = line.substring(0, line.indexOf("[COMP/CON:"))
                var bracketStart = line.indexOf("[COMP/CON:")
                var bracketEnd = line.indexOf("]", bracketStart) + 1
                var bracketContent = line.substring(bracketStart, bracketEnd)
                var afterBracket = line.substring(bracketEnd)
                
                displayText += '<span style="color: #6a8aa8;">' + beforeBracket + '</span>'
                displayText += '<span style="color: #ffc266;">' + bracketContent + '</span>'
                displayText += '<span style="color: #6a8aa8;">' + afterBracket + '</span>'
            } else if (line.startsWith("$ ")) {
                // Commands - $ in gray, command in blue
                displayText += '<span style="color: #6a8aa8;">$ </span>'
                displayText += '<span style="color: #a0cfff;">' + line.substring(2) + '</span>'
            } else if (line.indexOf("WARNING:") !== -1 || line.indexOf("Failed to") !== -1) {
                // Warnings/errors in yellow
                displayText += '<span style="color: #ffc266;">' + line + '</span>'
            } else {
                // Default text in blue
                displayText += '<span style="color: #a0cfff;">' + line + '</span>'
            }
        }
        terminalOutput.text = displayText
        
        // Auto-scroll to bottom
        terminalScroll.contentY = Math.max(0, terminalScroll.contentHeight - terminalScroll.height)
    }
    
    function stopTyping() {
        typingTimer.stop()  // Removed bootComplete check
        isTyping = false
    }
    
    // Typing timer
    Timer {
        id: typingTimer
        interval: 15  // Faster typing - 15ms per character
        repeat: true
        onTriggered: {
            if (typingIndex < currentTypingText.length) {
                // Update the last line in history with current typing progress
                terminalHistory[terminalHistory.length - 1] = currentTypingText.substring(0, typingIndex + 1)
                updateTerminalDisplay()
                typingIndex++
            } else {
                stop()
                isTyping = false
                // Final update to ensure complete text
                terminalHistory[terminalHistory.length - 1] = currentTypingText
                updateTerminalDisplay()
                
                // Process next item in queue after a brief pause
                Qt.callLater(processNextTyping)
            }
        }
    }
    
    HUDFrame {
        anchors.fill: parent
    }
        
    // Content areas within the unified glass surface
    Column {
        anchors.fill: parent
        anchors.margins: 20
        anchors.rightMargin: 60  // Extra margin to account for mounting bracket
        spacing: 15
        
        HeaderSection {
            bootComplete: true  // Always show as ready
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
                
                BootMessages {
                    bootStep: mechHUD.bootStep
                }
                
                // Terminal output for hover interactions - accumulating history
                Text {
                    id: terminalOutput
                    width: parent.width
                    text: ""
                    font.family: "Courier New, monospace"
                    font.pixelSize: 14
                    color: "#a0cfff"  // Commands in original blue
                    visible: text !== ""  // Always visible if there's text
                    wrapMode: Text.Wrap
                    textFormat: Text.RichText  // Enable rich text for color coding
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
        // Authentication Section - Now always visible
        Column {
            width: parent.width
            spacing: 15
            // Removed visible: bootStep >= 7
            
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
                    color: usernameInput.activeFocus || usernameMouseArea.containsMouse ? "#2a3e4d80" : "#1a1e2180"
                    border.width: usernameInput.activeFocus || usernameMouseArea.containsMouse ? 2 : 1
                    border.color: usernameInput.activeFocus ? "#a0cfff" : 
                                 usernameMouseArea.containsMouse ? "#7bb8e8" : "#4a4f55"
                    
                    // Subtle glow effect on hover/focus
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "transparent"
                        border.width: usernameInput.activeFocus || usernameMouseArea.containsMouse ? 1 : 0
                        border.color: "#a0cfff"
                        opacity: 0.3
                        visible: usernameInput.activeFocus || usernameMouseArea.containsMouse
                    }
                    
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
                        
                        onActiveFocusChanged: {
                            if (activeFocus) {
                                startTyping("$ gms-cc-subsys --init-input-buffer username")
                            }
                        }
                    }
                    
                    MouseArea {
                        id: usernameMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: usernameInput.forceActiveFocus()
                        
                        onEntered: {
                            if (!usernameInput.activeFocus && !isTyping) {
                                startTyping("$ hover-detect auth-field --type=username")
                            }
                        }
                        
                        onExited: {
                            // Don't clear on exit - let terminal accumulate
                        }
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
                    color: passwordInput.activeFocus || passwordMouseArea.containsMouse ? "#2a3e4d80" : "#1a1e2180"
                    border.width: passwordInput.activeFocus || passwordMouseArea.containsMouse ? 2 : 1
                    border.color: authenticationFailed ? "#ff5c5c" : 
                                 passwordInput.activeFocus ? "#a0cfff" :
                                 passwordMouseArea.containsMouse ? "#7bb8e8" : "#4a4f55"
                    
                    // Subtle glow effect on hover/focus
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "transparent"
                        border.width: passwordInput.activeFocus || passwordMouseArea.containsMouse ? 1 : 0
                        border.color: authenticationFailed ? "#ff5c5c" : "#a0cfff"
                        opacity: 0.3
                        visible: passwordInput.activeFocus || passwordMouseArea.containsMouse
                    }
                    
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
                        
                        onActiveFocusChanged: {
                            if (activeFocus) {
                                startTyping("$ gms-cc-subsys --init-input-buffer password --encrypted")
                            }
                        }
                    }
                    
                    MouseArea {
                        id: passwordMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: passwordInput.forceActiveFocus()
                        
                        onEntered: {
                            if (!passwordInput.activeFocus && !isTyping) {
                                startTyping("$ hover-detect auth-field --type=password --secure")
                            }
                        }
                        
                        onExited: {
                            // Don't clear on exit - let terminal accumulate
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
                width: (parent.width - 30) * 0.3
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
            // Authentication Checklist Section  
AuthenticationChecklist {
    id: authChecklist
    width: (parent.width -60) * 0.4
    
    // Update states based on input field changes
    Component.onCompleted: {
        // Connect to your existing input field changes
        usernameInput.textChanged.connect(function() {
            authChecklist.setUsernameComplete(usernameInput.text.length > 0)
        })
        
        passwordInput.textChanged.connect(function() {
            authChecklist.setPasswordComplete(passwordInput.text.length > 0)
        })
    }
    
    // Connect to SDDM authentication signals
    Connections {
        target: sddm
        onLoginStarted: {
            // Detect if FIDO challenge is initiated
            authChecklist.startFidoChallenge(30)
        }
        onLoginSucceeded: {
            authChecklist.completeFidoChallenge()
        }
        onLoginFailed: {
            authChecklist.failFidoChallenge()
        }
    }
}
             // Controls
            Column {
                width: (parent.width - 60) * 0.3
                spacing: 10
                
                Text {
                    text: "OPERATIONS"
                    font.family: "Courier New, monospace"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#a0cfff"
                }
                
                Rectangle {
                    id: loginButton
                    width: parent.width
                    height: 30
                    radius: 4
                    color: loginMouseArea.containsMouse ? "#6b9bd480" : "#4f83aa60"
                    border.width: loginMouseArea.containsMouse ? 2 : 1
                    border.color: loginMouseArea.containsMouse ? "#b8e0ff" : "#a0cfff"
                    
                    // Glow effect on hover
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "transparent"
                        border.width: loginMouseArea.containsMouse ? 1 : 0
                        border.color: "#a0cfff"
                        opacity: 0.5
                        visible: loginMouseArea.containsMouse
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "LOGIN"
                        font.family: "Courier New, monospace"
                        font.pixelSize: 12
                        font.bold: true
                        color: loginMouseArea.containsMouse ? "#ffffff" : "#a0cfff"
                    }
                    
                    MouseArea {
                        id: loginMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: mechHUD.loginRequested(usernameInput.text, passwordInput.text)
                        
                        onEntered: {
                            if (!isTyping) {
                                startTyping("$ omninet-auth --execute --pilot=" + (usernameInput.text || "[NULL]"))
                            }
                        }
                        
                        onExited: {
                            // Don't clear on exit - let terminal accumulate
                        }
                    }
                }
                
                Row {
                    width: parent.width
                    spacing: 8
                    
                    Rectangle {
                        id: shutdownButton
                        width: (parent.width - 8) / 2
                        height: 25
                        radius: 3
                        color: shutdownMouseArea.containsMouse ? "#cc7a5f80" : "#aa6a4f60"
                        border.width: shutdownMouseArea.containsMouse ? 2 : 1
                        border.color: shutdownMouseArea.containsMouse ? "#ffde99" : "#ffc266"
                        
                        // Warning glow effect on hover
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: "transparent"
                            border.width: shutdownMouseArea.containsMouse ? 1 : 0
                            border.color: "#ffc266"
                            visible: shutdownMouseArea.containsMouse
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "SHUTDOWN"
                            font.family: "Courier New, monospace"
                            font.pixelSize: 9
                            font.bold: true
                            color: shutdownMouseArea.containsMouse ? "#ffffff" : "#ffc266"
                        }
                        
                        MouseArea {
                            id: shutdownMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: mechHUD.powerOffRequested()
                            
                            onEntered: {
                                if (!isTyping) {
                                    startTyping("$ gms-power-mgmt --shutdown --emergency")
                                }
                            }
                            
                            onExited: {
                                // Don't clear on exit - let terminal accumulate
                            }
                        }
                    }
                    
                    Rectangle {
                        id: rebootButton
                        width: (parent.width - 8) / 2
                        height: 25
                        radius: 3
                        color: rebootMouseArea.containsMouse ? "#cc9a5f80" : "#aa8a4f60"
                        border.width: rebootMouseArea.containsMouse ? 2 : 1
                        border.color: rebootMouseArea.containsMouse ? "#ffde99" : "#ffc266"
                        
                        // Warning glow effect on hover
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: "transparent"
                            border.width: rebootMouseArea.containsMouse ? 1 : 0
                            border.color: "#ffc266"
                            opacity: 0.4
                            visible: rebootMouseArea.containsMouse
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "REBOOT"
                            font.family: "Courier New, monospace"
                            font.pixelSize: 9
                            font.bold: true
                            color: rebootMouseArea.containsMouse ? "#ffffff" : "#ffc266"
                        }
                        
                        MouseArea {
                            id: rebootMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: mechHUD.rebootRequested()
                            
                            onEntered: {
                                if (!isTyping) {
                                    startTyping("$ gms-power-mgmt --reboot --safe-init")
                                }
                            }
                            
                            onExited: {
                                // Don't clear on exit - let terminal accumulate
                            }
                        }
                    }
                }
            }
        }
    }

    // Boot sequence animation - now runs in background for flavor only
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
        ScriptAction { script: bootStep = 7 }
    }
}
