//
//  NewEntryViewController.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/05/05.
//

import UIKit
import RxSwift

final class NewEntryViewController: UIViewController {
    
    private let disposeBag: DisposeBag = .init()

    @Lazy() private var input: NewEntryInput
    @Lazy() private var output: NewEntryOutput
    
    private let worstIcon: UIButton = {
        let button = ImageButton()
        button.setImage(systemName: "cloud.heavyrain.fill")
        return button
    }()
    
    private let badIcon: UIButton = {
        let button = ImageButton()
        button.setImage(systemName: "cloud.fill")
        return button
    }()

    private let goodIcon: UIButton = {
        let button = ImageButton()
        button.setImage(systemName: "cloud.sun.fill")
        return button
    }()
    
    private let perfectIcon: UIButton = {
        let button = ImageButton()
        button.setImage(systemName: "sun.max.fill")
        return button
    }()
    
    private let emotionsHStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.backgroundColor = .white
        view.distribution = .fillEqually
        view.spacing = 15.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let footer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nextButton: RectangleButton = {
        let view = RectangleButton()
        view.setTitle("Confirm", for: .normal)
        view.buttonStyle = .primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(initViewModel: () -> NewEntryInput & NewEntryOutput) {
        super.init(nibName: nil, bundle: nil)

        let viewModel = initViewModel()
        self.input = viewModel
        self.output = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // navigation
        navigationItem.title = "What's your mood?"
        let item = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
        item.rx.tap
            .bind(to: Binder(self) { vc, _ in vc.dismiss(animated: true) })
            .disposed(by: disposeBag)
        navigationItem.leftBarButtonItem = item
        
        setupViews()
        
        // binding
        setupBindings()
    }

    private func setupViews() {
        view.addSubview(footer)
        view.addSubview(emotionsHStack)
        
        emotionsHStack.addArrangedSubview(worstIcon)
        emotionsHStack.addArrangedSubview(badIcon)
        emotionsHStack.addArrangedSubview(goodIcon)
        emotionsHStack.addArrangedSubview(perfectIcon)
        
        footer.addArrangedSubview(nextButton)

        NSLayoutConstraint.activate([
            emotionsHStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0),
            emotionsHStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            emotionsHStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            emotionsHStack.bottomAnchor.constraint(equalTo: footer.topAnchor),

            footer.heightAnchor.constraint(equalToConstant: 45.0),
            footer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            footer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            footer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            worstIcon.heightAnchor.constraint(equalTo: worstIcon.widthAnchor),
            badIcon.heightAnchor.constraint(equalTo: badIcon.widthAnchor),
            goodIcon.heightAnchor.constraint(equalTo: goodIcon.widthAnchor),
            perfectIcon.heightAnchor.constraint(equalTo: perfectIcon.widthAnchor),
        ])
    }
    
    private func setupBindings() {
        // input
        worstIcon.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.input.didTapEmotionItem.onNext(.worst) })
            .disposed(by: disposeBag)
        badIcon.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.input.didTapEmotionItem.onNext(.bad) })
            .disposed(by: disposeBag)
        goodIcon.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.input.didTapEmotionItem.onNext(.good) })
            .disposed(by: disposeBag)
        perfectIcon.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.input.didTapEmotionItem.onNext(.perfect) })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.input.didTapNext.onNext(()) })
            .disposed(by: disposeBag)
        
        // icons display
        output.selectedEmotion
            .subscribe(onNext: { [weak self] selectedEmotion in
                self?.worstIcon.tintColor = selectedEmotion == .worst ? .systemRed : .systemGray4
                self?.badIcon.tintColor = selectedEmotion == .bad ? .systemOrange : .systemGray4
                self?.goodIcon.tintColor = selectedEmotion == .good ? .systemTeal : .systemGray4
                self?.perfectIcon.tintColor = selectedEmotion == .perfect ? .systemGreen : .systemGray4
            })
            .disposed(by: disposeBag)
        
        // next button display
        output.selectedEmotion
            .subscribe(onNext: { [weak self] selectedEmotion in
                self?.nextButton.isEnabled = selectedEmotion != nil
            })
            .disposed(by: disposeBag)
        
        // routing
        output.willDismissModal
            .subscribe(onNext: { [weak self] selectedEmotion in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
