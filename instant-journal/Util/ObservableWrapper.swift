//
//  ObservableWrapper.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/04.
//

import RxRelay
import RxSwift

// MARK: - ObservableWrapperProtocol

protocol ObservableWrapperProtocol {
    associatedtype Element
    var wrappedValue: Observable<Element> { get }
    func accept(_ element: Element)
}

extension ObservableWrapperProtocol where Element == Void {

    func accept() {
        accept(())
    }
}

// MARK: - ObservableType extension for ObservableWrapperProtocol

extension ObservableType {

    func bind<T: ObservableWrapperProtocol>(to relay: T) -> Disposable where T.Element == Element {
        subscribe { event in
            switch event {
            case let .next(value):
                relay.accept(value)
            case .completed, .error:
                return
            }
        }
    }
}

// MARK: - PublishWrapper

@propertyWrapper
final class PublishWrapper<Element>: ObservableWrapperProtocol {
    let wrappedValue: Observable<Element>
    private let relay: PublishRelay<Element>

    init() {
        let relay = PublishRelay<Element>()
        self.wrappedValue = relay.asObservable()
        self.relay = relay
    }

    func accept(_ element: Element) {
        relay.accept(element)
    }
}

// MARK: - BehaviorWrapper

@propertyWrapper
final class BehaviorWrapper<Element>: ObservableWrapperProtocol {
    let wrappedValue: Observable<Element>
    private let relay: BehaviorRelay<Element>

    init(value: Element) {
        let relay = BehaviorRelay<Element>(value: value)
        self.wrappedValue = relay.asObservable()
        self.relay = relay
    }

    func accept(_ element: Element) {
        relay.accept(element)
    }
}
