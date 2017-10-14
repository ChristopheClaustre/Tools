import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import MakeLink 1.0

ApplicationWindow {
    visible: true
    width: 570
    height: 360
    minimumWidth: 550
    minimumHeight: 360
    maximumWidth: minimumWidth
    maximumHeight: minimumHeight
    title: qsTr("Make Junction")

    flags: Qt.Window | Qt.WindowTitleHint

    property bool linkValid: linkField.acceptableInput
    property bool linkFolderValid: false
    property bool targetValid: false
    property bool valid: linkValid && linkFolderValid && targetValid

    Item {
        anchors.fill: parent
        anchors.margins: 15

        focus: true

        ColumnLayout {
            anchors.fill: parent

            GroupBox {
                //Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                ColumnLayout {
                    anchors.fill: parent
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                    RowLayout {
                        Layout.fillWidth: true
                        Button {
                            id: linkButton
                            Layout.fillWidth: true
                            text: "Link's folder"
                            font.capitalization: Font.AllUppercase

                            ToolTip {
                                visible: linkButton.hovered
                                delay: 500
                                contentItem: Label {
                                    text: linkButton.text
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                }
                            }

                            contentItem: Label {
                                text: linkButton.text
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideMiddle
                            }

                            onClicked: linkFolderDialog.open()
                        }
                        TextField {
                            id: linkField
                            Layout.minimumWidth: 0.25 * parent.width
                            placeholderText: "Link ..."
                            validator: RegExpValidator { id:validator; regExp: /[A-Za-z0-9_-#éàèù|\[\] ]*/ }

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
                        text: "Target"
                        font.capitalization: Font.AllUppercase

                        ToolTip {
                            visible: targetButton.hovered
                            delay: 500
                            contentItem: Label {
                                text: targetButton.text
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }
                        }

                        contentItem: Label {
                            text: targetButton.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideMiddle
                        }

                        onClicked: targetDialog.open()
                    }
                }
            }

            GroupBox {
                title: "Informations"
                Layout.fillHeight: true
                Layout.fillWidth: true

                font.pixelSize: 18
                font.bold: true
                font.capitalization: Font.AllUppercase

                Label {
                    text: (makeLink.hasErrors)? makeLink.errors : makeLink.results
                    anchors.fill: parent

                    font.pixelSize: 16
                    font.bold: false
                    font.capitalization: Font.MixedCase
                    wrapMode: TextEdit.Wrap

                    color: (makeLink.hasErrors)? Qt.lighter("red", 1.2) : Material.foreground
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter

                Button {
                    id: cancelButton
                    text: "Cancel"
                    Layout.minimumWidth: 150

                    onClicked: Qt.quit()
                }

                Button {
                    id: goButton
                    text: "Link !!"
                    Layout.minimumWidth: 150
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
        makeLink.callMakeLink(linkButton.text+linkField.text, targetButton.text)
    }

    MakeLink {
        id: makeLink
        property bool hasErrors: makeLink.errors !== ""
    }

    FileDialog {
        id: linkFolderDialog
        selectFolder: true
        folder: shortcuts.documents

        onAccepted: {
            linkButton.text = (""+linkFolderDialog.fileUrl).replace("file:///", "")+"/"
            linkFolderValid = true
        }
    }

    FileDialog {
        id: targetDialog
        selectFolder: true
        folder: shortcuts.documents

        onAccepted: {
            targetButton.text = (""+targetDialog.fileUrl).replace("file:///", "")
            targetValid = true
            if (linkField.text === "") {
                var dirs = targetButton.text.split("/")
                linkField.text = dirs[dirs.length-1]
            }
        }
    }
}
