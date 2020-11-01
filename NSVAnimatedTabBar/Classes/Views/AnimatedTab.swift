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
        if let _ = options?.centerItemOptions.curveType.offset {
            addShape()
        } else {
            if let shadowInfo = options?.shadowInfo {
                layer.masksToBounds = false
                layer.shadowRadius = shadowInfo.shadowRadius
                layer.shadowOpacity = Float(shadowInfo.shadowOpacity)
                layer.shadowColor = shadowInfo.shadowColor.cgColor
                layer.shadowOffset = shadowInfo.shadowOffset
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    func addTabs(with options: NSVAnimatedTabOptions) {
        let width = options.centerItemOptions.fullWidth
        self.options = options
        addContainerView(height: options.tabHeight)
        let mid = options.options.count/2
        for (index,option) in options.options.enumerated() {
            let item = AnimatedTabItem(frame: .zero)
            item.configure(with: option, animationType: options.animationOptions.tabSelectionAnimationType)
            item.onTap = { [weak self, weak delegate] in
                guard let strongSelf = self, let delegate = delegate else {
                    return
                }
                if delegate.shouldSelect(at: index, item: item) {
                    delegate.didSelect(at: index, item: item)
                    strongSelf.select(index: index, selectedColor: options.selectedItemColor, unselectedColor: options.unselectedItemColor)
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
        //containerView.backgroundColor = options.tabBackgroundColor
        containerView.cornerRadius = options.cornerRadius

    }

    func select(index: Int, selectedColor: UIColor, unselectedColor: UIColor) {
        let tabItems = containerView.arrangedSubviews.map({$0 as? AnimatedTabItem}).compactMap({$0})
        tabItems.forEach({$0.unselect(color: unselectedColor)})
        tabItems[index].select(color: selectedColor)
    }

    private func addContainerView(height: CGFloat) {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: height).isActive = true
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
        guard let centerItemOptions = options?.centerItemOptions else {
            return UIBezierPath().cgPath
        }
        let bottomInset: CGFloat = options?.centerItemOptions.curveType.offset ?? 0
        let height: CGFloat = frame.height - centerItemOptions.insets.bottom + bottomInset - bottomPadding
        let lineHeight: CGFloat = frame.height - centerItemOptions.insets.bottom - centerItemOptions.cornerRadius - bottomPadding
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        let minWidth = (centerWidth - centerItemOptions.fullWidth/2 - 5)
        let maxWidth = (centerWidth + centerItemOptions.fullWidth/2 + 5)
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: minWidth, y: 0))
        path.addLine(to: CGPoint(x: minWidth, y: lineHeight))
        var curve = centerWidth - centerItemOptions.fullWidth/2 + centerItemOptions.cornerRadius
        path.addQuadCurve(to: CGPoint(x: curve, y: height), controlPoint: CGPoint(x: minWidth, y: height))
        curve = centerWidth + centerItemOptions.fullWidth/2 - centerItemOptions.cornerRadius
        path.addLine(to: CGPoint(x: curve, y: height))
        path.addQuadCurve(to: CGPoint(x: maxWidth, y: lineHeight), controlPoint: CGPoint(x: maxWidth, y: height))
        path.addLine(to: CGPoint(x: maxWidth, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.close()
        return path.cgPath
    }
}
