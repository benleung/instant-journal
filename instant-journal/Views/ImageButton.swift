//
//  ImageButton.swift
//  instant-journal
//
//  Created by Ben Leung on 2022/09/18.
//

import UIKit

final class ImageButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setImage(systemName: String) {
        setImage(UIImage(systemName: systemName), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        translatesAutoresizingMaskIntoConstraints = false
    }
}
