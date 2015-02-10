import Foundation
import GPUImage


private let _ThreadUtilsShared = ThreadUtils()

public class ThreadUtils : NSObject {
    var gpuImageThread : NSThread?
    var editClosures : [() -> Void] = []
    var updateClosures : [() -> Void] = []
    var lock : NSLock = NSLock()

    override init() {
        super.init()
        gpuImageThread = NSThread(target: self,
            selector: NSSelectorFromString("threadMain"), object: nil)
        gpuImageThread?.start()
    }

    dynamic func threadMain() {
        while(true) { // TODO turn this off
            while (editClosures.count > 0) {
                lock.lock()
                let closure = editClosures.removeAtIndex(0)
                lock.unlock()
                closure()
            }

            while (updateClosures.count > 0) {
                lock.lock()
                let closure = updateClosures.removeLast()
                updateClosures = []
                lock.unlock()
                closure()
            }
        }
    }

    class var sharedInstance: ThreadUtils {
        return _ThreadUtilsShared
    }

    public class func runGPUImage(block : () -> Void) {
        sharedInstance.lock.lock()
        ThreadUtils.sharedInstance.updateClosures.append(block)
        sharedInstance.lock.unlock()
    }

    public class func runGPUImageDestructive(block : () -> Void) {
        sharedInstance.lock.lock()
        ThreadUtils.sharedInstance.editClosures.append(block)
        sharedInstance.lock.unlock()
    }

    class func runCocos(closure : () -> Void) {
        if NSThread.isMainThread() {
            closure()
        } else {
            NSOperationQueue.mainQueue().addOperationWithBlock(closure)
        }
    }
}