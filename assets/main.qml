import bb.cascades 1.0
import "../tart.js" as Tart

NavigationPane {
    id: root

    signal updateLabelText(string text)

    property variant settingsPage;
    property variant helpPage;
    property variant dynamicSheet;
    property bool destroyIt: false;

    Menu.definition: AppMenuDefinition {
        id: appMenu
    }

    MainPage { id: mainPage }

    attachedObjects: [
        ComponentDefinition {
            id: settingsDef;
            source: "asset:///SettingsPage.qml"
        },
        ComponentDefinition {
            id: helpDef;
            source: "asset:///HelpPage.qml"
        },
        ComponentDefinition {
            id: dynSheet
            source: "asset:///DynSheet.qml"
        }
    ]

    onCreationCompleted: {
        Tart.init(_tart, Application);

        Tart.register(root);

        Tart.send('uiReady');

        mainPage.openDynamicSheet.connect(handleOpenNewSheet);
        mainPage.changeDestroy.connect(handleChangeDestroy);
        appMenu.triggerSettingsPage.connect(handleTriggerSettingsPage);
        appMenu.triggerHelpPage.connect(handleTriggerHelpPage);
    }

    onPopTransitionEnded: {
        if (page == settingsPage) {
            Application.menuEnabled = true;
            settingsPage = undefined;
        } else if (page == helpPage) {
            Application.menuEnabled = true;
            helpPage = undefined;
        }
        page.destroy()
    }

    function onMsgFromPython(data) {
        updateLabelText(data.text);
    }

    function handleTriggerSettingsPage() {
        settingsPage = settingsDef.createObject();
        push(settingsPage);
    }

    function handleTriggerHelpPage() {
        helpPage = helpDef.createObject();
        push(helpPage);
    }

    function handleOpenNewSheet() {
        dynamicSheet = dynSheet.createObject();
        updateLabelText.connect(dynamicSheet.updateToastText);
        dynamicSheet.clicked.connect(handleSheetClicked);
        dynamicSheet.closed.connect(handleSheetClosed);
        dynamicSheet.open();
    }

    function handleSheetClicked() {
        Tart.send('sendZeeMsg');
    }

    function handleSheetClosed() {
        updateLabelText.disconnect(dynamicSheet.updateToastText);
        dynamicSheet.clicked.disconnect(handleSheetClicked);
        dynamicSheet.closed.disconnect(handleSheetClosed);
        if (destroyIt) {
            dynamicSheet.destroy(); // This is the culprit line.
        }
    }

    function handleChangeDestroy(checked) {
        console.log("handleChangeDestroy", checked);
        destroyIt = checked;
    }
}
