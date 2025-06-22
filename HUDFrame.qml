import QtQuick 2.0

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
    
    // Thicker right edge for mounting connection - extends to screen edge
    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 40  // Much thicker mounting bracket
        color: "#2a2e33"
        radius: 8
        
        // Right edge gradient for depth
        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            radius: parent.radius - 2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#34383d" }
                GradientStop { position: 0.5; color: "#2a2e33" }
                GradientStop { position: 1.0; color: "#20242a" }
            }
        }
        
        // Extended mounting arm that reaches screen edge
        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: -50  // Extends beyond the HUD
            anchors.verticalCenter: parent.verticalCenter
            width: 80  // Wide mounting arm
            height: 20
            color: "#2a2e33"
            radius: 4
            
            // Mounting arm details
            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 10
                height: 8
                color: "#1a1e23"
                radius: 2
            }
            
            // Bolts/rivets on the mounting arm
            Repeater {
                model: 4
                Rectangle {
                    width: 6
                    height: 6
                    radius: 3
                    color: "#4a4a4a"
                    border.width: 1
                    border.color: "#1a1a1a"
                    x: 10 + index * 15
                    anchors.verticalCenter: parent.verticalCenter
                }
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
    
    // Additional rivets along the right mounting bracket
    Repeater {
        model: 8  // More rivets for the bigger bracket
        Rectangle {
            width: 16
            height: 16
            color: "#2a2e33"
            border.width: 2
            border.color: "#1a1a1a"
            radius: 8
            x: parent.width - 20  // Positioned on the wider bracket
            y: 60 + index * 120
            
            Rectangle {
                anchors.centerIn: parent
                width: 8
                height: 8
                color: "#4a4a4a"
                radius: 4
            }
        }
    }
    
    // Connection ports on right mounting bracket
    Rectangle {
        x: parent.width - 30
        y: parent.height * 0.25
        width: 20
        height: 10
        color: "#1a1a1a"
        radius: 5
        border.width: 2
        border.color: "#0a0a0a"
    }
    
    Rectangle {
        x: parent.width - 30
        y: parent.height * 0.5
        width: 20
        height: 10
        color: "#1a1a1a"
        radius: 5
        border.width: 2
        border.color: "#0a0a0a"
    }
    
    Rectangle {
        x: parent.width - 30
        y: parent.height * 0.75
        width: 20
        height: 10
        color: "#1a1a1a"
        radius: 5
        border.width: 2
        border.color: "#0a0a0a"
    }
    
    // Single unified frosted glass surface inside the steel frame
    Rectangle {
        anchors.fill: parent
        anchors.margins: 12
        anchors.rightMargin: 50  // More margin for the bigger mounting bracket
        radius: 6
        
        // Steel blue frosted glass
        color: "#2a2e33"
        opacity: 0.4
        border.width: 1
        border.color: "#a0cfff"
    }
}
