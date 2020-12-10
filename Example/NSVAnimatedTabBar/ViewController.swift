//
//  ViewController.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 10/29/20.
//

import UIKit
import NSVAnimatedTabBar

class ViewController: UIViewController {

    @IBOutlet var containerStackView: UIStackView!
    let controller = NSVAnimatedTabController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.delegate = self
        controller.configure(tabControllers: [getController(index: 1, color: .red),getController(index: 2, color: .green),getController(index: 3, color: .white),getController(index: 4, color: .cyan)],
                             with: DefaultAnimatedTabOptions())
        containerStackView.addArrangedSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
    }

    func getController(index: Int, color: UIColor) -> UIViewController {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ViewController") as! SimpleViewController
        controller.text = index.description
        controller.backgroundColor = color
        return controller
    }
}

extension ViewController: NSVAnimatedTabControllerDelegate {

    func shouldOpenSubOptions() -> Bool {
        return true
    }

    func shouldSelect(at index: Int, item: CenterItemSubOptionItem) -> Bool {
        return true
    }

    func didSelect(at index: Int, item: CenterItemSubOptionItem) {
        print(index)
    }

    func shouldSelect(at index: Int, item: AnimatedTabItem, tabController: UIViewController) -> Bool {
        return true
    }

    func didSelect(at index: Int, item: AnimatedTabItem, tabController: UIViewController) {
        print(index)
    }
}
