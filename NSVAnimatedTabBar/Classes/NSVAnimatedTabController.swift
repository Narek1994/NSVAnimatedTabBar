//
//  AnimatedTabController.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 10/29/20.
//

import UIKit

public class NSVAnimatedTabController: UIViewController {

    private let animatedTab = AnimatedTab(frame: .zero)
    private let containerView = UIStackView(frame: .zero)
    private let converView = UIView(frame: .zero)
    private let pager = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var tabControllers: [UIViewController] = []
    private lazy var centerItem = AnimatedTabItem(frame: .zero)
    private var options: NSVAnimatedTabOptions?
    private var subOptionItems: [CenterItemSubOptionItem] = []
    private var isOpen = false {
        didSet {
            if delegate?.shouldOpenSubOptions() ?? true  {
                handleCenterItemTap()
                if isOpen {
                    addConverView()
                    centerItem.select(color: options?.selectedItemColor ?? .clear)
                } else {
                    removeConverView()
                    centerItem.unselect(color: options?.unselectedItemColor ?? .clear)
                }
            }
        }
    }
    private var selectedIndex = -1
    private var tabBottomConstraint: NSLayoutConstraint?
    private var centerItemBottomConstraint: NSLayoutConstraint?
    private let _bottomView = UIView(frame: .zero)

    public weak var delegate: NSVAnimatedTabControllerDelegate?
    public var tabBarSelectedIndex = 0 {
        didSet {
            select(at: tabBarSelectedIndex)
        }
    }

    public func getTabBarSelectedIndex() -> Int {
        return selectedIndex
    }

    public func configure(tabControllers: [UIViewController], with tabOptions: NSVAnimatedTabOptions) {
        self.tabControllers = tabControllers
        options = tabOptions
        animatedTab.removeFromSuperview()
        animatedTab.delegate = self
        addSubviews()
        addConstraints(options: tabOptions)
        configureTab(options: tabOptions)
        addCenterItem(options: tabOptions.centerItemOptions)
        select(at: 0)
        converView.alpha = 0
    }

    private func addSubviews() {
        view.addSubview(_bottomView)
        view.addSubview(containerView)
        view.addSubview(animatedTab)
        addPager()
    }

    private func addPager() {
        containerView.addArrangedSubview(pager.view)
        addChild(pager)
        pager.didMove(toParent: self)
    }

