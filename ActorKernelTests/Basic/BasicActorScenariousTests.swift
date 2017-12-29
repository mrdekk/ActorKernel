//
//  BasicActorScenariousTests.swift
//  ActorKernelTests
//
//  Created by Denis Malykh on 29.12.17.
//  Copyright © 2017 MrDekk. All rights reserved.
//

import Foundation
import XCTest

@testable import ActorKernel

class BasicActorScenariousTests: XCTestCase, Actable {

    // MARK: - Messages

    struct VendingOrder {
        var product: String
    }

    struct Product {
        var product: String
    }

    struct Bill {
        var amount: Double
        var product: String
    }

    struct Cheque {
        var billed: Bool
        var product: String
    }

    // MARK: - Actors

    class VendingMachine : BasicActor {
        private let bank: Actor

        private var orders: [String: Actable] = [:]

        required init(in container: ActorContainer, name: String?, queue: DispatchQueue) {
            self.bank = container.actor(for: Bank.self)
            super.init(in: container, name: name ?? "vending machine", queue: queue)
        }

        override func process(_ message: Any, sender: Actable?) {
            switch message {
            case let order as VendingOrder:
                guard let sndr = sender else {
                    super.process(message, sender: sender)
                    return
                }

                NSLog("Received order \(order.product), processing it...")
                orders[order.product] = sndr
                bank.tell(Bill(amount: 150, product: order.product), sender: self)

            case let cheque as Cheque:
                guard let sndr = orders[cheque.product] else {
                    super.process(message, sender: sender)
                    return
                }

                NSLog("Received cheque for \(cheque.product), sending product to client...")
                orders[cheque.product] = nil
                sndr.tell(Product(product: cheque.product), sender: self)

            default:
                super.process(message, sender: sender)
            }
        }
    }

    class Bank : BasicActor {
        override func process(_ message: Any, sender: Actable?) {
            switch message {
            case let bill as Bill:
                NSLog("Received bill for \(bill.product), chequeing it...")
                sender?.tell(Cheque(billed: true, product: bill.product), sender: self)

            default:
                super.process(message, sender: sender)
            }
        }
    }

    // MARK: - Actable

    private var expect: XCTestExpectation? = nil
    private var awaitingProduct: String? = nil
    private var system: ActorContainer! = nil

    func tell(_ message: Any, sender: Actable?) {
        switch message {
        case let product as Product:
            guard let exp = expect, let prod = awaitingProduct else {
                return
            }

            if product.product == prod {
                NSLog("Received asked product \(product.product)")
                exp.fulfill()
            }

        default:
            break
        }
    }

    // MARK: - Tests

    func testScenario() {
        // NOTE: self -> [VendingOrder] -> machine -> [Bill] -> bank -> [Cheque] -> machine -> [Product] -> self
        system = ActorContainer()

        let machine = system.actor(for: VendingMachine.self)

        expect = expectation(description: "Actor Test")
        awaitingProduct = orderId
        machine.tell(VendingOrder(product: orderId), sender: self)

        waitForExpectations(timeout: 10.0) { error in
            XCTAssert(error == nil, "Something bad happened")
        }
    }

}

private let orderId = "cappucino"
