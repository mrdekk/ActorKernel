//
//  Actable.swift
//  ActorKernel
//
//  Created by Denis Malykh on 29.12.17.
//  Copyright © 2017 MrDekk. All rights reserved.
//

import Foundation

public protocol Actable {
    func tell(_ message: Any, sender: Actable?)
}
