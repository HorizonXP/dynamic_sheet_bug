
import tart

class App(tart.Application):
    def onUiReady(self):
        pass

    def onSendZeeMsg(self):
        tart.send('msgFromPython', text='BlackBerry-Py Bootstrap makes this look easy.')
