//
//  ViewController.swift
//  test
//
//  Created by Marianna Ivanova on 09.04.2023.
//

import UIKit
import MapKit
import SnapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  
    
    var viewController = BottomViewController()
    
    var a = CLLocation()
    
    struct PointJSON : Decodable {
        var isSucess: Bool?
        var data: DataJSON?
        
    }
    
    struct DataJSON : Decodable {
        var totalResults: Int?
        var points: Array<PointData>?
    }
    
    var d = Array<String>()
    
    struct PointData : Decodable {
        var pointId : Int?
        var address: String?
        var addressDescription: String?
        var pointDescription: String?
        var geom: String?
        var precise: String?
        var restricted: Bool?
        var title: String?
        var scheduleDescription: String?
        var fractions: Array<Fraction>?
        var photos: Array<Photo>?
        var rating: Rating?
        var businesHoursState: State?
        var numberOfComments: Int?
        var schedule: Array<Schedule>?
        var validDates: Array<String>?
        var `operator`: Operator?
        var lastUpdate: String?
        var moderators: Array<String>?
        var comments: Array<Comment>?
    }
    
    struct Fraction : Decodable {
        var id: Int?
        var name: String?
        var color: String?
        var icon: String?
    }
    
    struct Photo: Decodable {
        var photo_id: Int?
        var order: Int?
        var path: String?
        var thumb: String?
    }
    
    struct Rating: Decodable {
        var likes: Int?
        var dislikes: Int?
        var score: Double?
    }
    
    struct State: Decodable {
        var state: String?
        var nextStateTime: String?
    }
    
    struct Schedule: Decodable {
        var dow: Int?
        var opens: Array<String>?
        var closes: Array<String>?
    }
    
    struct Operator: Decodable {
        var operatorId: Int?
        var title: String?
        var address: String?
        var phones: Array<String>?
        var emails: Array<String>?
        var sites: Array<String>?
    }
    
    struct Comment : Decodable {
        var commentId: Int?
        var message: String?
        var parentCommentId : Int?
        var timestamp: String?
        var user: User?
        var photoset: Array<Photo>?
        var edited: Bool?
        var commentStatus: String?
    }
    
    struct User : Decodable {
        var firstName: String?
        var surname: String?
        var avatar: String?
        var role: String?
    }
    
    struct Rectangle {
        var west : String
        var south : String
        var east : String
        var north : String
    }
    
    
    
