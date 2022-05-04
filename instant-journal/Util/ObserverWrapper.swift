//
//  ObserverWrapper.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/04.
//

import RxRelay
import RxSwift

@propertyWrapper
final class ObserverWrapper<Element> {
    let wrappedValue: AnyObserver<Element>
    private let relay: PublishRelay<Element>

    init() {
        let relay = PublishRelay<Element>()
        self.wrappedValue = AnyObserver<Element> { event in
            switch event {
            case let .next(element):
                relay.accept(element)
            case .completed, .error:
                return
            }
        }
        self.relay = relay
    }
}

extension ObserverWrapper: ObservableType {
    func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Element == Observer.Element {
        relay.subscribe(observer)
    }

    func asObservable() -> Observable<Element> {
        relay.asObservable()
    }
}
