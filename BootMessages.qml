import QtQuick 2.0

Column {
    id: bootMessages
    width: parent.width
    spacing: 4
    
    property int bootStep: 0
    
    Text {
        width: parent.width
        text: "Initializing semantic manifold . . . " + (bootStep >= 1 ? "done" : "")
        font.family: "Courier New, monospace"
        font.pixelSize: 14
        color: "#6a8aa8"  // Gray system color
        font.bold: bootStep < 1
    }
    
    Text {
        width: parent.width
        text: bootStep >= 2 ? "Initializing logic gradients . . . done" : 
              bootStep >= 1 ? "Initializing logic gradients . . ." : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 14
        color: "#6a8aa8"  // Gray system color
        font.bold: bootStep >= 1 && bootStep < 2
        visible: bootStep >= 1
    }
    
    Text {
        width: parent.width
        text: bootStep >= 3 ? "1.0255EB FREE (3.6EB TOTAL)" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 14
        color: "#6a8aa8"
        visible: bootStep >= 3
    }
    
    Text {
        width: parent.width
        text: bootStep >= 3 ? "KERNEL supported CPUs:" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 14
        color: "#6a8aa8"
        visible: bootStep >= 3
    }
    
    Text {
        width: parent.width
        text: bootStep >= 3 ? "  GMS MISSISSIPPI Series (MkII+)" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 13
        color: "#6a8aa8"
        visible: bootStep >= 3
    }
    
    Text {
        width: parent.width
        text: bootStep >= 3 ? "  IPS-N Carronade v9.1+" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 13
        color: "#6a8aa8"
        visible: bootStep >= 3
    }
    
    Text {
        width: parent.width
        text: bootStep >= 3 ? "  SSC Premier IV-XIV" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 13
        color: "#6a8aa8"
        visible: bootStep >= 3
    }
    
    Text {
        width: parent.width
        text: bootStep >= 4 ? "Establishing encrypted link (24::BLUE CASCADE) . . . done" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 14
        color: "#6a8aa8"
        visible: bootStep >= 4
    }
    
    Text {
        width: parent.width
        text: bootStep >= 5 ? "WARNING: FRAME NOT PRESENT OR INVALID" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 14
        color: "#ffc266"  // Yellow for warnings only
        font.bold: true
        visible: bootStep >= 5
    }
    
    Text {
        width: parent.width
        text: bootStep >= 6 ? "No sensory bridge found // manual input mode enabled" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 14
        color: "#6a8aa8"  // Gray system color
        visible: bootStep >= 6
    }
    
    Text {
        width: parent.width
        text: bootStep >= 7 ? "" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 14
        visible: bootStep >= 7
    }
    
    Text {
        width: parent.width
        text: bootStep >= 7 ? ">//[COMP/CON: Authentication Required. Input Credentials.]" : ""
        font.family: "Courier New, monospace"
        font.pixelSize: 16
        color: "#a0cfff"  // COMP/CON messages in blue
        font.bold: true
        visible: bootStep >= 7
    }
}
