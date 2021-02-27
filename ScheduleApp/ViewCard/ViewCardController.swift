//
//  ViewCardController.swift
//  ScheduleApp
//
//  Created by Renato Mateus on 24/02/21.
//

import UIKit

class ViewCardController: UIViewController {

    @IBOutlet weak var labelNameFantasia: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var selectedService: Service!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let myService = selectedService {
            self.labelDescription.text = myService.descriptionService
            self.labelNameFantasia.text = myService.nameService
        }
    }

    @IBAction func buttonDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
