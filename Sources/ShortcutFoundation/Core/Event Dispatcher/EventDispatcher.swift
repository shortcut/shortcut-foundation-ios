//
//  EventDispatcher.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-09-13.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public protocol IEvent {
    var type: String { get }
    init(type: String)
}

public typealias Function = (IEvent) -> Void

public protocol IEventDispatcher {
    // Registers an event listener object with an EventDispatcher
    // object so that the listener receives notification of an event.
    // Currently it will replace the exising handler if called multiple times
    func addEventListener(forType type: String, handler: @escaping Function)
    
    // Dispatches an event into the event flow.
    func dispatchEvent(event: IEvent)
    
    // Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
    func hasEventListener(forType type: String) -> Bool
    
    // Removes a listener from the EventDispatcher object.
    // Currently it removes all the listeners for the key
    func removeEventListener(forType type: String)
}

public class EventDispatcher: IEventDispatcher {
    private var eventMap = EventMap()
    
    public init() {}
    
    public func addEventListener(forType type: String, handler: @escaping Function) {
        eventMap[type] = [handler]
    }
    
    public func dispatchEvent(event: IEvent) {
        guard let listeners = eventMap[event.type] else { return }
        listeners.forEach({ $0(event)})
    }
    
    public func hasEventListener(forType type: String) -> Bool {
        return eventMap.hasListener(forKey: type)
    }
    
    public func removeEventListener(forType type: String) {
        eventMap.remove(forKey: type)
    }
}
