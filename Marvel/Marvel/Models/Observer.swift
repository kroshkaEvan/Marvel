//
//  Observer.swift
//  Marvel
//
//  Created by Эван Крошкин on 9.08.22.
//

import Foundation

class Observable<Value> {
    
    struct Observer<Value> {
        weak var observer: AnyObject?
        let block: (Value) -> Void
    }
    
    private var observers = [Observer<Value>]()
    
    /// `maxNilObserversCount` this min number of observers without references which need to determinate in observers array for remove than. It needed that do not lost performance, as perform filter after every notify is excessively. Ths number has been choosed based on experionce and can be change in a future.
    private let maxNilObserversCount = 5
    
    public var value: Value {
        didSet { notifyObservers(value) }
    }
    
    public init(_ value: Value) {
        self.value = value
    }
    
    /// Subscribing an observer on value
    /// - Parameters:
    ///   - observer: an observer
    ///   - observerBlock: observerBlock
    public func observe(on observer: AnyObject, observerBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
    }
    
    /// Subscribing an observer on value. Replay the starting value when the first subscription added.
    /// - Parameters:
    ///   - observer: an observer
    ///   - observerBlock: observerBlock
    public func observeWithStartingValue(on observer: AnyObject, observerBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(value)
    }
    
    /// Remove an observer from observers
    /// - Parameters:
    ///   - observer: an observer
    public func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
}

// MARK: - ObservableEmpty

typealias ObservableEmpty = Observable<Void>

extension ObservableEmpty {
    
    public convenience init() {
        self.init(())
    }
    
    public func notify() {
        value = ()
    }
    
}

// MARK: - Private Methods

private typealias ObservationHelper = Observable
private extension ObservationHelper {
    
    /// Remove all observer which have lost a reference
    /// - Parameters:
    ///   - observer: an observer
    func compactObservers() {
        observers = observers.filter { $0.observer != nil }
    }
    
    func notifyObservers(_ value: Value) {
        var count = 0
        for observer in observers {
            guard observer.observer != nil else {
                count += 1
                continue
            }
            observer.block(value)
        }
        guard count >= maxNilObserversCount else { return }
        compactObservers()
    }
}
