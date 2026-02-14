import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: window
    width: 360
    height: 640
    visible: true
    title: "Price Calculator"
    background: Rectangle {
            color: "#1e1e1e"
        }

    color: "#1e1e1e"

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            // Grab values from the UI
            let r = parseFloat(rmbRate.textValue) || 0
            let p = parseFloat(prodPrice.textValue) || 0
            let w = parseFloat(prodWeight.textValue) || 0
            let prof = profitInput.textValue || "0"

            // Call the C++ function!
            let total = CalcEngine.calculateTotal(r, p, w, prof)

            // Update the UI
            totalPriceOutput.text = "৳ " + total.toFixed(2)

            // Round to nearest 10
            let rounded = Math.ceil(total / 10) * 10
            roundPriceOutput.text = "৳ " + rounded

            //profit calculate from the roundPriceOutput
            let profitMoney=0;
            profitMoney=rounded-((r*p)+w)
            profitMoneyText.text = " ৳ " + profitMoney.toFixed(2)

            // Update Barcode
            let dateStr = new Date().toLocaleDateString('en-GB').replace(/\//g, '')
            barcodeText.text = "LNR-" + dateStr + "000" + rounded
        }
    }

    Rectangle {
        width: parent.width
        height: 70
        color: "#0b0b0b"

        Text {
            text: "Lunara"
            color: "white"
            font.pixelSize: 24
            font.bold: true

            anchors.centerIn: parent
        }
    }
    Rectangle {
        width: 80
        height: 32
        color: "#737373"
        radius: 6

        anchors.top: parent.top
        anchors.topMargin: 80     // below the title bar
        anchors.right: parent.right
        anchors.rightMargin: 12

        Text {
            text: "History"
            color: "white"
            font.pixelSize: 14

            anchors.centerIn: parent
        }
    }

    Column {
        spacing: 16
        anchors.top: parent.top
        anchors.topMargin: 130
        anchors.left: parent.left
        anchors.leftMargin: 12

        // --- 1. Define the Template (The "Component") ---
        // This tells Qt: "This is what a Lunara Input looks like"
        // --- 1. Define the Template ---
                component LunaraInput : Row {
                    spacing: 8
                    property string labelText: ""
                    property string placeholder: ""
                    property string initialValue: ""
                    property bool showPercentBtn: false // This controls if the % button appears
                    property alias textValue: inputField.text

                    // Label Box
                    Rectangle {
                        width: 100; height: 45; radius: 6
                        color: "#737373"
                        Text {
                            text: labelText
                            color: "#2ECC71"
                            font.pixelSize: 14
                            anchors.centerIn: parent
                        }
                    }

                    // Input Box (Shrinks automatically if % button is visible)
                    Rectangle {
                        width: showPercentBtn ? 152 : 200; height: 45; radius: 6
                        color: inputField.activeFocus ? Qt.rgba(1, 1, 1, 0.4) : Qt.rgba(1, 1, 1, 0.15)
                        border.color: inputField.activeFocus ? "#2ECC71" : "transparent"
                        border.width: 1

                        TextField {
                            id: inputField
                            anchors.fill: parent
                            anchors.margins: 4
                            text: initialValue
                            placeholderText: placeholder
                            color: "#2ECC71"
                            font.pixelSize: 14
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            background: null
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }

                    // Percentage Button (Only shows for Profit field)
                    Rectangle {
                        visible: showPercentBtn
                        width: 40; height: 45; radius: 6
                        color: "#2ECC71"
                        Text {
                            text: "%"
                            color: "white"
                            font.bold: true
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!inputField.text.includes("%")){
                                    inputField.text += "%"
                                } else {
                                    inputField.text = inputField.text.replace("%","")
                                }
                            }
                        }
                    }
                }

        // --- 2. Use the Component 4 Times ---
        LunaraInput { id: rmbRate; labelText: "RMB Rate"; placeholder: "Enter rate" }
        LunaraInput { id: prodPrice; labelText: "Price";    placeholder: "Enter price" }
        LunaraInput { id: prodWeight; labelText: "Weight";   placeholder: "Enter weight" }
        LunaraInput { id: profitInput; labelText: "Profit";  initialValue: "30%"; showPercentBtn: true }

    }
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 370 // Adjust this so it sits below your inputs
        spacing: 15
        width: parent.width

        // --- Total Price Section ---
        Text {
            text: "Total Price"
            color: "white"
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 250; height: 45; radius: 8
            color: Qt.rgba(1, 1, 1, 0.1)
            border.color: "#FF69B4"
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: totalPriceOutput
                text: "৳ 0.00"
                color: "white"
                font.pixelSize: 20; font.bold: true
                anchors.centerIn: parent
            }
        }

        // --- Round Price Section ---
        Text {
            text: "Round Price"
            color: "white"
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: 250; height: 45; radius: 8
            color: Qt.rgba(1, 1, 1, 0.1)
            border.color: "#FF69B4"
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: roundPriceOutput
                text: "৳ 0"
                color: "#FF69B4" // Pink to make it stand out
                font.pixelSize: 22; font.bold: true
                anchors.centerIn: parent
            }
        }

        //---for profit---
        Text {
            text: "Profit"
            color: "white"
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle{
            width: 250; height: 45; radius: 8
            color: Qt.rgba(1, 1, 1, 0.1)
            border.color: "#FF69B4"
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                id:profitMoneyText
                text:"৳ 0"
                color: "#F28C28" // Orange to make it stand out
                font.pixelSize: 22; font.bold: true
                anchors.centerIn: parent
            }
        }

        // --- Barcode Section ---
        Rectangle {
            width: 300; height: 80; radius: 10
            color: "#1a1a1a"
            border.color: "#333"
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                anchors.centerIn: parent
                spacing: 5

                Text {
                    id: barcodeText
                    text: "LNR-" + new Date().toLocaleDateString('en-GB').replace(/\//g, '') + "000" + "0"
                    color: "lightgray"
                    font.family: "Courier" // Looks like code
                    font.pixelSize: 14
                }

                Button {
                    text: "Copy Barcode"
                    onClicked: {
                        // This copies the text to your phone/PC clipboard
                        barcodeText.selectAll()
                        barcodeText.copy()
                        console.log("Barcode Copied: " + barcodeText.text)
                    }

                    // Styling the copy button
                    contentItem: Text {
                        text: parent.text
                        color: "white"; font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                    }
                    background: Rectangle {
                        implicitWidth: 100; implicitHeight: 30
                        color: "#444"; radius: 15
                    }
                }
            }
        }
    }

}
