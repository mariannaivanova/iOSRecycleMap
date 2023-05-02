//
//  PointViewController.swift
//  test
//
//  Created by Marianna Ivanova on 25.04.2023.
//

import UIKit

class PointViewController: UIViewController {
    
    var id: String = ""
    var pView : PointView { return self.view as! PointView}
    let point = Annotation(id: "", name: "", fractions: [], address: "", schedule: [])
    
    override func loadView() {
        self.view = PointView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateInfo(id: id)

    }
    
    func updateInfo(id: String) {
        let point = Annotation(id: "", name: "", fractions: [], address: "", schedule: [])
        let parsedPoint = point.parsePoint(id: id)
        pView.NameLabel.text = parsedPoint.name
        pView.AddressLabel.text = parsedPoint.address
        let hours = "Часы работы: " + (parsedPoint.schedule?[0] ?? " ") + "-" + (parsedPoint.schedule?[1] ?? " ")
        pView.HoursLabel.text = hours
        pView.FractionsLabel.text = parsedPoint.fractions?[0]
    }
    
    
    

}
