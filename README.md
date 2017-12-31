# DataKernel

[![Language: Swift](https://img.shields.io/badge/lang-Swift-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Language: Swift](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](http://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/mrdekk/ActorKernel.svg?branch=master)](https://travis-ci.org/mrdekk/ActorKernel)
[![not yet Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![not yet CocoaPods compatible](https://img.shields.io/badge/Cocoa_Pods-compatible-4BC51D.svg?style=flat)](http://cocoapods.org)

## What is ActorKernel?

ActorKernel is yet another actor implementation for swift programming language. It heavily inspired by [Akka](http://akka.io), but written from ground up with swift features in mind.

If you have any propositions please file issue.
If you need usage examples - see unit test, it is very straightforward

## Features
- Swift (tested in XCode 9.1)
- Protocols based design
- Fully tested
- Actively supported

## Setup

### [CocoaPods](https://cocoapods.org)

**NOTE:** ActorKernel is not now compatible with CocoaPods. It is planned, but not ready yet

1. Install [CocoaPods](https://cocoapods.org). You can do it with `gem install cocoapods`
2. Edit your `Podfile` file and add the following line `pod 'ActorKernel'` (you have to use use_frameworks!, because this is a Swift pod)
3. Update your pods with the command `pod install`
4. Open the project from the generated workspace (`.xcworkspace` file).

*Note: You can also test the last commits by specifying it directly in the Podfile line*

### [Carthage](https://carthage)

**NOTE:** ActorKernel is not now compatible with Carthage. At this point of time (31th of December 2017), it isn't planned, but if you really need it - please like an issue for it.

1. Install [Carthage](https://github.com/carthage/carthage) on your computer using `brew install carthage`
3. Edit your `Cartfile` file adding the following line `github "mrdekk/ActorKernel"`
4. Update and build frameworks with `carthage update`
5. Add generated frameworks to your app main target following the steps [here](https://github.com/carthage/carthage)

# How to use

#### Create an ActorContainer

```swift
let container = ActorContainer()
```

You can create as many containers as you need. You can even send messages between actors in different containers, it is not forbidden, but not fully tested.

#### Define a Message Struct

```swift
struct SuperMessage {
  let field1: String
  let field2: Bool
  ...
}
```

It is strongly recommended, that message will be immutable value type structs.

#### Define an Actor

```swift
class MyActor : BasicActor {
  override func process(_ message: Any, sender: Actable?) {
    switch message {
      case let m as SuperMessage:
        // process m as SuperMessage struct

      default:
        super.process(message, sender: sender)
    }
  }
}
```

Actor is preferred to be a class. Actor should override process message - it is main entry point of every actor.

If you want your Actor to perform operations on main thread, mark them with UIActor protocol, as 

```swift
class MyActor : BasicActor, UIActor {
  ...
}
```

#### Instantiate an Actor

```swift
let actor = container.actor(for: MyActor.self)
```

If you call actor(for:) twice - you will receive the same instance, so basic actors are some kind of singletons inside one container. But it is not a real singletons, because if you define two containers, you can have instance of same 'singleton' actor in each of them.

If you need so called 'prototype' actors (actor that can have multiple instances inside one container), you should mark you actor class as PrototypeActor protocol

```swift
class MyActor : BasicActor, PrototypeActor {
  ...
}
```

#### Send a message to actor

You have three options to send a message to an actor, for all of them you should have a reference to actor.

1. Just tell a message to an actor

```swift
actor.tell(SuperMessage(), sender: nil)
```

2. Tell a message to an actor after delay

```swift
actor.tell(SuperMessage(), delay: 10, sender: nil)
```

delay is TimeInterval class, so construct it properly

3. Use syntactic sugar with operator !

Inspired by Akka

```swift
actor ! SuperMessage()
```

## Recommendations

1. Design your actors as state machines (finite automata).
2. Use sender variable to send an answer message to sender actor.

# Contributing

## Support

If you want to communicate any issue, suggestion or even make a contribution, you have to keep in mind the flow bellow:

- If you need help, ask your doubt in Stack Overflow using the tag 'actorkernel'
- If you want to ask something in general, use Stack Overflow too.
- Open an issue either when you have an error to report or a feature request.
- If you want to contribute, submit a pull request, and remember the rules to follow related with the code style, testing, ...

## Code of conduct

This project adheres to the [Open Code of Conduct][code-of-conduct]. By participating, you are expected to honor this code.
[code-of-conduct]: http://todogroup.org/opencodeofconduct/#ActorKernel/mrdekk@yandex.ru

## License
The MIT License (MIT)

Copyright (c) <2017> <MrDekk>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
