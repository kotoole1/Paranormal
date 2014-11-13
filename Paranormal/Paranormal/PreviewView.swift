import Cocoa

class PreviewView: CCGLView {
    override var acceptsFirstResponder: Bool { return true }

    required init?(coder:NSCoder) {
        super.init(coder:coder)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }

    override func keyDown(event: NSEvent) {
        println("view key down: \(event.keyCode)")
        if let scene: PreviewScene = CCDirector.sharedDirector().runningScene as? PreviewScene {
            scene.keyDown(event)
        }
    }

    override func mouseDown(event: NSEvent) {
        println("Mouse down")
    }
}