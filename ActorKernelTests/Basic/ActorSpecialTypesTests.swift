//
//  ActorSpecialTypesTests.swift
//  ActorKernelTests
//
//  Created by Denis Malykh on 31.12.17.
//  Copyright © 2017 MrDekk. All rights reserved.
//

import Foundation
import XCTest

@testable import ActorKernel

class ActorSpecialTypesTests: XCTestCase {

    struct Message {

    }

    class SimpleActor : BasicActor {

    }

    class MainThreadActor : BasicActor, UIActor {
        var processing: ((_ message: Any) -> Void)? = nil
        override func process(_ message: Any, sender: Actable?) {
            processing?(message)
        }
    }

    class MultiInstanceActor : BasicActor, PrototypeActor {
        
    }

    func testSingletonActor() {
        let container = ActorContainer()

        let a1 = container.actor(for: SimpleActor.self)
        let a2 = container.actor(for: SimpleActor.self)
        
        XCTAssert(a1 === a2, "Singleton actor should be the same")
    }

    func testPrototypeActor() {
        let container = ActorContainer()

        let a1 = container.actor(for: MultiInstanceActor.self)
        let a2 = container.actor(for: MultiInstanceActor.self)

        XCTAssert(a1 !== a2, "Prototype actor should not be the same")
    }

    func testUIActor() {
        let container = ActorContainer()

        let a1 = container.actor(for: MainThreadActor.self)
        guard let ma1 = a1 as? MainThreadActor else {
            XCTAssert(false, "Something gone bad")
            return
        }

        let exp = expectation(description: "Main thread expectation")

        ma1.processing = { msg in
            XCTAssert(msg is Message, "Message is not message")
            XCTAssert(Thread.isMainThread, "Should be scheduled on main thread")
            exp.fulfill()
        }
        ma1 ! Message()

        waitForExpectations(timeout: 10) { error in
            XCTAssert(error == nil, "Something gone bad")
        }
    }
}
