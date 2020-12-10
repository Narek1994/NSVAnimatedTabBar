//
//  AnimatedTabBarDelegate.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 11/1/20.
//

import UIKit

public protocol NSVAnimatedTabControllerDelegate: AnyObject {
    func shouldSelect(at index: Int, item: AnimatedTabItem, tabController: UIViewController) -> Bool
    func didSelect(at index: Int, item: AnimatedTabItem, tabController: UIViewController)
    func shouldSelect(at index: Int, item: CenterItemSubOptionItem) -> Bool
    func didSelect(at index: Int, item: CenterItemSubOptionItem)
    func shouldOpenSubOptions() -> Bool
}

extension NSVAnimatedTabControllerDelegate {
    func shouldSelect(at index: Int, item: CenterItemSubOptionItem) -> Bool {
        return true
    }
    func shouldSelect(at index: Int, item: AnimatedTabItem, tabController: UIViewController) -> Bool {
        return true
    }
}