//    private func setupMap(mapCenter: CLLocationCoordinate2D) {
//        mapView.delegate = self
//
//        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
//        let center = mapCenter
//        let mapRegion = MKCoordinateRegion(center: center, span: mapSpan)
//
//        mapView.setRegion(mapRegion, animated: true)
//    }
    

    
    private func getRectangle() -> Rectangle {
        let w = String(MKMapPoint(x: mapView.visibleMapRect.minX, y: mapView.visibleMapRect.maxY).coordinate.longitude)
        let s = String(MKMapPoint(x: mapView.visibleMapRect.minX, y: mapView.visibleMapRect.maxY).coordinate.latitude)
        let e = String(MKMapPoint(x: mapView.visibleMapRect.maxX, y: mapView.visibleMapRect.minY).coordinate.longitude)
        let n = String(MKMapPoint(x: mapView.visibleMapRect.maxX, y: mapView.visibleMapRect.minY).coordinate.latitude)
        let rect = Rectangle(west: w, south: s, east: e, north: n)
        return rect
    }
    

     func addAnnotations() {
        let VisibleRectangle = getRectangle()
        print(VisibleRectangle)
        
        guard let url = URL(string: "https://recyclemap-api-master.rc.geosemantica.ru/public/points?bbox=\(String(describing: VisibleRectangle.west))%2C\(String(describing: VisibleRectangle.south))%2C\(String(describing: VisibleRectangle.east))%2C\(String(describing: VisibleRectangle.north))&size=500&restricted=false&offset=0") else { return }
        print(url)
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in


                guard let data = data else { return }
                guard error == nil else { return }

                do {
                    let mem = try JSONDecoder().decode(PointJSON.self, from: data)
                    let coords = mem.data?.points

                    for i in coords ?? [] {
                            let coord = i.geom
                            let startSkip = "Option".count
                            let endSkip = "\")".count
                            let startIndex = coord!.index(coord!.startIndex, offsetBy: startSkip)
                            let endIndex = coord!.index(coord!.endIndex, offsetBy: -endSkip)
                            let range = startIndex...endIndex
                            let c = String(coord![range])
                        print(i.address ?? " ")

                            self.d = c.components(separatedBy: " ")
                            print(self.d)
                        
                        
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(
                                latitude: Double(self.d[1])!,
                                longitude: Double(self.d[0])!
                            )
                        annotation.title = i.title
                        print("ann ", annotation)
                        print(annotation.coordinate)
                        self.mapView.addAnnotation(annotation)
                            
                        
                        
//                            let a = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(self.d[1])!, longitude: Double(self.d[0])!))
//                        let a = MKPointAnnotation()
//                        a.coordinate = CLLocationCoordinate2D(latitude: Double(self.d[1])!, longitude: Double(self.d[0])!)
//                        a.title = ""
                           // self.mapView.addAnnotation(a)
                        
                        }


                } catch let error {
                    print(error)
                }

            }.resume()
        
        
    }
    
    
    lazy var imageV: UIImageView = {
        let image = UIImage(named: "Image 1")
        let imageView = UIImageView(image: image!)
        //imageView.frame = CGRect(x: 0, y: 0, width: 1020, height: 100)
        // 20 50
        return imageView
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("  + Пункт  ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(menuButtonDidTap), for: .touchUpInside)
        var menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }()
    
    lazy var menuButton: UIBarButtonItem = {
        var button = UIButton()
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonDidTap), for: .touchUpInside)
        var menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }()

    private lazy var searchTextField: UITextField = {
        let search = UITextField()
        search.placeholder = " 🔍 Искать по адресу или названию пункта                   "
        search.backgroundColor = .white
        search.layer.cornerRadius = 8
        return search
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
         mapView.frame = CGRect(x: 0, y: 100, width: 1080, height: 1790)
        return mapView
    }()
    
    private func searchField () {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(searchTextField.text!) {(placemarks, error)
            in
            guard let placemarks = placemarks, let location =
                    placemarks.first?.location
                    
            else {
                let alert = UIAlertController(title: "", message: "Адрес отправления не найден. Введите другой адрес.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("Адрес отправления не найден")
                return
            }
            self.a = location
        }
    }
    
    
    private lazy var locationButton: UIButton = {
        let location = UIButton()
        location.setImage(UIImage(named: "location"), for: .normal)
        location.addTarget(self, action: #selector(locationButtonDidTap), for: .touchUpInside)
        return location
    }()
    
    @objc private func locationButtonDidTap() {
        setupMap(mapCenter: CLLocationCoordinate2D(latitude:  59.9386, longitude: 30.3141))
    }
    
    private lazy var zoomInButton: UIButton = {
        let location = UIButton()
        location.setImage(UIImage(named: "zoom in"), for: .normal)
        location.addTarget(self, action: #selector(zoomInButtonDidTap), for: .touchUpInside)
        return location
    }()
    
    private lazy var zoomOutButton: UIButton = {
        let location = UIButton()
        location.setImage(UIImage(named: "zoom out"), for: .normal)
        location.addTarget(self, action: #selector(zoomOutButtonDidTap), for: .touchUpInside)
        return location
    }()
    
    @objc func zoomInButtonDidTap () {
        zoomIn()
    }
    
    @objc func zoomOutButtonDidTap () {
        zoomOut()
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
    
    func zoomIn() {
        var region: MKCoordinateRegion = mapView.region
        let center = region.center
        region.span.latitudeDelta /= 1.5
        region.span.longitudeDelta /= 1.5
        region.center = center
        
        mapView.setRegion(region, animated: true)
    }
    
    func zoomOut() {
        var region: MKCoordinateRegion = mapView.region
        let center = region.center
        region.span.latitudeDelta = min(region.span.latitudeDelta * 1.5, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 1.5, 180.0)
        region.center = center
        
        mapView.setRegion(region, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(mapView)
        view.addSubview(imageV)
        view.addSubview(locationButton)
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = addButton
        
        
        
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
        
      
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(105)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)

        }

        setupMap(mapCenter: CLLocationCoordinate2D(latitude:  55.755864, longitude: 37.617698))
        
        addAnnotations()
       // onGetTapped()
    }
    
    
    @objc func menuButtonDidTap () {
        openMapInfo()
    }

    
//    private func onGetTapped  () {
//        guard let url = URL(string: "https://recyclemap-api-master.rc.geosemantica.ru/public/points/1") else { return }
//        let session = URLSession.shared
//        session.dataTask(with: url) { data, response, error in
//            if let response = response {
//                print(response)
//            }
//
//            if let data = data {
//                print(data)
//            }
//
//        }.resume()
//
//    }
    
    private func setupMap(mapCenter: CLLocationCoordinate2D) {
        mapView.delegate = self
        
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let center = mapCenter
        let mapRegion = MKCoordinateRegion(center: center, span: mapSpan)
        
        mapView.setRegion(mapRegion, animated: true)
        
        
    }
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        guard let annotation = view.annotation as? MKPointAnnotation else { return }
//
//        presenter.placemarkDidSelect(with: annotation)
//    }
    
    
    
}

