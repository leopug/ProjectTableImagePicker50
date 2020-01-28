//
//  DetailViewController.swift
//  ProjectTableImagePicker50
//
//  Created by Ana Caroline de Souza on 27/01/20.
//  Copyright © 2020 Ana e Leo Corp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var photo : Photo?
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photoToLoad = photo {
            imageView.image = UIImage(contentsOfFile: photoToLoad.path)
        }
        
    }

}
