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

function resetDoors() {
    console.log("BunkerDoors: Resetting after failed login")
    doorsOpeningAnimation.stop()
    visible = false
    animationActive = false
    opacity = 1.0
    // Reset door positions
    leftDoor.x = 0
    rightDoor.x = parent.width / 2 - 2
    statusOverlay.opacity = 0.9
}    
    function startAnimation() {
        visible = true
        animationActive = true
        doorsOpeningAnimation.start()
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
            text: "ACCESS GRANTED"
            font.family: "Courier New, monospace"
            font.pixelSize: 24
            font.bold: true
            color: "#4ade80"  // Green for success
        }
        
        // Pulsing effect
        SequentialAnimation on opacity {
            running: bunkerOverlay.visible
            loops: Animation.Infinite
            NumberAnimation { to: 0.7; duration: 800 }
            NumberAnimation { to: 0.9; duration: 800 }
        }
    }
    
    // Door opening animation
    SequentialAnimation {
        id: doorsOpeningAnimation
        
        // Brief pause to show "ACCESS GRANTED"
        PauseAnimation { duration: 800 }
        
        // Update status
        ScriptAction {
            script: {
                statusText.text = "FACILITY ACCESS AUTHORIZED"
                statusText.color = "#a0cfff"
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
                bunkerOverlay.visible = false
                bunkerOverlay.opacity = 1.0
                bunkerOverlay.animationActive = false
                bunkerOverlay.animationComplete()
            }
        }
    }
}
