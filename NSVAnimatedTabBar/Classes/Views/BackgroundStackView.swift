//
//  BackgroundStackView.swift
//  fixn-shared
//
//  Created by Narek Simonyan on 3/24/20.
//  Copyright © 2020 Fixn. All rights reserved.
//

import UIKit

open class BackgroundStackView: UIStackView {
    
    @IBInspectable public var color: UIColor?

    private var radius: CGFloat?
    
    public var shadowInfo: ShadowInfo?
    
    override open var backgroundColor: UIColor? {
        get { return color }
        set {
            color = newValue
            self.setNeedsLayout()
        }
    }
    
    open var cornerRadius: CGFloat {
        get { return backgroundLayer.cornerRadius }
        set {
            self.radius = newValue
            self.setNeedsLayout()
        }
    }

    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius ?? 0).cgPath
        if let info = shadowInfo {
            backgroundLayer.shadowColor = info.shadowColor.cgColor
            backgroundLayer.shadowOffset = .zero
            backgroundLayer.shadowOpacity = Float(info.shadowOpacity)
            backgroundLayer.shadowRadius = info.shadowRadius
        }
        backgroundLayer.fillColor = color?.cgColor
    }
}

public class ShadowView: UIView {

    let containerView = UIStackView(frame: .zero)

    var cornerRadius: CGFloat? {
        didSet {
            layer.cornerRadius = cornerRadius ?? 0
            containerView.layer.cornerRadius = cornerRadius ?? 0
        }
    }
    var shadowInfo: ShadowInfo? {
        didSet {
            setShadow(info: shadowInfo)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }

    func layoutView() {
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    private func setShadow(info: ShadowInfo?) {
        if let info = info {
            addShadow(info: info)
        }
    }
}
