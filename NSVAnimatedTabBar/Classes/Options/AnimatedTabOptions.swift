//
//  AnimatedTapOptions.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 10/29/20.
//

import UIKit

/// NSVTabController animation options
public protocol NSVTabAnimationOptions {

    /// Center item and tab bar animation duration
    var mainAnimationDuration: Double {set get}
    /// Center item and tab bar animation options
    var options: UIView.AnimationOptions {set get}
    /// Center item and tab bar animation spring with damping value
    var usingSpringWithDamping: CGFloat {set get}
    /// Center item and tab bar animation initial spring velocity
    var initialSpringVelocity: CGFloat {set get}
    /// Center item and tab bar animation delay
    var delay: Double {set get}
    /// Tab bar movement animation percentage
    var tabMovePercentage: CGFloat? {set get}
    /// Center item movement animation percentage
    var centerItemMovePercentage: CGFloat? {set get}
    /// Center item Sub options animation type
    var subOptionsAnimationtype: SubOptionsAnimationType {set get}
    /// Tab bar selection animation type
    var tabSelectionAnimationType: TabSelectionAnimationType {set get}
    /// Change screens with animation
    var shouldAnimateScreenChanges: Bool {set get}
}

/// NSVTabController tab bar options
public protocol NSVAnimatedTabOptions {
    /// Tab bar height
    var tabHeight: CGFloat {set get}
    /// Tab bar insets
    var tabInsets: UIEdgeInsets {set get}
    /// Tab bar background color
    var tabBackgroundColor: UIColor {set get}
    /// Tab bar item selection color
    var selectedItemColor: UIColor {set get}
    /// Tab bar item unselection color
    var unselectedItemColor: UIColor {set get}
    /// Tab bar corner radius
    var cornerRadius: CGFloat {set get}
    /// Tab bar corners
    var corners: [RadiusCorners] {set get}
    /// Tab bar shadow info
    var shadowInfo: ShadowInfo? {set get}
    /// Tab bar items
    var options: [NSVTabItemOptions] {set get}
    /// NSVTabController animation options
    var animationOptions: NSVTabAnimationOptions {set get}
    /// NSVTabController center item options
    var centerItemOptions: NSVCenterItemOptions {set get}
    /// Alpha value for background view while selecting on center item
    var coverAlpha: CGFloat {set get}
    /// NSVTabController view's background color
    var mainBackgroundColor: UIColor? {set get}
    
}

extension NSVAnimatedTabOptions {
    var tabTopInset: CGFloat {
        return centerItemOptions.insets.bottom + centerItemOptions.size.height - tabHeight
    }
}

/// NSVTabController tab bar item options
public protocol NSVTabItemOptions {
    /// Tab bar item title
    var title: String? {set get}
    /// Tab bar item image
    var image: UIImage? {set get}
    /// Tab bar item selected image
    var selectedImage: UIImage? {set get}
    /// Tab bar item insets
    var itemInsets: UIEdgeInsets {set get}
    /// Tab bar item spacing between title and image
    var spacing: CGFloat? {set get}
    /// Tab bar item title font
    var font: UIFont? {set get}
}
/// NSVTabController tab bar center item options
public protocol NSVCenterItemOptions {
    /// Center item insets
    var insets: UIEdgeInsets {set get}
    /// Center item size
    var size: CGSize {set get}
    /// Center item options
    var options: NSVTabItemOptions {set get}
    /// Center item sub options
    var subOptions: [NSCenterItemSubOptions] {set get}
    /// Center item sub options size
    var subOptionsSize: CGSize {set get}
    /// Center item background color
    var backgroundColor: UIColor {set get}
    /// Center item corner radius
    var cornerRadius: CGFloat {set get}
    /// Center item shadow
    var shadowInfo: ShadowInfo? {set get}
    /// Center item sub options layout system
    var distributionType: SubOptionsDistributionType {set get}
    /// Center item curve type
    var curveType: CurveType {set get}
}

extension NSVCenterItemOptions {
    var fullWidth: CGFloat {
        return size.width + insets.left + insets.right
    }
}

public protocol NSCenterItemSubOptions {
    var image: UIImage {set get}
    var backgroundColor: UIColor {set get}
    var cornerRadius: CGFloat {set get}
    var shadowInfo: ShadowInfo? {set get}
}

public class ShadowInfo {

    let shadowRadius: CGFloat
    let shadowOpacity: Float
    let shadowColor: UIColor
    let shadowOffset: CGSize

    public init(shadowRadius: CGFloat, shadowOpacity: Float, shadowColor: UIColor, shadowOffset: CGSize) {
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
    }
}
