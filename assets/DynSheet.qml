import bb.cascades 1.0
import bb.system 1.0

Sheet {
    id: sheet
    signal updateToastText(string text);
    signal clicked();

    onUpdateToastText: {
        toast.body = text;
        toast.show();
    }

    Page {
        titleBar: TitleBar {
            dismissAction: ActionItem {
                title: "Cancel"

                onTriggered: {
                    sheet.close();
                }
            }
        }

        Container {
            layout: DockLayout {}

            attachedObjects: [
                SystemToast {
                    id: toast
                }
            ]
            
            Button {
                text: "Send Zee Message!"

                onClicked: {
                    sheet.clicked();
                }
            }
        }
    }
}