    private func addConverView() {
        converView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(covertViewTapped)))
        converView.translatesAutoresizingMaskIntoConstraints = false
        converView.backgroundColor = .black
        view.insertSubview(converView, aboveSubview: containerView)
        converView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        converView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        converView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        converView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func removeConverView() {
        converView.alpha = 0
        converView.removeFromSuperview()
    }

    private func addConstraints(options: NSVAnimatedTabOptions) {
        animatedTab.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        animatedTab.leftAnchor.constraint(equalTo: view.leftAnchor, constant: options.tabInsets.left).isActive = true
        animatedTab.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -options.tabInsets.right).isActive = true
        animatedTab.heightAnchor.constraint(equalToConstant: options.tabHeight).isActive = true
        animatedTab.bottomAnchor.constraint(equalTo: _bottomView.topAnchor, constant: 1).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -options.tabHeight).isActive = true
        _bottomView.translatesAutoresizingMaskIntoConstraints = false
        _bottomView.heightAnchor.constraint(equalToConstant: view.bottomPadding).isActive = true
        _bottomView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: options.tabInsets.left).isActive = true
        tabBottomConstraint = _bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -options.tabInsets.bottom)
        tabBottomConstraint?.isActive = true
        _bottomView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -options.tabInsets.right).isActive = true
        _bottomView.backgroundColor = options.tabBackgroundColor
    }

    private func configureTab(options: NSVAnimatedTabOptions) {
        animatedTab.addTabs(with: options)
    }

    private func addCenterItem(options: NSVCenterItemOptions) {
        view.addSubview(centerItem)
        centerItem.translatesAutoresizingMaskIntoConstraints = false
        centerItem.widthAnchor.constraint(equalToConstant: options.size.width).isActive = true
        centerItem.heightAnchor.constraint(equalToConstant: options.size.height).isActive = true
        centerItem.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerItemBottomConstraint = centerItem.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -options.insets.bottom - (self.options?.tabInsets.bottom ?? 0))
        centerItemBottomConstraint?.isActive = true
        centerItem.configure(with: options.options, animationType: self.options?.animationOptions.tabSelectionAnimationType ?? .none)
        addCenterItemSubOptions(options: options)
        centerItem.backgroundColor = options.backgroundColor
        centerItem.set(cornerRadius: options.cornerRadius, shadowInfo: options.shadowInfo)
        centerItem.onTap = { [weak self] in
            self?.isOpen.toggle()
        }
    }

    private func addCenterItemSubOptions(options: NSVCenterItemOptions) {
        for (index, option) in options.subOptions.enumerated() {
            let item = CenterItemSubOptionItem(frame: .zero)
            item.set(options: option)
            view.insertSubview(item, aboveSubview: containerView)
            item.translatesAutoresizingMaskIntoConstraints = false
            item.widthAnchor.constraint(equalToConstant: options.subOptionsSize.width).isActive = true
            item.heightAnchor.constraint(equalToConstant: options.subOptionsSize.height).isActive = true
            item.centerYAnchor.constraint(equalTo: centerItem.centerYAnchor).isActive = true
            item.centerXAnchor.constraint(equalTo: centerItem.centerXAnchor).isActive = true
            subOptionItems.append(item)
            item.onTap = { [weak self] in
                if (self?.delegate?.shouldSelect(at: index, item: item) ?? false) {
                    self?.delegate?.didSelect(at: index, item: item)
                    self?.isOpen.toggle()
                }
            }
        }
    }

    private func handleCenterItemTap() {
        guard let mainOptions = self.options else {
            return
        }
        let centerItemOptions = mainOptions.centerItemOptions
        let itemWidth = subOptionItems.first?.frame.width ?? 0
        let itemsCount = subOptionItems.count
        let subItemsCount = CGFloat(itemsCount/2)
        var initialX: CGFloat = 0
        var offsetY: CGFloat = 0
        var multiplayerY = 0

        switch centerItemOptions.distributionType {
        case .custom(let itemsSpacing, let minYOffset, let maxYOffset):
            if itemsCount.isMultiple(of: 2) {
                initialX = -(subItemsCount * itemWidth + (subItemsCount-1) * itemsSpacing + itemsSpacing/2) + itemWidth/2
            } else {
                initialX = -((subItemsCount * itemWidth) + (subItemsCount) * itemsSpacing)
            }
            offsetY = (maxYOffset - minYOffset)/CGFloat(subItemsCount+1)
        }

        func applyToAll() {
            for (index, subOptionItem) in self.subOptionItems.enumerated() {
                switch centerItemOptions.distributionType {
                case .custom(let itemsSpacing, let minY, _):
                    if index != 0 {
                        initialX += itemWidth + itemsSpacing
                    }
                    if index >= itemsCount/2 {
                        multiplayerY = self.subOptionItems.count - index - 1
                    } else {
                        multiplayerY = index
                    }
                    subOptionItem.transform = !self.isOpen ? .identity : CGAffineTransform(translationX: initialX, y: -( minY + offsetY * 2 * CGFloat(multiplayerY) + centerItemOptions.size.height/2))
                }
            }
        }

        func applyByOne(item: CenterItemSubOptionItem, index: Int, duration: Double, shouldScale: Bool, onFinish: @escaping ()->Void) {
            UIView.animate(withDuration: duration, delay: mainOptions.animationOptions.delay, usingSpringWithDamping: mainOptions.animationOptions.usingSpringWithDamping, initialSpringVelocity: mainOptions.animationOptions.initialSpringVelocity, options: mainOptions.animationOptions.options, animations: {
                switch centerItemOptions.distributionType {
                case .custom(let itemsSpacing, let minY, _):
                    if index != 0 {
                        initialX += itemWidth + itemsSpacing
                    }
                    if index >= itemsCount/2 {
                        multiplayerY = self.subOptionItems.count - index - 1
                    } else {
                        multiplayerY = index
                    }
                    var newTransform = !self.isOpen ? .init(translationX: 0, y: 0) : CGAffineTransform(translationX: initialX, y: -( minY + offsetY * 2 * CGFloat(multiplayerY) + centerItemOptions.size.height/2))
                    if shouldScale {
                        if self.isOpen {
                            newTransform = newTransform.concatenating(CGAffineTransform(scaleX: 1, y: 1))
                        } else {
                            newTransform = newTransform.concatenating(CGAffineTransform(scaleX: 0.01, y: 0.01))
                        }
                    }
                    item.transform = newTransform
                }
                self.view.layoutIfNeeded()
            }, completion: { _ in
                if !self.isOpen {
                    item.transform = .identity
                }
                if self.isOpen {
                    if index + 1 >= self.subOptionItems.count {
                        onFinish()
                    }
                } else {
                    if index - 1 < 0 {
                        onFinish()
                    }
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + duration/3) {
                if let index = self.subOptionItems.firstIndex(of: item) {
                    if self.isOpen {
                        if index + 1 < self.subOptionItems.count {
                            applyByOne(item: self.subOptionItems[index + 1], index: index + 1, duration: duration, shouldScale: shouldScale, onFinish: onFinish)
                        }
                    } else {
                        if index - 1 >= 0 {
                            applyByOne(item: self.subOptionItems[index - 1], index: index - 1, duration: duration, shouldScale: shouldScale, onFinish: onFinish)
                        }
                    }
                }
            }
        }

        switch mainOptions.animationOptions.subOptionsAnimationtype {
        case .basic:
            UIView.animate(withDuration: mainOptions.animationOptions.mainAnimationDuration, delay: mainOptions.animationOptions.delay, usingSpringWithDamping: mainOptions.animationOptions.usingSpringWithDamping, initialSpringVelocity: mainOptions.animationOptions.initialSpringVelocity, options: mainOptions.animationOptions.options, animations: {
                applyToAll()
                self.animateMainViews()
                self.view.layoutIfNeeded()

            }, completion: nil)
        case .fading(let duration):
            subOptionItems.forEach({$0.alpha = self.isOpen ? 0 : 1})
            if isOpen {
                applyToAll()
            }
            view.isUserInteractionEnabled = false
            makeFading(item: isOpen ? subOptionItems.first! : subOptionItems.last!, duration: duration, onFinish: {
                if !self.isOpen {
                    applyToAll()
                }
                self.view.isUserInteractionEnabled = true
            })
            UIView.animate(withDuration: mainOptions.animationOptions.mainAnimationDuration, delay: mainOptions.animationOptions.delay, usingSpringWithDamping: mainOptions.animationOptions.usingSpringWithDamping, initialSpringVelocity: mainOptions.animationOptions.initialSpringVelocity, options: mainOptions.animationOptions.options, animations: {
                self.animateMainViews()
                self.view.layoutIfNeeded()
            })
        case .movingByOne(let duration, let shouldScale):
            view.isUserInteractionEnabled = false
            if shouldScale && isOpen {
                subOptionItems.forEach({$0.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)})
            }
            applyByOne(item: isOpen ? subOptionItems.first! : subOptionItems.last!, index: isOpen ? 0 : subOptionItems.count - 1, duration: duration, shouldScale: shouldScale, onFinish: {
                self.view.isUserInteractionEnabled = true
            })
            UIView.animate(withDuration: mainOptions.animationOptions.mainAnimationDuration, delay: mainOptions.animationOptions.delay, usingSpringWithDamping: mainOptions.animationOptions.usingSpringWithDamping, initialSpringVelocity: mainOptions.animationOptions.initialSpringVelocity, options: mainOptions.animationOptions.options, animations: {
                self.animateMainViews()
                self.view.layoutIfNeeded()
            })
        }
    }

    private func select(at index: Int) {
        if index == selectedIndex {
            return
        }
        let selectedController = tabControllers[index]
        let direction: UIPageViewController.NavigationDirection = selectedIndex < index ? .forward : .reverse
        let previusSelectedIndex = selectedIndex
        selectedIndex = index
        pager.setViewControllers([selectedController], direction: direction, animated: options?.animationOptions.shouldAnimateScreenChanges ?? false, completion: nil)
        if let options = options {
            if previusSelectedIndex != -1 {
                animatedTab.unSelect(index: previusSelectedIndex, unselectedColor: options.unselectedItemColor)
            }
            animatedTab.select(index: index, selectedColor: options.selectedItemColor)
        }
        if let backgroundColor = options?.mainBackgroundColor {
            view.backgroundColor = backgroundColor
        } else {
            if options?.animationOptions.shouldAnimateScreenChanges ?? false {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.backgroundColor = selectedController.view.backgroundColor
                }, completion:nil)
            } else {
                view.backgroundColor = selectedController.view.backgroundColor
            }
        }
    }

    private func animateMainViews() {
        guard let mainOptions = options else {
            return
        }
        if let tabMove = mainOptions.animationOptions.tabMovePercentage {
            if !isOpen {
                tabBottomConstraint?.constant = -mainOptions.tabInsets.bottom
            } else {
                tabBottomConstraint?.constant = view.bottomPadding + (animatedTab.frame.height*tabMove)
            }
        }
        if let centerItemMove = mainOptions.animationOptions.centerItemMovePercentage {
            if !isOpen {
                centerItemBottomConstraint?.constant = -mainOptions.centerItemOptions.insets.bottom-mainOptions.tabInsets.bottom
            } else {
                centerItemBottomConstraint?.constant = -(mainOptions.centerItemOptions.insets.bottom + (mainOptions.centerItemOptions.size.height*centerItemMove))
            }
        }
        if isOpen {
            converView.alpha = options?.coverAlpha ?? 0
        }
    }

    private func makeFading(item: CenterItemSubOptionItem, duration: Double, onFinish: @escaping ()->Void) {
        UIView.animate(withDuration: duration) {
            item.alpha = self.isOpen ? 1 : 0
        } completion: { (_) in
            if let index = self.subOptionItems.firstIndex(of: item) {
                if self.isOpen {
                    if index + 1 >= self.subOptionItems.count {
                        onFinish()
                    } 
                } else {
                    if index - 1 < 0 {
                        onFinish()
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration/3) {
            if let index = self.subOptionItems.firstIndex(of: item) {
                if self.isOpen {
                    if index + 1 < self.subOptionItems.count {
                        self.makeFading(item: self.subOptionItems[index + 1], duration: duration, onFinish: onFinish)
                    }
                } else {
                    if index - 1 >= 0 {
                        self.makeFading(item: self.subOptionItems[index - 1], duration: duration, onFinish: onFinish)
                    }
                }
            }
        }
    }

    @objc private func covertViewTapped() {
        isOpen.toggle()
    }
}

extension NSVAnimatedTabController: AnimatedTabDelegate {
    func shouldSelect(at index: Int, item: AnimatedTabItem) -> Bool {
        return delegate?.shouldSelect(at: index, item: item, tabController: tabControllers[index]) ?? true
    }

    func didSelect(at index: Int, item: AnimatedTabItem) {
        if index != selectedIndex {
            select(at: index)
            delegate?.didSelect(at: index, item: item, tabController: tabControllers[index])
        }
    }
}
