//
//  Service.swift
//  ScheduleApp
//
//  Created by Renato Mateus on 24/02/21.
//

import Foundation
import UIKit
import MapKit

class Service: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var nameService: String!
    var descriptionService: String!
    var imageService: UIImage!
    var location: String!
    
    override init() {
        super.init()
    }
}
