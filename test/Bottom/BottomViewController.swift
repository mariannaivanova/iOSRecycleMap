//
//  BottomViewController.swift
//  test
//
//  Created by Marianna Ivanova on 12.04.2023.
//

import UIKit
import DropDown

class BottomViewController: UIViewController {

    var bottomView : BottomView { return self.view as! BottomView}
    
    override func loadView() {
        self.view = BottomView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
