import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import MakeLink 1.0

ApplicationWindow {
    visible: true
    width: 500
    height: 570
    minimumWidth: 500
    minimumHeight: 570
    title: qsTr("Make Link")

    flags: Qt.Window | Qt.WindowTitleHint

    property bool linkValid: linkField.acceptableInput
    property bool linkFolderValid: false
    property bool targetValid: false
    property bool valid: linkValid && linkFolderValid && targetValid
    property bool needDirectory: jOption.checked && dOption.checked

    Item {
        anchors.fill: parent
        anchors.margins: 15

        focus: true

        ColumnLayout {
            anchors.fill: parent
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

            RowLayout {
                Layout.fillWidth: true
                Button {
                    id: linkButton
                    Layout.fillWidth: true
                    text: "link's parent folder"

                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: Material.foreground
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideMiddle
                    }

                    onClicked: linkFolderDialog.open()
                }
                TextField {
                    id: linkField
                    Layout.minimumWidth: 0.25 * parent.width
                    placeholderText: "link name ..."
                    validator: RegExpValidator { id:validator; regExp: /[A-Za-z0-9_ -]*/ }

                    property string initialColor: "red"

                    onTextChanged: {
                        color = acceptableInput? initialColor : "red"
                    }

                    onAccepted: if (valid) validate()

                    Component.onCompleted: initialColor = color
                }
            }

            Button {
                id: targetButton
                Layout.fillWidth: true
                text: "target"

                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: Material.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideMiddle
                }

                onClicked: targetDialog.open()
            }

            GroupBox {
                title: "options"
                font.pixelSize: 18
                font.bold: true
                font.capitalization: Font.AllUppercase

                Layout.fillWidth: true
                RowLayout {
                    anchors.fill: parent

                    RadioButton {
                        font.pixelSize: 16
                        font.bold: false
                        text: "aucune"

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    }
                    RadioButton {
                        id: dOption
                        font.pixelSize: 16
                        font.bold: false
                        text: "/D"

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    }
                    RadioButton {
                        id: jOption
                        font.pixelSize: 16
                        font.bold: false
                        text: "/J"
                        checked: true

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    }
                    RadioButton {
                        id: hOption
                        font.pixelSize: 16
                        font.bold: false
                        text: "/H"

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                    }
                }
            }

            GroupBox {
                title: "Help"
                font.pixelSize: 18
                font.bold: true
                font.capitalization: Font.AllUppercase

                Layout.fillHeight: true
                Layout.fillWidth: true
                TextArea {
                    font.pixelSize: 15
                    font.bold: false
                    font.capitalization: Font.MixedCase

                    text: makeLink.help
                    readOnly: true
                    wrapMode: TextEdit.Wrap
                    activeFocusOnPress: false
                    activeFocusOnTab: false
                }
            }

            RowLayout {
                Button {
                    id: cancelButton
                    Layout.fillWidth: true
                    text: "Cancel"

                    onClicked: Qt.quit()
                }

                Button {
                    id: goButton
                    Layout.fillWidth: true
                    text: "Go !!"
                    enabled: valid

                    onClicked: validate()
                }
            }
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Enter)
                if (valid) validate()
            if (event.key === Qt.Key_Escape)
                Qt.quit()
        }
    }

    function validate() {
        var option = "" + (dOption.checked? dOption.text:"") + (jOption.checked? jOption.text:"") + (hOption.checked? hOption.text:"")
        makeLink.callMakeLink(option, linkButton.text+linkField.text, targetButton.text)
        messagePopup.open()
    }

    MakeLink { id: makeLink }

    PressetPopup {
        id: messagePopup
        results: makeLink.results
        errors: makeLink.errors
    }

    FileDialog {
        id: linkFolderDialog
        selectFolder: true
        folder: shortcuts.documents

        onAccepted: {
            linkButton.text = (""+linkFolderDialog.folder).replace("file:///", "")+"/"
            linkFolderValid = true
        }
    }

    FileDialog {
        id: targetDialog
        selectFolder: needDirectory
        folder: shortcuts.documents

        onAccepted: {
            targetButton.text = (""+targetDialog.folder).replace("file:///", "")
            targetValid = true
            if (linkField.text === "") {
                var dirs = targetButton.text.split("/")
                linkField.text = dirs[dirs.length-1]
            }
        }
    }
}
