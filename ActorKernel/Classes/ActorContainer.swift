//
//  ActorContainer.swift
//  ActorKernel
//
//  Created by Denis Malykh on 29.12.17.
//  Copyright © 2017 MrDekk. All rights reserved.
//

import Foundation

open class ActorContainer {

    private var refs: [String: Actor] = [:]

    open func actor<T: Actor>(for type: T.Type, name: String? = nil) -> Actor {
        let typeName = NSStringFromClass(T.self)

        let queue: DispatchQueue
        switch type {
        case is UIActor.Type:
            queue = DispatchQueue.main

        default:
            queue = DispatchQueue(label: "Actor.Queue.\(name ?? "-")")
        }

        let actorAddress: String

        switch type {
        case is PrototypeActor.Type:
            actorAddress = [typeName, "_", UUID().uuidString].joined()
            break

        default:
            actorAddress = typeName
            if let cached = refs[actorAddress] {
                return cached
            }
        }

        let instance = type.init(
            in: self,
            name: name,
            queue: queue
        )
        refs[actorAddress] = instance

        return instance
    }

    // MARK: - Management

    open func register(actor: Actor, for address: String) throws {
        guard refs[address] == nil else {
            throw ActorErrors.alreadyRegistered
        }

        refs[address] = actor
    }

    open func unregister(from address: String) throws {
        guard refs[address] != nil else {
            throw ActorErrors.notRegistered
        }

        refs[address] = nil
    }

    open func actor(for address: String) throws -> Actor {
        guard let actor = refs[address] else {
            throw ActorErrors.notRegistered
        }

        return actor
    }

    // MARK: - Actable

    open func tell(_ message: Any, to address: String, sender: Actable? = nil) throws {
        guard let actor = refs[address] else {
            throw ActorErrors.notRegistered
        }

        actor.tell(message, sender: sender)
    }

    open func tell(_ message: Any, to address: String, delay: TimeInterval, sender: Actable? = nil) throws {
        guard let actor = refs[address] else {
            throw ActorErrors.notRegistered
        }

        actor.tell(message, delay: delay, sender: sender)
    }
    
}
