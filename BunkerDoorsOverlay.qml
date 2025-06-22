import QtQuick 2.0

// Bunker Doors Opening Animation Overlay
// This covers the entire screen during login success to hide
// SDDM shutdown and desktop session startup transitions
Item {
    id: bunkerOverlay
    anchors.fill: parent
    visible: false
    z: 1000  // Above everything else
    
    property bool animationActive: false
    
    signal animationComplete()
    
    function startAnimation() {
        console.log("BunkerDoors: Starting animation")
        visible = true
        animationActive = true
        doorsOpeningAnimation.start()
    }
    
    function abortAnimation() {
        console.log("BunkerDoors: Aborting animation due to login failure")
        doorsOpeningAnimation.stop()
        
        // Quick "slam shut" animation back to closed
        doorCloseAnimation.start()
    }
    
    // Background behind doors (in case desktop isn't loaded yet)
    Rectangle {
        anchors.fill: parent
        color: "#0a0a0a"
    }
    
    // Left door panel
    Rectangle {
        id: leftDoor
        width: parent.width / 2 + 2  // +2 for overlap to prevent gap
        height: parent.height
        x: 0
        color: "#2a2e33"
        
        // Steel door surface with rivets and panels
        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            color: "#34383d"
            
            // Vertical ribbing pattern
            Repeater {
                model: Math.floor(parent.width / 30)
                Rectangle {
                    width: 2
                    height: parent.height
                    x: index * 30
                    color: "#1a1e23"
                    opacity: 0.8
                }
            }
            
            // Horizontal support beams
            Repeater {
                model: 8
                Rectangle {
                    width: parent.width
                    height: 8
                    y: index * (parent.height / 8)
                    color: "#4a4f55"
                    border.width: 1
                    border.color: "#1a1e23"
                }
            }
            
            // Rivets along the edges
            Repeater {
                model: 20
                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: "#4a4a4a"
                    border.width: 2
                    border.color: "#1a1a1a"
                    x: parent.width - 20
                    y: 20 + index * ((parent.height - 40) / 20)
                    
                    Rectangle {
                        anchors.centerIn: parent
                        width: 4
                        height: 4
                        radius: 2
                        color: "#2a2a2a"
                    }
                }
            }
        }
        
        // Door edge/seal
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 4
            color: "#1a1e23"
        }
    }
    
    // Right door panel (mirrored)
    Rectangle {
        id: rightDoor
        width: parent.width / 2 + 2  // +2 for overlap
        height: parent.height
        x: parent.width / 2 - 2
        color: "#2a2e33"
        
        // Steel door surface with rivets and panels
        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            color: "#34383d"
            
            // Vertical ribbing pattern
            Repeater {
                model: Math.floor(parent.width / 30)
                Rectangle {
                    width: 2
                    height: parent.height
                    x: index * 30
                    color: "#1a1e23"
                    opacity: 0.8
                }
            }
            
            // Horizontal support beams
            Repeater {
                model: 8
                Rectangle {
                    width: parent.width
                    height: 8
                    y: index * (parent.height / 8)
                    color: "#4a4f55"
                    border.width: 1
                    border.color: "#1a1e23"
                }
            }
            
            // Rivets along the edges
            Repeater {
                model: 20
                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: "#4a4a4a"
                    border.width: 2
                    border.color: "#1a1a1a"
                    x: 20
                    y: 20 + index * ((parent.height - 40) / 20)
                    
                    Rectangle {
                        anchors.centerIn: parent
                        width: 4
                        height: 4
                        radius: 2
                        color: "#2a2a2a"
                    }
                }
            }
        }
        
        // Door edge/seal
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 4
            color: "#1a1e23"
        }
    }
    
    // Central seam/lock area (visible when doors are closed)
    Rectangle {
        id: centralSeam
        width: 4
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#0a0a0a"
        visible: !animationActive
    }
    
    // Status text overlay
    Rectangle {
        id: statusOverlay
        anchors.centerIn: parent
        width: 400
        height: 100
        color: "#0a0a0a"
        opacity: 0.9
        radius: 8
        border.width: 2
        border.color: "#a0cfff"
        
        Text {
            id: statusText
            anchors.centerIn: parent
            text: "AUTHENTICATING..."
            font.family: "Courier New, monospace"
            font.pixelSize: 24
            font.bold: true
            color: "#ffc266"  // Yellow for authenticating
        }
        
        // Pulsing effect
        SequentialAnimation on opacity {
            running: bunkerOverlay.visible
            loops: Animation.Infinite
            NumberAnimation { to: 0.7; duration: 800 }
            NumberAnimation { to: 0.9; duration: 800 }
        }
    }
    
    // Door opening animation (success path)
    SequentialAnimation {
        id: doorsOpeningAnimation
        
        // Brief pause to show "AUTHENTICATING"
        PauseAnimation { duration: 800 }
        
        // Update status to "ACCESS GRANTED"
        ScriptAction {
            script: {
                console.log("BunkerDoors: Updating to ACCESS GRANTED")
                statusText.text = "ACCESS GRANTED"
                statusText.color = "#4ade80"  // Green
            }
        }
        
        PauseAnimation { duration: 500 }
        
        // Update status to facility access
        ScriptAction {
            script: {
                statusText.text = "FACILITY ACCESS AUTHORIZED"
                statusText.color = "#a0cfff"  // Blue
            }
        }
        
        PauseAnimation { duration: 500 }
        
        // Doors opening animation
        ParallelAnimation {
            // Left door slides left
            NumberAnimation {
                target: leftDoor
                property: "x"
                from: 0
                to: -leftDoor.width
                duration: 2000
                easing.type: Easing.InOutCubic
            }
            
            // Right door slides right
            NumberAnimation {
                target: rightDoor
                property: "x"
                from: parent.width / 2 - 2
                to: parent.width + 2
                duration: 2000
                easing.type: Easing.InOutCubic
            }
            
            // Fade out status overlay
            NumberAnimation {
                target: statusOverlay
                property: "opacity"
                from: 0.9
                to: 0.0
                duration: 1500
            }
        }
        
        // Brief pause with doors open
        PauseAnimation { duration: 500 }
        
        // Final fade out
        NumberAnimation {
            target: bunkerOverlay
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 800
        }
        
        // Cleanup
        ScriptAction {
            script: {
                console.log("BunkerDoors: Animation complete")
                bunkerOverlay.visible = false
                bunkerOverlay.opacity = 1.0
                bunkerOverlay.animationActive = false
                bunkerOverlay.animationComplete()
                
                // Reset status for next time
                statusText.text = "AUTHENTICATING..."
                statusText.color = "#ffc266"
                statusOverlay.opacity = 0.9
            }
        }
    }
    
    // Quick door close animation for failures
    SequentialAnimation {
        id: doorCloseAnimation
        
        // Update status to show failure
        ScriptAction {
            script: {
                console.log("BunkerDoors: Showing ACCESS DENIED")
                statusText.text = "ACCESS DENIED"
                statusText.color = "#ef4444"  // Red
            }
        }
        
        // Quick slam back to closed position with bounce
        ParallelAnimation {
            NumberAnimation {
                target: leftDoor
                property: "x"
                to: 0
                duration: 600
                easing.type: Easing.OutBack
            }
            NumberAnimation {
                target: rightDoor
                property: "x"
                to: parent.width / 2 - 2
                duration: 600
                easing.type: Easing.OutBack
            }
        }
        
        // Brief pause showing failure
        PauseAnimation { duration: 1500 }
        
        // Fade out and reset
        NumberAnimation {
            target: bunkerOverlay
            property: "opacity"
            to: 0.0
            duration: 500
        }
        
        ScriptAction {
            script: {
                console.log("BunkerDoors: Reset after failure")
                visible = false
                opacity = 1.0
                animationActive = false
                
                // Reset status for next attempt
                statusText.text = "AUTHENTICATING..."
                statusText.color = "#ffc266"
                statusOverlay.opacity = 0.9
            }
        }
    }
}
