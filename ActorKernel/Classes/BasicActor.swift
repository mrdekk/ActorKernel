//
//  BasicActor.swift
//  ActorKernel
//
//  Created by Denis Malykh on 29.12.17.
//  Copyright © 2017 MrDekk. All rights reserved.
//

import Foundation

// TODO: policy: singleton or prototype

open class BasicActor : Actor, CustomStringConvertible {

    private let name: String
    private let container: ActorContainer
    private let queue: DispatchQueue
    
    private var mailbox: [Any] = []

    // private var busy: Bool

    required public init(in container: ActorContainer, name: String? = nil, queue: DispatchQueue) {
        self.name = name ?? String(format: "Actor-%d-%f", arc4random(), Date().timeIntervalSince1970)
        self.container = container
        self.queue = queue

        // busy = false
        self.mailbox = []
    }

    open func unhandled(_ message: Any, sender: Actable?) {
        // NOTE: should be overriden
        // TODO: drop to somewhere, log it or vice versa
    }

    open func process(_ message: Any, sender: Actable?) {
        // NOTE: should be overriden
        unhandled(message, sender: sender)
    }

    // MARK: - Actor Protocol

    public func tell(_ message: Any, sender: Actable?) {
        queue.async { [weak self] in
            guard let sself = self else { return }
            sself.process(message, sender: sender)
        }
    }

    public func tell(_ message: Any, delay: TimeInterval, sender: Actable?) {
        queue.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let sself = self else { return }
            sself.process(message, sender: sender)
        }
    }

    // MARK: - CustomStringConvertible

    open var description: String {
        return "<Actor \(name)>"
    }
}

