//
//  ViewController.swift
//  test
//
//  Created by Marianna Ivanova on 09.04.2023.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController, CLLocationManagerDelegate
  //, MKMapViewDelegate
{
  
    weak var viewController1: UIViewController?
    var viewController = BottomViewController()
    var mView : MapView { return self.view as! MapView}
    
    var id: String = ""
    
    override func loadView() {
        self.view = MapView(frame: UIScreen.main.bounds)
    }

    private func getRectangle() -> Rectangle {
        let w = String(MKMapPoint(x: mView.mapView.visibleMapRect.minX, y: mView.mapView.visibleMapRect.maxY).coordinate.longitude)
        let s = String(MKMapPoint(x: mView.mapView.visibleMapRect.minX, y: mView.mapView.visibleMapRect.maxY).coordinate.latitude)
        let e = String(MKMapPoint(x: mView.mapView.visibleMapRect.maxX, y: mView.mapView.visibleMapRect.minY).coordinate.longitude)
        let n = String(MKMapPoint(x: mView.mapView.visibleMapRect.maxX, y: mView.mapView.visibleMapRect.minY).coordinate.latitude)
        let rect = Rectangle(west: w, south: s, east: e, north: n)
        return rect
    }
   
    
    func addAnnotations() {
        let VisibleRectangle = getRectangle()
        let points = Annotations(annotations: [MKPointAnnotation()])
        let parsedPoints = points.parsePoints(west: String(describing: VisibleRectangle.west), south: String(describing: VisibleRectangle.south), east: String(describing: VisibleRectangle.east), north: String(describing: VisibleRectangle.north))
        
        mView.mapView.addAnnotations(parsedPoints.annotations)
    }

    
    @objc func zoomInButtonDidTap () {
        mView.zoomIn()
        sleep(5)
        addAnnotations()
    }
    
    @objc func zoomOutButtonDidTap () {
        mView.zoomOut()
        sleep(5)
        addAnnotations()
    }
    
    @objc private func locationButtonDidTap() {
        mView.setupMap(mapCenter: CLLocationCoordinate2D(latitude: 59.9386, longitude: 30.3141))
        sleep(5)
        addAnnotations()
    }
    
    private func configureSheet() {
        
        let vc = BottomViewController()
        let navVC = UINavigationController(rootViewController: vc)

        navVC.isModalInPresentation = true
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                0.3 * context.maximumDetentValue
            }), .large()]
        }
        navigationController?.present(navVC, animated: true)
    }
    
    func openMapInfo() {
        let storyboard = UIStoryboard(name: "Sheet", bundle: nil)
        let sheetPresentationController = storyboard.instantiateViewController(withIdentifier: "BottomViewController") as! BottomViewController
        self.present(sheetPresentationController, animated: true, completion: nil)
    }
    
    func openPointInfo(id: String) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let storyboard = UIStoryboard(name: "PointInfo", bundle: nil)
        let sheetPresentationController = storyboard.instantiateViewController(withIdentifier: "PointViewController") as! PointViewController
            sheetPresentationController.id = id
            sheetPresentationController.pView.id = id
            sleep(1)
        
        self.present(sheetPresentationController, animated: true, completion: nil)
    }
    
    
    
    @objc func annotationDidTap (id: String) {
        openPointInfo(id: id)
    }
    
    
    func addTargets () {
        mView.onMenuButtonAction = { [weak self] in self?.menuButtonDidTap()}
        mView.onZoomInButtonAction = { [weak self] in self?.zoomInButtonDidTap()}
        mView.onZoomOutButtonAction = { [weak self] in self?.zoomOutButtonDidTap()}
        mView.onLocationButtonAction = { [weak self] in self?.locationButtonDidTap()}
        mView.onAddButtonAction = { [weak self] in self?.addButtonDidTap()}
        mView.onAnnotationAction = { [weak self] in self?.annotationDidTap(id: self!.mView.currentID)}
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = mView.menuButton
        navigationItem.rightBarButtonItem = mView.addButton
        addTargets()
        addAnnotations()
    }
    
    func openApplication() {
        let storyboard = UIStoryboard(name: "App", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ApplicationViewController") as! ApplicationViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func addButtonDidTap() {
        openApplication()
    }
    
    @objc func menuButtonDidTap () {
        openMapInfo()
    }
   
}
