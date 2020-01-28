//
//  Photo.swift
//  ProjectTableImagePicker50
//
//  Created by Ana Caroline de Souza on 27/01/20.
//  Copyright © 2020 Ana e Leo Corp. All rights reserved.
//

import Foundation


class Photo: Codable {
    var name : String!
    var image : String!
    var path : String!
    
    init(name: String, image: String, path: String) {
        self.name = name
        self.image = image
        self.path = path
    }
    
}
