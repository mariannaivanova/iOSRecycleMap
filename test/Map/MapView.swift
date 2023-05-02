//
//  MapView.swift
//  test
//
//  Created by Marianna Ivanova on 25.04.2023.
//

import Foundation
import UIKit
import MapKit

final class MapView: UIView, MKMapViewDelegate {
    
    let initialLocation = CLLocation(latitude: 55.752004, longitude: 37.617734)
    let regionRadius: CLLocationDistance = 10000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupMap(mapCenter: CLLocationCoordinate2D(latitude: 55.7549676, longitude: 37.5932626))
        //centerMapOnLocation(location: initialLocation)
        
    }
    
    var mapViewC = MapViewController()
    
    
    var currentID : String = ""
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var imageV: UIImageView = {
        let image = UIImage(named: "Image 1")
        let imageView = UIImageView(image: image!)
        return imageView
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("  + Пункт  ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(self.addButtonDidTap), for: .touchUpInside)
        var menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }()
    
    var onAddButtonAction: (() -> Void)?
    @objc func addButtonDidTap () {
        onAddButtonAction?()
    }
    
    
    lazy var menuButton: UIBarButtonItem = {
        var button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(self.menuButtonDidTap), for: .touchUpInside)
        var menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }()
    
    var onMenuButtonAction: (() -> Void)?
    @objc func menuButtonDidTap () {
        onMenuButtonAction?()
    }
    
    lazy var searchTextField: UITextField = {
        let search = UITextField()
        search.placeholder = " Искать по адресу или названию пункта                   "
        search.backgroundColor = .white
        search.layer.cornerRadius = 8
        return search
    }()
    
    lazy var searchButton : UIButton = {
        let button = UIButton()
        button.setTitle(" 🔍 ", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(self.getAddress), for: .touchUpInside)
        button.backgroundColor = UIColor(white: 1, alpha: 0.7)
        return button
    }()
    
    
    @objc func getAddress()  {
        let geocoder = CLGeocoder()
        var l = CLLocation()
        
        var a = searchTextField.text
        let endSkip = ")".count
        let endIndex = a!.index(a!.endIndex, offsetBy: -endSkip)
        let range = ...endIndex
        let b = String(a![range])
        
        print(b)

            geocoder.geocodeAddressString(b) {(placemarks, error)
                in
                guard let placemarks = placemarks, let _ =
                        placemarks.first?.location

                else {
                    print("Адрес отправления не найден")
                    return
                }
                l = placemarks.first?.location ?? CLLocation()
                print("o ", l)
                self.setupMap(mapCenter: l.coordinate)
            }
    }
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 100, width: 1080, height: 1790)
        return mapView
    }()
    
    
    private lazy var locationButton: UIButton = {
        let location = UIButton()
        location.setImage(UIImage(named: "location"), for: .normal)
        location.addTarget(self, action: #selector(locationButtonDidTap), for: .touchUpInside)
        return location
    }()
    
    var onLocationButtonAction: (() -> Void)?
    @objc func locationButtonDidTap () {
        onLocationButtonAction?()
    }
    
    private lazy var zoomInButton: UIButton = {
        let location = UIButton()
        location.setImage(UIImage(named: "zoom in"), for: .normal)
        location.addTarget(self, action: #selector(zoomInButtonDidTap), for: .touchUpInside)
        return location
    }()
    
    var onZoomInButtonAction: (() -> Void)?
    @objc func zoomInButtonDidTap () {
        onZoomInButtonAction?()
    }
    
    private lazy var zoomOutButton: UIButton = {
        let location = UIButton()
        location.setImage(UIImage(named: "zoom out"), for: .normal)
        location.addTarget(self, action: #selector(zoomOutButtonDidTap), for: .touchUpInside)
        return location
    }()
    
    var onZoomOutButtonAction: (() -> Void)?
    @objc func zoomOutButtonDidTap () {
        onZoomOutButtonAction?()
    }
    
    func zoomIn() {
        let region: MKCoordinateRegion = mapView.region
        let center = region.center

        let mapSpan = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta/1.5, longitudeDelta: region.span.longitudeDelta/1.5)
        let mapRegion = MKCoordinateRegion(center: center, span: mapSpan)

        mapView.setRegion(mapRegion, animated: true)
    }

    func zoomOut() {
        var region: MKCoordinateRegion = mapView.region
        let center = region.center
        region.span.latitudeDelta = min(region.span.latitudeDelta * 1.5, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 1.5, 180.0)
        region.center = center

        mapView.setRegion(region, animated: true)
    }
    
    func setupConstraints() {
        imageV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(50)
        }
        
        locationButton.snp.makeConstraints {make in
            make.top.equalToSuperview().offset(300)
            make.centerX.equalToSuperview().offset(170)
        }
        
        zoomInButton.snp.makeConstraints {make in
            make.top.equalToSuperview().offset(370)
            make.centerX.equalToSuperview().offset(170)
        }
        
        zoomOutButton.snp.makeConstraints {make in
            make.top.equalToSuperview().offset(410)
            make.centerX.equalToSuperview().offset(170)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(105)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(50)
            make.height.equalTo(40)
            
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField)
            make.left.equalTo(searchTextField.snp.right).offset(2)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
    
    func setupViews() {
        self.addSubview(mapView)
        self.addSubview(imageV)
        self.addSubview(locationButton)
        self.addSubview(zoomInButton)
        self.addSubview(zoomOutButton)
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        
        self.addSubview(searchTextField)
        self.addSubview(searchButton)
    }
    
    
    
    func setupMap(mapCenter: CLLocationCoordinate2D) {
        mapView.delegate = self
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let center = mapCenter
        let mapRegion = MKCoordinateRegion(center: center, span: mapSpan)
        
        mapView.setRegion(mapRegion, animated: true)
        
        
    }
    
    var onAnnotationAction: (() -> Void)?
    @objc func annotationDidTap () {
        onAnnotationAction?()
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MapAnnotation
        {
            print("User tapped on annotation with title: \(annotation.title!)")
            self.currentID = annotation.id!
            annotationDidTap()

        }
    }
}
