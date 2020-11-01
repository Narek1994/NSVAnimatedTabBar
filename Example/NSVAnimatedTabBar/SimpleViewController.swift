//
//  SimpleViewController.swift
//  TabTestApp
//
//  Created by Narek Simonyan on 11/1/20.
//

import UIKit

class SimpleViewController: UIViewController {

    @IBOutlet var testLabel: UILabel!

    var text: String?
    var backgroundColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        testLabel.text = "Screen \(text ?? "")"
        view.backgroundColor = backgroundColor
    }
}
