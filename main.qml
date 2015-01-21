import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
//import QtQuick.LocalStorage 2.0

import Qt.labs.settings 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    title: qsTr("RockEtc")

    // Menu bars don't work well in Windows Runtime
    property var possibleMenuBar: MenuBar {
        Menu {
            title: qsTr("App")
            MenuItem {
                text: qsTr("Reset statistics")
                onTriggered: resetStatistics()
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    statusBar: StatusBar {
        RowLayout {
            Label {
                id: status
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                text: "Player make your choice"
                verticalAlignment: Text.AlignVCenter
                //horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    toolBar: ToolBar {
        RowLayout {
            ToolButton {
                text: qsTr("Reset statistics")
                onClicked: resetStatistics()
            }
            ToolButton {
                text: qsTr("Exit")
                onClicked: Qt.quit();
            }
        }
    }

    property int winCount: 0;
    property int lossCount: 0;
    property int drawCount: 0;
    property int gamesPlayed: 0;

    Settings {
        property alias wins: root.winCount
        property alias losses: root.lossCount
        property alias draws: root.drawCount
        property alias games: root.gamesPlayed
    }

    function resetStatistics() {
        gamesPlayed = 0
        winCount = 0
        lossCount = 0
        drawCount = 0
    }

    function loadState() {
//        var db = LocalStorage.openDatabaseSync("RockEtc", "1.0", "Statistics of RockEtc", 1024,
//                                               function (newdb) {
//                                                   newdb.transaction(
//                                                               function(tx){
//                                                                   tx.executeSql('CREATE TABLE IF NOT EXISTS Statistics(winCount NUMBER, lossCount NUMBER, drawCount NUMBER, gamesPlayed NUMBER)');
//                                                               })
//                                                   newdb.changeVersion("", "1.0")
//                                               }
//                                               );
//        db.readTransaction(
//                    function (tx) {
//                        var rs = tx.executeSql("SELECT * FROM Statistics")
//                        if (rs.rows.length > 0) {
//                            winCount = rs.rows.item(0).winCount;
//                            lossCount = rs.rows.item(0).lossCount;
//                            drawCount = rs.rows.item(0).drawCount;
//                            gamesPlayed = rs.rows.item(0).gamesPlayed;
//                        }
//                    }
//                    )

        // We also disable the menu bar on winrt
        if (Qt.platform.os !== "winrt")
            menuBar = possibleMenuBar;
    }

    Component.onCompleted: loadState()

    Component.onDestruction: saveState()

    function saveState() {
//        var db = LocalStorage.openDatabaseSync("RockEtc", "1.0", "Statistics of RockEtc", 1024);
//        db.transaction(
//                    function(tx){
//                        //tx.executeSql('CREATE TABLE IF NOT EXISTS Statistics(winCount NUMBER, lossCount NUMBER, drawCount NUMBER, gamesPlayed NUMBER)');
//                        //var rs = tx.executeSql('SELECT COUNT(*) AS rowCount FROM Statistics')
//                        //if (rs.rows.item(0).rowCount > 0)
//                        //    tx.executeSql('UPDATE TABLE Statistics SET winCount=?, lossCount=?, drawCount=?, gamesPlayed=?', [winCount, lossCount, drawCount, gamesPlayed])
//                        //else
//                        tx.executeSql('INSERT OR REPLACE INTO Statistics VALUES(?, ?, ?, ?)', [winCount, lossCount, drawCount, gamesPlayed])
//                    }
//                    )
    }

    function chosen(number) {
        var you = number;
        var me = Math.floor(Math.random() * 3);
        var newstate;
        switch (you) {
        case 0:
            yourchoice.source = "qrc:/rock.svg"
            break;
        case 1:
            yourchoice.source = "qrc:/scissors.svg"
            break;
        case 2:
            yourchoice.source = "qrc:/paper.svg"
            break;
        }
        switch (me) {
        case 0:
            mychoice.source = "qrc:/rock.svg"
            break;
        case 1:
            mychoice.source = "qrc:/scissors.svg"
            break;
        case 2:
            mychoice.source = "qrc:/paper.svg"
            break;
        }
        if (you === me) {
            newstate = "Draw"
            drawCount++;
            switch (you) {
            case 0:
                status.text = "We both chose Rock. It's a draw."
                break;
            case 1:
                status.text = "We both chose Scissors. It's a draw."
                break;
            case 2:
                status.text = "We both chose Paper. It's a draw."
                break;
            }
        } else {
            switch (you) {
            case 0:
                if (me == 1) {
                    newstate = "Win"
                    winCount++;
                    status.text = "You chose Rock. I chose Scissors. You win."
                } else {
                    newstate = "Lose"
                    lossCount++;
                    status.text = "You chose Rock. I chose Paper. I win."
                }
                break;
            case 1:
                if (me == 2) {
                    newstate = "Win"
                    winCount++;
                    status.text = "You chose Scissors. I chose Paper. You win."
                } else {
                    newstate = "Lose"
                    lossCount++;
                    status.text = "You chose Scissors. I chose Rock. I win."
                }
                break;
            case 2:
                if (me == 0) {
                    newstate = "Win"
                    winCount++;
                    status.text = "You chose Paper. I chose Rock. You win."
                } else {
                    newstate = "Lose"
                    lossCount++;
                    status.text = "You chose Paper. I chose Scissors. I win."
                }
                break;
            }
        }
        //result.open();
        gamesPlayed++;
        return newstate;
    }

    Timer {
        id: reset
        interval: 3000
        running: false
        repeat: false
        onTriggered: myStates.state = ''
    }

    /* QueryDialog {
            id: result
            titleText: qsTr("Result")
            acceptButtonText: qsTr("Play again")
            onAccepted: myStates.state = ''
        } */

    Row {
        id: row1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: stats.bottom
        Column {
            id: column1
            width: myStates.state === "" ? parent.width / 4 : 0
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //opacity: myStates.state == "" ? 1.0 : 0.0
            Label {
                id: playerlabel
                text: "Player"
                horizontalAlignment: Text.AlignLeft
            }

            Behavior on width {
                NumberAnimation { duration: 500 }
            }

            Button {
                id: yourrock
                //radius: 8
                //color: "yellow"
                anchors.margins: 4
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height / 3 - playerlabel.height
                opacity: 1.0

                iconSource: "qrc:/rock.svg"
                text: "Rock"
                onClicked: if (myStates.state === "") myStates.state = chosen(0)

                onHoveredChanged: {
                    if (hovered) {
                        yourchoice.source = "qrc:/rock.svg"
                        yourchoice.opacity = 1
                    } else {
                        yourchoice.opacity = 0
                    }
                }
            }

            Button {
                id: yourscissors
                //radius: 8
                //color: "yellow"
                anchors.margins: 4
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height / 3 - playerlabel.height
                opacity: 1.0

                iconSource: "qrc:/scissors.svg"
                text: "Scissors"
                onClicked: if (myStates.state === "") myStates.state = chosen(1)

                onHoveredChanged: {
                    if (hovered) {
                        yourchoice.source = "qrc:/scissors.svg"
                        yourchoice.opacity = 1
                    } else {
                        yourchoice.opacity = 0
                    }
                }
            }

            Button {
                id: yourpaper
                //radius: 8
                //color: "yellow"
                anchors.margins: 4
                anchors.right: parent.right
                anchors.left: parent.left
                height: parent.height / 3 - playerlabel.height
                opacity: 1.0

                iconSource: "qrc:/paper.svg"
                text: "Paper"
                onClicked: if (myStates.state === "") myStates.state = chosen(2)

                onHoveredChanged: {
                    if (hovered) {
                        yourchoice.source = "qrc:/paper.svg"
                        yourchoice.opacity = 1
                    } else {
                        yourchoice.opacity = 0
                    }
                }
            }
        }
        /* Column {
                width: parent.width / 2
                height: parent.height

                Row { */
        Rectangle {
            id: yourrect
            color: "#ffffff"
            width: parent.width / (myStates.state === "" ? 4 : 2)
            height: parent.height

            Behavior on width {
                NumberAnimation { duration: 500 }
            }

            Image {
                id: yourchoice
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                opacity: 0.0
                Behavior on opacity {
                    NumberAnimation { duration: 1000 }
                }
            }
        }
        Rectangle {
            id: myrect
            color: "#ffffff"
            width: parent.width / (myStates.state === "" ? 4 : 2)
            height: parent.height

            Behavior on width {
                NumberAnimation { duration: 500 }
            }

            Image {
                id: mychoice
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                opacity: 0.0
                mirror: true
                Behavior on opacity {
                    NumberAnimation { duration: 1000 }
                }
            }
        }
        /* }
            } */
        Column {
            id: column2
            width: myStates.state === "" ? parent.width / 4 : 0
            //opacity: myStates.state == "" ? 0.5 : 0.0
            anchors.bottom: parent.bottom
            anchors.top: parent.top

            Behavior on width {
                NumberAnimation { duration: 500 }
            }

            Label {
                id: computerlabel
                text: "Computer"
                horizontalAlignment: Text.AlignRight
                anchors.left: parent.left
                anchors.right: parent.right
                opacity: myStates.state === "" ? 1.0 : 0.0
            }

            Image {
                id: myrock
                height: parent.height / 3 - computerlabel.height
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.left: parent.left
                source: "qrc:/rock.svg"
                mirror: true
                opacity: myStates.state === "" ? 1.0 : 0.0
            }
            Image {
                id: myscissors
                height: parent.height / 3 - computerlabel.height
                anchors.right: parent.right
                anchors.left: parent.left
                fillMode: Image.PreserveAspectFit
                source: "qrc:/scissors.svg"
                mirror: true
                opacity: myStates.state === "" ? 1.0 : 0.0
            }
            Image {
                id: mypaper
                height: parent.height / 3 - computerlabel.height
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.left: parent.left
                source: "qrc:/paper.svg"
                mirror: true
                opacity: myStates.state === "" ? 1.0 : 0.0
            }
        }
    }

    Row {
        id: stats
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        Rectangle {
            id: winsbox
            color: "#66ff66"
            width: gamesPlayed == 0 ? parent.width / 3 : parent.width * (winCount / gamesPlayed)
            height: Math.max(winstext.height, Math.max(drawstext.height, lossestext.height))
            Label {
                id: winstext
                text: winCount + " win" + (winCount != 1 ? "s" : "")
                horizontalAlignment: Text.AlignLeft
                anchors.left: parent.left
                anchors.right: parent.right
                visible: gamesPlayed == 0 || winCount > 0
            }
            Behavior on width {
                NumberAnimation { duration: 1000 }
            }
        }
        Rectangle {
            id: drawsbox
            color: "#6666ff"
            width: gamesPlayed == 0 ? parent.width / 3 : parent.width * (drawCount / gamesPlayed)
            height: Math.max(drawstext.height, Math.max(winstext.height, lossestext.height))
            Label {
                id: drawstext
                text: drawCount + " draw" + (drawCount != 1 ? "s" : "")
                horizontalAlignment: Text.AlignHCenter
                anchors.left: parent.left
                anchors.right: parent.right
                visible: gamesPlayed == 0 || drawCount > 0
            }
            Behavior on width {
                NumberAnimation { duration: 1000 }
            }
        }
        Rectangle {
            id: lossesbox
            color: "#ff6666"
            width: gamesPlayed == 0 ? parent.width / 3 : parent.width * (lossCount / gamesPlayed)
            height: Math.max(lossestext.height, Math.max(winstext.height, drawstext.height))
            Label {
                id: lossestext
                text: lossCount + " loss" + (lossCount != 1 ? "es" : "")
                horizontalAlignment: Text.AlignRight
                anchors.left: parent.left
                anchors.right: parent.right
                visible: gamesPlayed == 0 || lossCount > 0
            }
            Behavior on width {
                NumberAnimation { duration: 1000 }
            }
        }
    }

    StateGroup {
        id: myStates

        states: [
            State {
                name: "YouRock"

                PropertyChanges {
                    target: yourchoice
                    source: "qrc:/rock.svg"
                }

                StateChangeScript {
                    script: chosen(0);
                }
            },

            State {
                name: "YouScissors"

                PropertyChanges {
                    target: yourchoice
                    source: "qrc:/scissors.svg"
                }

                StateChangeScript {
                    script: chosen(1);
                }
            },

            State {
                name: "YouPaper"

                PropertyChanges {
                    target: yourchoice
                    source: "qrc:/paper.svg"
                }

                StateChangeScript {
                    script: chosen(2);
                }
            },

            State {
                name: "Win"

                PropertyChanges {
                    target: yourrect
                    color: "#66ff66"
                }

                PropertyChanges {
                    target: myrect
                    color: "#ff6666"
                }

                PropertyChanges {
                    target: status
                    text: "You win!"
                }

                PropertyChanges {
                    target: mychoice
                    opacity: 1.0
                }

                PropertyChanges {
                    target: yourchoice
                    opacity: 1.0
                }

                PropertyChanges {
                    target: yourrock
                    opacity: 0.0
                }

                PropertyChanges {
                    target: yourscissors
                    opacity: 0.0
                }

                PropertyChanges {
                    target: yourpaper
                    opacity: 0.0
                }

                StateChangeScript {
                    script: reset.start()
                }
            },

            State {
                name: "Lose"

                PropertyChanges {
                    target: yourrect
                    color: "#ff6666"
                }

                PropertyChanges {
                    target: myrect
                    color: "#66ff66"
                }

                PropertyChanges {
                    target: status
                    text: "I win!"
                }

                PropertyChanges {
                    target: mychoice
                    opacity: 1.0
                }

                PropertyChanges {
                    target: yourchoice
                    opacity: 1.0
                }

                PropertyChanges {
                    target: yourrock
                    opacity: 0.0
                }

                PropertyChanges {
                    target: yourscissors
                    opacity: 0.0
                }

                PropertyChanges {
                    target: yourpaper
                    opacity: 0.0
                }

                StateChangeScript {
                    script: reset.start()
                }
            },

            State {
                name: "Draw"

                PropertyChanges {
                    target: myrect
                    color: "#6666ff"
                }

                PropertyChanges {
                    target: yourrect
                    color: "#6666ff"
                }

                PropertyChanges {
                    target: status
                    text: "It's a draw."
                }

                PropertyChanges {
                    target: mychoice
                    opacity: 1.0
                }

                PropertyChanges {
                    target: yourchoice
                    opacity: 1.0
                }

                PropertyChanges {
                    target: yourrock
                    opacity: 0.0
                }

                PropertyChanges {
                    target: yourscissors
                    opacity: 0.0
                }

                PropertyChanges {
                    target: yourpaper
                    opacity: 0.0
                }

                StateChangeScript {
                    script: reset.start()
                }
            }
        ]

        transitions: [
            Transition {
                to: "*"
                ColorAnimation {
                    target: yourrect
                    duration: 1000
                }
                ColorAnimation {
                    target: myrect
                    duration: 1000
                }

            }

        ]
    }


    /* Column {
            id: column1
            anchors.fill: parent

            Label {
                id: label
                text: qsTr("Make your choice")
                horizontalAlignment: Text.AlignHCenter
    }
            ButtonColumn {
                id: buttoncolumn1
                anchors.right: parent.right
                anchors.left: parent.left

                Button {
                    id: button1
                    text: qsTr("Rock")
                    onClicked: chosen(0)
                }

                Button {
                    id: button2
                    text: qsTr("Scissors")
                    onClicked: chosen(1)
                }

                Button {
                    id: button3
                    text: qsTr("Paper")
                    onClicked: chosen(2)
                }
            }
        } */
}
