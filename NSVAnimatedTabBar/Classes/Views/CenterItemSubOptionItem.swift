//
//  CenterItemSubOptionItem.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 10/29/20.
//

import UIKit

public class CenterItemSubOptionItem: ShadowView {

    private let stackContainerView = BackgroundStackView(frame: .zero)
    private let imageView = UIImageView(frame: .zero)

    var onTap: (()->Void)?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
    }

    private func addSubviews() {
        backgroundColor = .clear
        containerView.addArrangedSubview(stackContainerView)
        stackContainerView.addArrangedSubview(imageView)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @objc private func handleTap() {
        onTap?()
    }

    func set(options: NSCenterItemSubOptions) {
        imageView.contentMode = .center
        imageView.image = options.image
        backgroundColor = options.backgroundColor
        cornerRadius = options.cornerRadius
        shadowInfo = options.shadowInfo
    }
}
