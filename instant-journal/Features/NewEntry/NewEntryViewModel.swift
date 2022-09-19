//
//  NewEntryViewModel.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/09/18.
//

import Foundation
import RxSwift
import RxCocoa

// FIXME
import FirebaseCore
import FirebaseFirestore

protocol NewEntryInput {
    var didTapEmotionItem: AnyObserver<EmotionOption> { get }
    var didTapNext: AnyObserver<Void> { get }
}

protocol NewEntryOutput {
    var selectedEmotion: Observable<EmotionOption?> { get }
    var willDismissModal: Observable<Void> { get }
}

final class NewEntryViewModel: NewEntryInput & NewEntryOutput {
    private let disposeBag: DisposeBag = .init()
    
    // Input
    @ObserverWrapper var didTapEmotionItem: AnyObserver<EmotionOption>
    @ObserverWrapper var didTapNext: AnyObserver<Void>
    
    // Output
    @BehaviorWrapper(value: nil) var selectedEmotion: Observable<EmotionOption?>
    @PublishWrapper var willDismissModal: Observable<Void>
    
    // CurrentValue
    init() {
        // Input
        _didTapEmotionItem.subscribe(onNext: { [weak self] emotionOption in
            self?._selectedEmotion.accept(emotionOption)
        }).disposed(by: disposeBag)
        
        _didTapNext
            .withLatestFrom(selectedEmotion.flatMap { $0.flatMap(Observable.just) ?? Observable.empty() })
            .subscribe(onNext: { [weak self] selectedEmotion in
                guard let self = self else {
                    return
                }
            
                // process the submission
                Task {
                    let repository = RecordsCollectionImpl() // FIXME: write a repository layer
                    do {
                        try await repository.create(userId: "dummy", selectedEmotionRawValue: selectedEmotion.rawValue, text: "dummy text")
                    } catch {
                        // error handling
                    }
                    // close the modal after processing complete
                    self._willDismissModal.accept(())
                }
        }).disposed(by: disposeBag)
    }
}


// state.map { $0.didFinishedUpdateTrigger }
//            .filterNil()
//            .distinctUntilChanged()
//            .map { _ in }
//            .bind(to: _close)
//            .disposed(by: disposeBag)
