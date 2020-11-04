//
//  Types.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 10/30/20.
//

import UIKit

public enum SubOptionsAnimationType {
    case basic
    case fading(duration: Double)
    case movingByOne(duration: Double, withScaling: Bool)
}

public enum TabSelectionAnimationType {
    case none
    case custom(duration: Double, animation: UIView.AnimationOptions)
}

public enum SubOptionsDistributionType {
    case custom(itemsSpacing: CGFloat, minYOffset: CGFloat, maxYOffset: CGFloat)
}

public enum CurveType {
    case none
    case bottom
}

public enum RadiusCorners {
    case topLeft, topRight, bottomLeft, bottomRight
}
