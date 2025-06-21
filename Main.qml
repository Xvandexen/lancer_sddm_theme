import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    width: Screen.width
    height: Screen.height
    color: "#1e1e2e"
    
    property int sessionIndex: session.index
    
    TextConstants { id: textConstants }
    
    Connections {
        target: sddm
        onLoginSucceeded: {
        }
        onLoginFailed: {
            pw_entry.text = ""
        }
    }
    
    Rectangle {
        width: 400
        height: 300
        color: "#313244"
        radius: 12
        anchors.centerIn: parent
        
        Column {
            anchors.centerIn: parent
            spacing: 20
            
            TextBox {
                id: user_entry
                width: 300
                height: 40
                text: userModel.lastUser
                font.pixelSize: 16
                KeyNavigation.tab: pw_entry
            }
            
            PasswordBox {
                id: pw_entry
                width: 300
                height: 40
                font.pixelSize: 16
                KeyNavigation.backtab: user_entry
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(user_entry.text, pw_entry.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }
            
            Rectangle {
                width: 300
                height: 40
                color: "#cba6f7"
                radius: 8
                
                Text {
                    anchors.centerIn: parent
                    text: "Login"
                    color: "#11111b"
                    font.bold: true
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: sddm.login(user_entry.text, pw_entry.text, sessionIndex)
                }
            }
        }
    }
    
    ComboBox {
        id: session
        visible: false
        model: sessionModel
        index: sessionModel.lastIndex
    }
    
    Component.onCompleted: {
        if (user_entry.text === "")
            user_entry.focus = true
        else
            pw_entry.focus = true
    }
}
