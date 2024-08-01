/*
    SPDX-FileCopyrightText: 2014 Martin Gräßlin <mgraesslin@kde.org>
    SPDX-FileCopyrightText: 2014 Sebastian Kügler <sebas@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts 1.1
import Qt5Compat.GraphicalEffects

import org.kde.lingmo.plasmoid 2.0
import org.kde.lingmo.components 3.0 as LingmoComponents
import org.kde.lingmoui 2.20 as LingmoUI

LingmoComponents.ItemDelegate {
    id: menuItem

    property bool supportsBarcodes
    property int maximumNumberOfPreviews: Math.floor(width / (LingmoUI.Units.gridUnit * 4 + LingmoUI.Units.smallSpacing))
    readonly property real gradientThreshold: (label.width - toolButtonsLoader.width) / label.width
    // Consider tall to be > about 1.5x the default height for purposes of top-aligning
    // the buttons to preserve Fitts' Law when deleting multiple items in a row,
    // or else the top-alignment doesn't look deliberate enough and people will think
    // it's a bug
    readonly property bool isTall: height > Math.round(LingmoUI.Units.gridUnit * 2.5)

    signal itemSelected(string uuid)
    signal remove(string uuid)
    signal edit(string uuid)
    signal barcode(string text)
    signal triggerAction(string uuid)

    // the 1.6 comes from ToolButton's default height
    height: Math.max(label.height, Math.round(LingmoUI.Units.gridUnit * 1.6)) + 2 * LingmoUI.Units.smallSpacing

    enabled: true

    onClicked: {
        menuItem.itemSelected(UuidRole);
        if (main.hideOnWindowDeactivate) {
            main.expanded = false;
        } else {
            forceActiveFocus(); // Or activeFocus will always be false after clicking buttons in the heading
        }
    }

    Keys.onEnterPressed: event => Keys.returnPressed(event)
    Keys.onReturnPressed: menuItem.clicked()
    Keys.onDeletePressed: {
        remove(UuidRole);
    }

    ListView.onIsCurrentItemChanged: {
        if (ListView.isCurrentItem) {
            labelMask.source = label // calculate on demand
        }
    }

    // this stuff here is used so we can fade out the text behind the tool buttons
    Item {
        id: labelMaskSource
        anchors.fill: label
        visible: false

        Rectangle {
            anchors.centerIn: parent
            rotation: LayoutMirroring.enabled ? 90 : -90 // you cannot even rotate gradients without Qt5Compat.GraphicalEffects
            width: parent.height
            height: parent.width

            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: gradientThreshold - 0.25; color: "white"}
                GradientStop { position: gradientThreshold; color: "transparent"}
                GradientStop { position: 1; color: "transparent"}
            }
        }
    }

    OpacityMask {
        id: labelMask
        anchors.fill: label
        cached: true
        maskSource: labelMaskSource
        visible: !!source && menuItem.ListView.isCurrentItem

        TapHandler {
            enabled: !toolButtonsLoader.item?.hovered // https://bugreports.qt.io/browse/QTBUG-108821
            onTapped: {
                menuItem.clicked() // https://bugreports.qt.io/browse/QTBUG-63395
            }
        }

        DragHandler {
            id: dragHandler
            enabled: !toolButtonsLoader.item?.hovered
        }
    }

    Item {
        id: label
        height: childrenRect.height
        visible: !menuItem.ListView.isCurrentItem
        anchors {
            left: parent.left
            leftMargin: Math.ceil(LingmoUI.Units.gridUnit / 2) - listMargins.left
            right: parent.right
            rightMargin: Math.ceil(LingmoUI.Units.gridUnit / 2)  - listMargins.right
            verticalCenter: parent.verticalCenter
        }

        Loader {
            width: parent.width
            source: ["Text", "Image", "Url"][TypeRole] + "ItemDelegate.qml"
        }
    }

    Loader {
        id: toolButtonsLoader

        anchors {
            right: label.right
            verticalCenter: parent.verticalCenter
            // This is here because you can't assign to it in AnchorChanges below
            topMargin: Math.ceil(LingmoUI.Units.gridUnit / 2) - listMargins.top
        }
        source: "DelegateToolButtons.qml"
        active: menuItem.ListView.isCurrentItem

        // It's not recommended to change anchors via conditional bindings, use AnchorChanges instead.
        // See https://doc.qt.io/qt-5/qtquick-positioning-anchors.html#changing-anchors
        states: [
            State {
                when: menuItem.isTall

                AnchorChanges {
                    target: toolButtonsLoader
                    anchors.top: parent.top
                    anchors.verticalCenter: undefined
                }
            }
        ]

        onActiveChanged: {
            if (active) {
                menuItem.KeyNavigation.tab =  toolButtonsLoader.item.children[0]
                menuItem.KeyNavigation.right = toolButtonsLoader.item.children[0]
                // break binding, once it was loaded, never unload
                active = true;
            }
        }
    }
}