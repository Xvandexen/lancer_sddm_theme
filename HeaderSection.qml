import QtQuick 2.0

import QtQuick 2.0

// Header Section
Row {
    width: parent.width
    height: 70
    spacing: 30
    
    property bool bootComplete: false
    
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
