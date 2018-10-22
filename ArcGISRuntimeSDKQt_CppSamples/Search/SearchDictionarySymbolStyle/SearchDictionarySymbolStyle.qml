// [WriteFile Name=SearchDictionarySymbolStyle, Category=Search]
// [Legal]
// Copyright 2016 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// [Legal]

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import Esri.Samples 1.0
import Esri.ArcGISExtras 1.1

SearchDictionarySymbolStyleSample {
    id: searchDictionarySymbolStyleSample
    width: 800
    height: 600

    property real scaleFactor: 1
    property double fontSize: 16 * scaleFactor
    property var repeaterModel: ["Names", "Tags", "Symbol Classes", "Categories", "Keys"]
    property var hintsModel: ["Fire", "Sustainment Points", "3", "Control Measure", "25212300_6"]
    property var searchParamList: [[],[],[],[],[]]

    property url dataPath: System.userHomePath + "/ArcGIS/Runtime/Data/styles/mil2525d.stylx"

    ColumnLayout {
        id: topRectangle
        anchors {
            fill: parent
            margins: 9 * scaleFactor
        }

        Column {
            visible: !hideSearch.checked
            enabled: visible

            id: fieldColumn
            anchors {
                left: parent.left
                right: parent.right
                margins: 8 * scaleFactor
            }

            Repeater {
                id: repeater
                model: repeaterModel

                Rectangle {
                    width: parent.width
                    height: childrenRect.height
                    color: "lightgrey"
                    border.color: "darkgrey"
                    radius: 2 * scaleFactor
                    clip: true

                    GridLayout {
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: 3 * scaleFactor
                        }
                        columns: 3
                        rowSpacing: 0
                        Text {
                            text: repeaterModel[index]
                            font.bold: true
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            wrapMode: Text.WordWrap
                        }

                        TextField {
                            id: categoryEntry
                            Layout.fillWidth: true
                            placeholderText: repeaterModel[index] +" (e.g. "+ hintsModel[index] +")"
                            validator: RegExpValidator{ regExp: /^\s*[\da-zA-Z_][\da-zA-Z\s_]*$/ }
                            onAccepted: addCategoryButton.mouseArea.clicked();
                        }

                        Rectangle {
                            id: addCategoryButton
                            height: childrenRect.height
                            width: height
                            color: "transparent"
                            Image {
                                source: parent.enabled ? "qrc:/Samples/Search/SearchDictionarySymbolStyle/ic_menu_addencircled_light.png"
                                                       : "qrc:/Samples/Search/SearchDictionarySymbolStyle/ic_menu_addencircled_dark.png"
                            }
                            enabled: categoryEntry.text.length > 0

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                onClicked: {
                                    if (categoryEntry.text.length === 0)
                                        return;

                                    var tmp = searchParamList;
                                    tmp[index].push(categoryEntry.text);

                                    searchParamList = tmp;
                                    categoryEntry.text = "";
                                }
                            }
                        }

                        Label {
                            id: categoryList
                            Layout.fillWidth: true
                            Layout.column: 1
                            Layout.row: 1
                            text: searchParamList[index].length > 0 ? searchParamList[index].join() : ""
                        }

                        Rectangle {
                            height: childrenRect.height
                            width: height
                            color: "transparent"
                            Image {
                                source: parent.enabled ? "qrc:/Samples/Search/SearchDictionarySymbolStyle/ic_menu_closeclear_light.png" :
                                                         "qrc:/Samples/Search/SearchDictionarySymbolStyle/ic_menu_closeclear_dark.png"
                            }
                            enabled: categoryList.text.length > 0

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    categoryEntry.text = "";
                                    var tmp = searchParamList;
                                    tmp[index] = [];

                                    searchParamList = tmp;
                                }
                            }
                        }
                    }
                }
            }
        }

        Row {
            spacing: 10 * scaleFactor

            Button {
                id: seachBtn
                width: childrenRect.width
                Image {
                    id: searchImage
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        margins: 3 * scaleFactor
                    }
                    source: "qrc:/Samples/Search/SearchDictionarySymbolStyle/ic_menu_find_light.png"
                }

                Text {
                    anchors {
                        left: searchImage.right
                        verticalCenter: parent.verticalCenter
                        margins: 3 * scaleFactor
                    }
                    text: searchParamList[0].length === 0 &&
                          searchParamList[1].length === 0 &&
                          searchParamList[2].length === 0 &&
                          searchParamList[3].length === 0 &&
                          searchParamList[4].length === 0 ?
                              "List All" : "Search"
                }

                onClicked: {
                    //start the search
                    resultView.visible = false;

                    searchDictionarySymbolStyleSample.search(searchParamList[SearchDictionarySymbolStyleSample.FieldNames],
                                                             searchParamList[SearchDictionarySymbolStyleSample.FieldTags],
                                                             searchParamList[SearchDictionarySymbolStyleSample.FieldClasses],
                                                             searchParamList[SearchDictionarySymbolStyleSample.FieldCategories],
                                                             searchParamList[SearchDictionarySymbolStyleSample.FieldKeys]);
                }
            }

            Button {
                text: "Clear"
                enabled: resultView.count > 0
                onClicked: {
                    //Set the results visibility to false
                    resultView.visible = false;
                    //Reset the search parameters
                    searchParamList = [[],[],[],[],[]];
                }
            }

            Button {
                id: hideSearch
                checked: false
                checkable: true
                Image {
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                        margins: 3 * scaleFactor
                    }
                    source: parent.checked ? "qrc:/Samples/Search/SearchDictionarySymbolStyle/ic_menu_collapsed_light.png" :
                                             "qrc:/Samples/Search/SearchDictionarySymbolStyle/ic_menu_expanded_light.png"
                }
            }
        }

        Text {
            id: resultText
            visible: resultView.visible
            text: "Result(s) found: " + resultView.count
            font.pixelSize: fontSize
        }

        Rectangle {
            id: bottomRectangle
            Layout.fillHeight: true
            anchors {
                left: parent.left
                right: parent.right
            }

            //Listview of results returned from Dictionary
            ListView {
                id: resultView
                anchors {
                    fill: parent
                    margins: 10 * scaleFactor
                }
                spacing: 20 * scaleFactor

                clip: true
                model: searchResultsListModel

                delegate: Component {
                    Row {
                        anchors {
                            margins: 20 * scaleFactor
                        }
                        width: resultView.width
                        spacing: 10 * scaleFactor

                        Image {
                            source: symbolUrl
                        }

                        Column {
                            width: parent.width
                            spacing: 10 * scaleFactor

                            Text {
                                id: nameText
                                text: "<b>Name:</b> " + name
                                font.pixelSize: fontSize
                                width: parent.width
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }

                            Text {
                                text: "<b>Tags:</b> " + tags
                                font.pixelSize: fontSize
                                width: nameText.width
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }

                            Text {
                                text: "<b>SymbolClass:</b> " + symbolClass
                                font.pixelSize: fontSize
                                width: nameText.width
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }

                            Text {
                                text: "<b>Category:</b> " + category
                                font.pixelSize: fontSize
                                width: nameText.width
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }

                            Text {
                                text: "<b>Key:</b> " + key
                                font.pixelSize: fontSize
                                width: nameText.width
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            }
                        }
                    }
                }
            }
        }
    }

    //Search completed
    onSearchCompleted: {
        seachBtn.enabled = true;
        resultView.visible = true;

        //Update the number of results retuned
        resultText.text = "Result(s) found: " + count
    }
}
