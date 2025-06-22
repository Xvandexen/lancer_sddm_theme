import QtQuick 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    id: animationWindow
    
    // Full screen, always on top
    visibility: Window.FullScreen
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
    
    // Set to screen dimensions
    width: Screen.width
    height: Screen.height
    
    // Make it overlay everything
    color: "transparent"
    
    // Self-destruct timer
    Timer {
        id: selfDestruct
        interval: 5000  // 5 seconds max runtime
        running: true
        onTriggered: {
            console.log("BunkerDoors: Self-destructing")
            Qt.quit()
        }
    }
    
    // Background (initially transparent, becomes opaque when doors show)
    Rectangle {
        id: background
        anchors.fill: parent
        color: "#0a0a0a"
        opacity: 0
        
        // Fade in when animation starts
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
    
    // Left door panel
    Rectangle {
        id: leftDoor
        width: parent.width / 2 + 2
        height: parent.height
        x: 0
        color: "#2a2e33"
        opacity: 0
        
        // Steel door surface
        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            color: "#34383d"
            
            // Vertical ribbing
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
            
            // Horizontal beams
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
            
            // Rivets
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
        
        // Door edge
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 4
            color: "#1a1e23"
        }
    }
    
    // Right door panel
    Rectangle {
        id: rightDoor
        width: parent.width / 2 + 2
        height: parent.height
        x: parent.width / 2 - 2
        color: "#2a2e33"
        opacity: 0
        
        // Steel door surface
        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            color: "#34383d"
            
            // Vertical ribbing
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
            
            // Horizontal beams
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
            
            // Rivets
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
        
        // Door edge
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 4
            color: "#1a1e23"
        }
    }
    
    // Central seam
    Rectangle {
        id: centralSeam
        width: 4
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#0a0a0a"
        opacity: 0
    }
    
    // Status overlay
    Rectangle {
        id: statusOverlay
        anchors.centerIn: parent
        width: 500
        height: 120
        color: "#0a0a0a"
        opacity: 0
        radius: 8
        border.width: 2
        border.color: "#a0cfff"
        
        Text {
            id: statusText
            anchors.centerIn: parent
            text: "ACCESS GRANTED"
            font.family: "Courier New, monospace"
            font.pixelSize: 28
            font.bold: true
            color: "#4ade80"
        }
    }
    
    // Main animation sequence
    SequentialAnimation {
        id: mainAnimation
        running: true  // Start immediately
        
        // Show doors closed
        ParallelAnimation {
            NumberAnimation { target: background; property: "opacity"; to: 1.0; duration: 200 }
            NumberAnimation { target: leftDoor; property: "opacity"; to: 1.0; duration: 200 }
            NumberAnimation { target: rightDoor; property: "opacity"; to: 1.0; duration: 200 }
            NumberAnimation { target: centralSeam; property: "opacity"; to: 1.0; duration: 200 }
            NumberAnimation { target: statusOverlay; property: "opacity"; to: 0.9; duration: 200 }
        }
        
        // Brief pause
        PauseAnimation { duration: 800 }
        
        // Update status
        ScriptAction {
            script: {
                statusText.text = "FACILITY ACCESS AUTHORIZED"
                statusText.color = "#a0cfff"
            }
        }
        
        PauseAnimation { duration: 600 }
        
        // Open doors
        ParallelAnimation {
            NumberAnimation {
                target: leftDoor
                property: "x"
                to: -leftDoor.width
                duration: 2200
                easing.type: Easing.InOutCubic
            }
            NumberAnimation {
                target: rightDoor
                property: "x"
                to: parent.width + 2
                duration: 2200
                easing.type: Easing.InOutCubic
            }
            NumberAnimation {
                target: statusOverlay
                property: "opacity"
                to: 0.0
                duration: 1800
            }
        }
        
        // Brief pause with doors open
        PauseAnimation { duration: 500 }
        
        // Fade everything out
        NumberAnimation {
            target: animationWindow
            property: "opacity"
            to: 0.0
            duration: 800
        }
        
        // Quit application
        ScriptAction {
            script: {
                console.log("BunkerDoors: Animation complete, quitting")
                Qt.quit()
            }
        }
    }
    
    Component.onCompleted: {
        console.log("BunkerDoors: Standalone animation started")
        console.log("Screen size:", Screen.width, "x", Screen.height)
    }
}
