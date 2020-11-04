//
//  AnimatedTab.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 10/29/20.
//

import UIKit

protocol AnimatedTabDelegate: AnyObject {
    func shouldSelect(at index: Int, item: AnimatedTabItem) -> Bool
    func didSelect(at index: Int, item: AnimatedTabItem)
}

class AnimatedTab: UIView {

    private let containerView = BackgroundStackView(frame: .zero)
    private var options: NSVAnimatedTabOptions?
    private let shapeLayer = CAShapeLayer()

    weak var delegate: AnimatedTabDelegate?

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addShape()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    func addTabs(with options: NSVAnimatedTabOptions) {
        let width = options.centerItemOptions.fullWidth
        self.options = options
        addContainerView()
        let mid = options.options.count/2
        for (index,option) in options.options.enumerated() {
            let item = AnimatedTabItem(frame: .zero)
            item.configure(with: option, animationType: options.animationOptions.tabSelectionAnimationType)
            item.onTap = { [weak delegate] in
                guard let delegate = delegate else {
                    return
                }
                if delegate.shouldSelect(at: index, item: item) {
                    delegate.didSelect(at: index, item: item)
                }
            }
            containerView.addArrangedSubview(item)
            if index == mid - 1 {
                let placeholderView = UIView(frame: .zero)
                placeholderView.backgroundColor = .clear
                placeholderView.widthAnchor.constraint(equalToConstant: width).isActive = true
                containerView.addArrangedSubview(placeholderView)
            }
            if let firstItem = containerView.arrangedSubviews.first {
                item.widthAnchor.constraint(equalTo: firstItem.widthAnchor).isActive = true
            }
        }
        let tabItems = containerView.arrangedSubviews.map({$0 as? AnimatedTabItem}).compactMap({$0})
        tabItems.forEach({$0.unselect(color: options.unselectedItemColor)})
    }

    func select(index: Int, selectedColor: UIColor) {
        let tabItems = containerView.arrangedSubviews.map({$0 as? AnimatedTabItem}).compactMap({$0})
        tabItems[index].select(color: selectedColor)
    }

    func unSelect(index: Int, unselectedColor: UIColor) {
        let tabItems = containerView.arrangedSubviews.map({$0 as? AnimatedTabItem}).compactMap({$0})
        tabItems[index].unselect(color: unselectedColor)
    }

    private func addContainerView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    private func addShape() {
        guard let shadowInfo = options?.shadowInfo else {
            return
        }
        shapeLayer.removeFromSuperlayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = options?.tabBackgroundColor.cgColor
        shapeLayer.shadowOffset = shadowInfo.shadowOffset
        shapeLayer.shadowColor = shadowInfo.shadowColor.cgColor
        shapeLayer.shadowRadius = shadowInfo.shadowRadius
        shapeLayer.shadowOpacity = shadowInfo.shadowOpacity
        layer.insertSublayer(shapeLayer, at: 0)
    }

    private func createPath() -> CGPath {
        guard let options = options else {
            return UIBezierPath().cgPath
        }
        let centerItemOptions = options.centerItemOptions

        let centerItemIncludedHeight: CGFloat = frame.height - centerItemOptions.insets.bottom

        let lineHeight: CGFloat = centerItemIncludedHeight - centerItemOptions.cornerRadius

        let path = UIBezierPath()

        let centerWidth = self.frame.width / 2

        let minWidth = (centerWidth - centerItemOptions.size.width/2 - centerItemOptions.insets.left)
        let maxWidth = (centerWidth + centerItemOptions.size.width/2 + centerItemOptions.insets.left)

        if options.corners.contains(.topLeft) {
            path.move(to: CGPoint(x: 0, y: options.cornerRadius))
            path.addArc(withCenter: CGPoint(x: options.cornerRadius, y: options.cornerRadius), radius: options.cornerRadius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(3*Double.pi/2), clockwise: true)
        } else {
            path.move(to: CGPoint(x: 0, y: 0))
        }

        if centerItemOptions.curveType == .bottom {
            var widthOffset: CGFloat = lineHeight
            if widthOffset < 0 {
                widthOffset = 0
            }
            path.addLine(to: CGPoint(x: minWidth - widthOffset, y: 0))

            path.addQuadCurve(to: CGPoint(x: minWidth, y: widthOffset < 0 ? 0 : widthOffset), controlPoint: CGPoint(x: minWidth, y: 0))

            path.addLine(to: CGPoint(x: minWidth, y: widthOffset))

            var curve = minWidth + centerItemOptions.cornerRadius + centerItemOptions.insets.left

            path.addArc(withCenter: CGPoint(x: curve, y: lineHeight), radius: centerItemOptions.cornerRadius + centerItemOptions.insets.left, startAngle: angle(between: CGPoint(x: curve, y: lineHeight), ending: CGPoint(x: minWidth, y: widthOffset)), endAngle: CGFloat(Double.pi/2), clockwise: false)

            curve += centerItemOptions.size.width - 2*centerItemOptions.cornerRadius

            path.addLine(to: CGPoint(x: curve, y: centerItemIncludedHeight + centerItemOptions.insets.left))

            path.addArc(withCenter: CGPoint(x: curve, y: lineHeight), radius: centerItemOptions.cornerRadius + centerItemOptions.insets.left, startAngle: CGFloat(Double.pi/2), endAngle: angle(between: CGPoint(x: curve, y: lineHeight), ending: CGPoint(x: maxWidth, y: widthOffset)), clockwise: false)

            path.addQuadCurve(to: CGPoint(x: maxWidth + widthOffset, y: 0), controlPoint: CGPoint(x: maxWidth, y: 0))
        }

        if options.corners.contains(.topRight) {
            path.addLine(to: CGPoint(x: frame.width - options.cornerRadius, y: 0))
            path.addArc(withCenter: CGPoint(x: frame.width - options.cornerRadius, y: options.cornerRadius), radius: options.cornerRadius, startAngle: CGFloat(-Double.pi/2), endAngle: 0, clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: frame.width, y: 0))
        }

        if options.corners.contains(.bottomRight) {
            path.addLine(to: CGPoint(x: frame.width, y: frame.height - options.cornerRadius))
            path.addArc(withCenter: CGPoint(x: frame.width - options.cornerRadius, y: frame.height - options.cornerRadius), radius: options.cornerRadius, startAngle: 0, endAngle: CGFloat(Double.pi/2), clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        }

        if options.corners.contains(.bottomLeft) {
            path.addLine(to: CGPoint(x: options.cornerRadius, y: frame.height))
            path.addArc(withCenter: CGPoint(x: options.cornerRadius, y: frame.height - options.cornerRadius), radius: options.cornerRadius, startAngle: CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
        } else {
            path.addLine(to: CGPoint(x: 0, y: frame.height))
        }
        path.close()
        return path.cgPath
    }

    private func angle(between starting: CGPoint, ending: CGPoint) -> CGFloat {
        let center = CGPoint(x: ending.x - starting.x, y: ending.y - starting.y)
        let radians = atan2(center.y, center.x)
        return radians
    }
}
