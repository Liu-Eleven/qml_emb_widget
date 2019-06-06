import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2

Window {
    title: "StackViewDemo";
    width: 480;
    height: 320;
    visible: true;

    StackView {
        id: stack;
        anchors.fill: parent;

        onBusyChanged: {
            console.log("busy - " + stack.busy);
        }

        Text {
            id: clue;
            text: "Click to create first page";
            font.pointSize: 14;
            font.bold: true;
            color: "blue";
            anchors.centerIn: parent;

            MouseArea {
                anchors.fill: parent;
                onClicked: if(stack.depth == 0){
                               clue.visible = false;
                               stack.push(page);
                           }
            }
        }

        delegate: StackViewDelegate {
            function transitionFinished(properties)
            {
                properties.exitItem.opacity = 1
            }

            pushTransition: StackViewTransition {

                PropertyAnimation {
                    target: enterItem;
                    property: "opacity";
                    from: 0;
                    to: 1;
                    duration: 200;
                }
                PropertyAnimation {
                    target: exitItem;
                    property: "opacity";
                    from: 1;
                    to: 0;
                    duration: 200;
                }
            }
        }
    }

    Component {
        id: page;

        Rectangle {
            color: Qt.rgba(stack.depth*0.1, stack.depth*0.2, stack.depth*0.3);
            property alias text: txt.text; //property alias

            Text {
                id: txt;
                anchors.centerIn: parent;
                font.pointSize: 24;
                font.bold: true;
                color: stack.depth <= 4 ? Qt.lighter(parent.color) : Qt.darker(parent.color);
                Component.onCompleted: {
                    text = "depth - " + stack.depth;
                }
            }

            Button {
                id: next;
                anchors.right: parent.right;
                anchors.bottom: parent.bottom;
                anchors.margins: 8;
                text: "Next";
                width: 70;
                height: 30;
                onClicked: {
                    if(stack.depth < 8) stack.push(page);
                }
            }

            Button {
                id: back;
                anchors.right: next.left;
                anchors.top: next.top;
                anchors.rightMargin: 8;
                text: "Back";
                width: 70;
                height: 30;
                onClicked: {
                    if(stack.depth > 0) stack.pop();
                }
            }

            Button {
                id: home;
                anchors.right: back.left;
                anchors.top: next.top;
                anchors.rightMargin: 8;
                text: "Home";
                width: 70;
                height: 30;
                onClicked: {
                    if(stack.depth > 0)stack.pop(stack.initialItem);
                }
            }

            Button {
                id: clear;
                anchors.right: home.left;
                anchors.top: next.top;
                anchors.rightMargin: 8;
                text: "Clear";
                width: 70;
                height: 30;
                onClicked: {
                    if(stack.depth > 0)stack.clear();
                    clue.visible = true;
                }
            }

            Button {
                id: popTo3;
                anchors.right: clear.left;
                anchors.top: next.top;
                anchors.rightMargin: 8;
                text: "PopTo3";
                width: 70;
                height: 30;
                onClicked: {
                    var resultItem = stack.find(
                                function(item){
                                    console.log(item.text);
                                    return item.Stack.index == 2;
                                }
                                );

                    if(resultItem !== null)stack.pop(resultItem);
                }
            }

            Component.onDestruction: console.log("destruction, current depth - " + stack.depth);

            Stack.onStatusChanged: console.log("status of item " + Stack.index + ": " + Stack.status);
        }
    }
}
