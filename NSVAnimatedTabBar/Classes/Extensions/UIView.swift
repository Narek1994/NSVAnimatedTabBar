//
//  UIView.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 10/30/20.
//

import UIKit

extension UIView {
    func addRipple() {
        let layer1 = CAShapeLayer()
        layer1.path = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: 10, height: frame.height - 5),cornerRadius: 0).cgPath
        layer1.frame = CGRect(x: 0, y: 0, width: 10, height: frame.height - 5)
        layer1.position = self.center
        layer1.fillColor = UIColor.init(white: 1.0, alpha: 0.3).cgColor
        self.layer.addSublayer(layer1)

        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0.5
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 0.3
        layer1.add(fadeAnimation, forKey: "opacity1")

        let positionAnimation = CABasicAnimation(keyPath: "transform.scale.x")
        positionAnimation.toValue = 13
        positionAnimation.fromValue = 1
        positionAnimation.duration = 0.3
        positionAnimation.fillMode = CAMediaTimingFillMode.removed
        layer1.add(positionAnimation, forKey: "transform1")

        let delayBlock = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: delayBlock) {
            layer1.removeFromSuperlayer()
        }
    }

    func addRotationAnimation(with duration: Double) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = Float.infinity
        layer.add(rotationAnimation, forKey: nil)
    }

    var bottomPadding: CGFloat {
        guard let window = UIApplication.shared.windows.first else {
            return 0
        }
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        return bottomSafeAreaHeight
    }

    func addShadow(info: ShadowInfo) {
        layer.masksToBounds = false
        layer.shadowOffset = info.shadowOffset
        layer.shadowColor = info.shadowColor.cgColor
        layer.shadowRadius = info.shadowRadius
        layer.shadowOpacity = info.shadowOpacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

