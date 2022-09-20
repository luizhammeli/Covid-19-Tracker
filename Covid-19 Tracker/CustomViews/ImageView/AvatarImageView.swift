//
//  GHAvatarImageView.swift
//  ios-base-architecture
//
//  Created by Luiz on 12/04/20.
//  Copyright © 2020 Luiz Hammerli. All rights reserved.
//

import UIKit

final class AvatarImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        layer.cornerRadius = 3
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}


