 

import Foundation

 public class  EventBox: NSObject {
    
    // MARK: - Singleton
    struct  Static {
        static let instance = EventBox()
        static let queue = dispatch_queue_create("Z9.Robin.EventBox", DISPATCH_QUEUE_SERIAL)
    }
    
    struct NamedObserver {
        let observer: NSObjectProtocol
        let name: String
    }
    
    var cache = [UInt : [NamedObserver]]()
    
    // MARK: -addObserverFroName
    public class func on(target: AnyObject, name: String, object: AnyObject?, queue: NSOperationQueue?, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        let id = ObjectIdentifier(target).uintValue
        let observer = NSNotificationCenter.defaultCenter().addObserverForName(name, object: object, queue: queue, usingBlock: handler)
        let namedObserver = NamedObserver(observer: observer, name: name)
        
        dispatch_async(Static.queue) {
            if let namedObservers = Static.instance.cache[id] {
                Static.instance.cache[id] = namedObservers + [namedObserver]
            }else{
                Static.instance.cache[id] = [namedObserver]
            }
        }
        return observer
    }
    
    public class func onMainThread(target: AnyObject, name: String, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return EventBox.on(target, name: name, object: nil, queue: NSOperationQueue.mainQueue(), handler: handler)
    }
    
    public class func onMainThread(target: AnyObject, name: String, object: AnyObject?,  handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return EventBox.on(target, name: name, object: object, queue: NSOperationQueue.mainQueue(), handler: handler)
    }
    
    public class func onBackgroundThread(target: AnyObject, name: String,   handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return EventBox.on(target, name: name, object: nil, queue: NSOperationQueue(), handler: handler)
    }
    
    public class func onBackgroundThread(target: AnyObject, name: String, object: AnyObject?,  handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return EventBox.on(target, name: name, object: object, queue: NSOperationQueue(), handler: handler)
    }
    
    //MARK: -removeOnserver
    public class func off(target: AnyObject) {
        let id  = ObjectIdentifier(target).uintValue
        let center = NSNotificationCenter.defaultCenter()
        
        dispatch_async(Static.queue) {
            if let namedObservers = Static.instance.cache.removeValueForKey(id){
                for namedObserver in namedObservers {
                    center.removeObserver(namedObserver.observer)
                }
            }
        }
    }
    
    public class func off(target: AnyObject, name: String) {
        let id  = ObjectIdentifier(target).uintValue
        let center = NSNotificationCenter.defaultCenter()
        
        dispatch_async(Static.queue) {
            if let namedObservers = Static.instance.cache[id]{
                Static.instance.cache[id] = namedObservers.filter({ (namedObserver: NamedObserver) -> Bool in
                    if namedObserver.name == name {
                        center.removeObserver(namedObserver.observer)
                        return false
                    }else{
                        return true
                    }
               })
            }
        }
    }
    
    // MARK: -postNotificationName
    public class func post(name: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
    }
    
    public class func post(name: String, object: AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: object)
    }
    
    public class func post(name: String, object: AnyObject?, userInfo: [NSObject : AnyObject]?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: object, userInfo: userInfo)
    }
 }