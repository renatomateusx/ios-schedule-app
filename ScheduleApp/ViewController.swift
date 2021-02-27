//
//  ViewController.swift
//  ScheduleApp
//
//  Created by Renato Mateus on 24/02/21.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    @IBOutlet weak var viewServiceDetail: UIView!
    @IBOutlet weak var labelServiceName: UILabel!
    @IBOutlet weak var labelServiceDescription: UILabel!
    @IBOutlet weak var labelStreet: UILabel!
    @IBOutlet weak var imageService: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var currentCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        viewServiceDetail.isHidden = true
        initializeMap()
    }
    
    func initializeMap()
    {
        if(CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            let ohauCenter = CLLocation(latitude: -12.9396, longitude: -38.3416)
            let region = MKCoordinateRegion(center: ohauCenter.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
            mapView.setCameraZoomRange(zoomRange, animated: true)
            
            
        }
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            mapView.setRegion(zoomRegion, animated: true)
    }
    
    
    func addAnnotationService(){
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        points.append(CLLocationCoordinate2D(latitude: -12.9396, longitude: -38.3416))
        let annotation = CustomAnnotation()
        annotation.coordinate = points[0]
        annotation.title = "Marcos André"
        annotation.subtitle = "Cabeleleiro"

        let service = Service()
        service.descriptionService = annotation.subtitle
        service.nameService = annotation.title
        service.location = "Rua Carlos Machado, 332"
        service.imageService = UIImage(named: "salon_marcos")
        annotation.service = service
        mapView.addAnnotation(annotation)
    
    }
    
    func addAnnotationUser(location: CLLocationCoordinate2D){
        let annotation = CustomAnnotation()
        annotation.coordinate = location
        annotation.title = "User Location"
        annotation.subtitle = "Location User"
        annotation.service = nil
        mapView.addAnnotation(annotation)
    }
    
    
    @objc func openCard(service: Service){
        
        labelServiceName.text = service.nameService
        labelServiceDescription.text = service.descriptionService
        labelStreet.text = service.location
        imageService.image = service.imageService
        imageService.layer.cornerRadius = imageService.layer.frame.size.width / 2
        imageService.layer.masksToBounds = true
        imageService.clipsToBounds = true
        viewServiceDetail.backgroundColor = .white
        viewServiceDetail.isHidden = false
        UIView.animate(withDuration: 1)
        {
            self.viewServiceDetail.frame = CGRect(x: self.viewServiceDetail.frame.minX, y: self.view.frame.midY + 50, width: self.viewServiceDetail.frame.width, height:  self.viewServiceDetail.frame.height)
        }
    }

    
    
    @IBAction func hideCard(_ sender: UIButton) {
        UIView.animate(withDuration: 1)
        {
            
            self.viewServiceDetail.frame = CGRect(x: self.viewServiceDetail.frame.minX, y: self.view.frame.maxY, width: self.viewServiceDetail.frame.width, height:  self.viewServiceDetail.frame.height)
        }
        //self.viewServiceDetail.isHidden = true
    }
  
    
    @IBAction func btnDetails(_ sender: UIButton) {
        print("Detailing the service")
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {return}
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotationService()
            addAnnotationUser(location: latestLocation.coordinate)
        }
        currentCoordinate = latestLocation.coordinate
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if(manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse){
            initializeMap()
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation) {
            let userIdentifier = "UserLocation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UserLocation")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserLocation")
            }
            annotationView?.image = imageReturn(imageString: "user_location")
            return annotationView
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if annotation.title == "Marcos André" {
            annotationView?.image = imageReturn(imageString: "salon_location")
        }
        //annotationView?.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation Called")
        let service = view.annotation as! CustomAnnotation
        print(service.service.debugDescription)
        openCard(service: service.service)
        
    }
    
    func imageReturn(imageString:String) -> UIImage{
        
        let image = UIImage(named: imageString)
        let resized = CGSize(width: 60, height: 60)
        UIGraphicsBeginImageContext(resized)
        image?.draw(in: CGRect(origin: .zero, size: resized))
        let resizedimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedimage!
    }
}

class CustomAnnotation: MKPointAnnotation{
    var service:Service!
}
    
//
//    if annotationView == nil {
//        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        annotationView?.canShowCallout = false
//        let image = UIImage(named: "img5")
//        let resized = CGSize(width: 60, height: 60)
//        UIGraphicsBeginImageContext(resized)
//        image?.draw(in: CGRect(origin: .zero, size: resized))
//        let resizedimage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        annotationView?.image = resizedimage
//        annotationView?.frame.size.height = 50
//        annotationView?.frame.size.width = 50
//
//        let button = CustomButton(type: .detailDisclosure)
//        button.service = Service()
//        button.service.coordinate = annotation.coordinate
//        button.service.nameService = annotation.title as! String
//
////            button.addTarget(self, action: #selector(openCard), for: .touchUpInside)
////            annotationView?.detailCalloutAccessoryView = button
//    } else {
//        annotationView?.annotation = annotation
//    }

    

