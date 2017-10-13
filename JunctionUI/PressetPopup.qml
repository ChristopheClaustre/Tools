import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

Popup {
    id: popup
    width: parent.width / 1.3
    height: parent.height / 2.0
    x: (parent.width/2.0) - (width/2.0)
    y: (parent.height/2.0) - (height/2.0)
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property string results: "test"
    property string errors: "test"

    ColumnLayout {
        id: column
        anchors.fill: parent
        property bool hasErrors: (popup.errors != "")

        GroupBox {
            title: (column.hasErrors) ? "Error" : "Results"
            font.pixelSize: 18
            font.bold: true
            font.capitalization: Font.AllUppercase

            Layout.fillHeight: true
            Layout.fillWidth: true
            TextArea {
                anchors.fill: parent

                font.pixelSize: 16
                font.bold: false
                font.capitalization: Font.MixedCase

                text: (column.hasErrors) ? popup.errors : results
                color: (column.hasErrors) ? Qt.lighter("red", 1.2) : Material.foreground
                readOnly: true
                wrapMode: TextEdit.Wrap
            }
        }

        Button {
            text: (column.hasErrors) ? "Ok !! :/" : "Ok !! :)"
            enabled: valid
            Layout.alignment: Qt.AlignHCenter

            onClicked: {
                popup.close()
            }
        }
    }
}
