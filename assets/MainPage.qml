import bb.cascades 1.0

Page {
    signal openDynamicSheet();
    signal changeDestroy(bool checked);

    Container {
        layout: DockLayout {}

        Container {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            layout: StackLayout{ 
                orientation: LayoutOrientation.TopToBottom
            }
            Button {
                id: button
                text: "Click to open sheet."

                onClicked: {
                    openDynamicSheet();
                }
            }

            CheckBox {
                text: "Destroy?"

                onCheckedChanged: {
                    console.log("checkbox", checked);
                    changeDestroy(checked);
                }
            }
        }
    }
}
