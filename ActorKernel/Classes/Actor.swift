//
//  Actor.swift
//  ActorKernel
//
//  Created by Denis Malykh on 29.12.17.
//  Copyright © 2017 MrDekk. All rights reserved.
//

import Foundation

public protocol Actor : class, Actable {
    init(in container: ActorContainer, name: String?, queue: DispatchQueue)

    func tell(_ message: Any, sender: Actable?)
    func tell(_ message: Any, delay: TimeInterval, sender: Actable?)
}

infix operator !

public func ! (l: Actor, r: Any) -> Void {
    l.tell(r, sender: nil)
}
