//
//  AnimatedTabOptionsImplementation.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 10/31/20.
//

import UIKit
import NSVAnimatedTabBar

class DefaultTabAnimationOptions: NSVTabAnimationOptions {

    var mainAnimationDuration: Double = 0.5
    var options: UIView.AnimationOptions = [.curveEaseInOut, .allowUserInteraction]
    var usingSpringWithDamping: CGFloat = 0.7
    var initialSpringVelocity: CGFloat = 1
    var delay: Double = 0
    var tabMovePercentage: CGFloat? = 0.9
    var centerItemMovePercentage: CGFloat? = 0.2
    var subOptionsAnimationtype: SubOptionsAnimationType = .basic//.movingByOne(duration: 0.3, withScaling: true)
    var tabSelectionAnimationType: TabSelectionAnimationType = .custom(duration: 0.3, animation: [.transitionFlipFromLeft])
    var shouldAnimateScreenChanges: Bool = true
}

class DefaultTabItemOptions: NSVTabItemOptions {

    var title: String?
    var image: UIImage?
    var selectedImage: UIImage?
    var itemInsets: UIEdgeInsets
    var spacing: CGFloat?
    var font: UIFont?

    init(title: String?, image: UIImage?, selectedImage: UIImage? = nil, itemInsets: UIEdgeInsets = .init(top: 3, left: 3, bottom: 3, right: 3), spacing: CGFloat? = 2, font: UIFont? = UIFont.systemFont(ofSize: 15)) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage ?? image
        self.itemInsets = itemInsets
        self.spacing = spacing
        self.font = font
    }
}

class DefaultCenterItemOptions: NSVCenterItemOptions {

    var size: CGSize = .init(width: 60, height: 60)
    var subOptionsSize: CGSize = .init(width: 50, height: 50)
    var insets: UIEdgeInsets = .init(top: 20, left: 5, bottom: 10, right: 5)
    var options: NSVTabItemOptions = DefaultTabItemOptions(title: nil, image: UIImage(named: "open"), selectedImage: UIImage(named: "close")!, itemInsets: .zero, spacing: nil, font: nil)
    var subOptions: [NSCenterItemSubOptions] = [
        DefaultCenterItemSubOptions(image: UIImage(named: "like")!, backgroundColor: .white, cornerRadius: 25),
        DefaultCenterItemSubOptions(image: UIImage(named: "dislike")!, backgroundColor: .white, cornerRadius: 25),
        DefaultCenterItemSubOptions(image: UIImage(named: "balance")!, backgroundColor: .white, cornerRadius: 25)]
    var backgroundColor: UIColor = .white
    var cornerRadius: CGFloat = 30
    var shadowInfo: ShadowInfo? = ShadowInfo(shadowRadius: 1, shadowOpacity: 1, shadowColor: UIColor.black.withAlphaComponent(0.15), shadowOffset: .zero)
    var distributionType: SubOptionsDistributionType = .custom(itemsSpacing: 10, minYOffset: 10, maxYOffset: 60)
    var curveType: CurveType = .bottom
}

class DefaultCenterItemSubOptions: NSCenterItemSubOptions {
    
    var image: UIImage
    var backgroundColor: UIColor
    var cornerRadius: CGFloat
    var shadowInfo: ShadowInfo? = ShadowInfo(shadowRadius: 1, shadowOpacity: 1, shadowColor: UIColor.black.withAlphaComponent(0.15), shadowOffset: .zero)

    public init(image: UIImage, backgroundColor: UIColor, cornerRadius: CGFloat) {
        self.image = image
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}

class DefaultAnimatedTabOptions: NSVAnimatedTabOptions {
    
    var tabHeight: CGFloat = 50
    var tabInsets: UIEdgeInsets = .zero
    var tabBackgroundColor: UIColor = .white
    var selectedItemColor: UIColor = .black
    var unselectedItemColor: UIColor = .lightGray
    var cornerRadius: CGFloat = 10
    var corners: [RadiusCorners] = [.topLeft, .topRight]
    var shadowInfo: ShadowInfo? = ShadowInfo(shadowRadius: 5, shadowOpacity: 0.05, shadowColor: .black, shadowOffset: .init(width: 0, height: -5))
    var options: [NSVTabItemOptions] = [
        DefaultTabItemOptions(title: nil, image: UIImage(named: "poll"), itemInsets: .init(top: 10, left: 5, bottom: 5, right: 5)),
        DefaultTabItemOptions(title: nil, image: UIImage(named: "language"), itemInsets: .init(top: 10, left: 5, bottom: 5, right: 5)),
        DefaultTabItemOptions(title: nil, image: UIImage(named: "security"), itemInsets: .init(top: 10, left: 5, bottom: 5, right: 5)),
        DefaultTabItemOptions(title: nil, image: UIImage(named: "location"), itemInsets: .init(top: 10, left: 5, bottom: 5, right: 5))
    ]
    var animationOptions: NSVTabAnimationOptions = DefaultTabAnimationOptions()
    var centerItemOptions: NSVCenterItemOptions = DefaultCenterItemOptions()
    var coverAlpha: CGFloat = 0.1
    var mainBackgroundColor: UIColor? = nil
}
