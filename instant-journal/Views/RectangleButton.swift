//
//  RectangleButton.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/09/19.
//

import UIKit

/// 共通スタイル指定ボタンクラス
final class RectangleButton: UIButton {
    
    private let enableAlpha: CGFloat    = 1.0
    private let disableAlpha: CGFloat   = 0.3

    static let font: UIFont = .boldSystemFont(ofSize: 15.0)

    var buttonStyle: ButtonStyle = .primary {
        didSet {
            updateView(state: state)
            applyDesign()
        }
    }

    private let cornerRadius: CGFloat = 10.0

    override var isEnabled: Bool {
        didSet {
            // enabledとdisabledに応じてスタイル変更
            if isEnabled {
                updateView(state: .normal)
            } else {
                updateView(state: .disabled)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView(state: .normal)
        applyDesign()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView(state: .normal)
        applyDesign()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if isEnabled {
            UIView.animate(withDuration: 0.2, animations: {
                self.updateView(state: .normal)
            })
        } else {
            updateView(state: .disabled)
        }
        applyDesign()
    }

    func updateView(state: UIControl.State) {
        let backgroundColor = state == .disabled ? UIColor.black : buttonStyle.backgroundColor
        let borderColor = state == .disabled ? UIColor.black : buttonStyle.borderColor
        let alpha: CGFloat = state == .disabled ?  disableAlpha : enableAlpha

        setTitleColor(buttonStyle.fontColor, for: state)
        self.backgroundColor = backgroundColor
        self.alpha = alpha
        layer.borderColor   = borderColor.cgColor
    }

    /// reflect design
    func applyDesign() {
        layer.cornerRadius  = cornerRadius
        layer.contentsScale = UIScreen.main.scale
        layer.borderWidth   = 1
    }
}

enum ButtonStyle {
    case primary
    case secondary

    var fontColor: UIColor {
        switch self {
        case .primary:
            return UIColor.white
        case .secondary:
            return .systemBlue
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return .systemBlue
        case .secondary:
            return UIColor.white
        }
    }

    var borderColor: UIColor {
        .systemBlue
    }
}
