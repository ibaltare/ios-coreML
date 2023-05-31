//
//  Animal.swift
//  CatDogML
//
//  Created by Nicolas on 30/05/23.
//

import Foundation

class Animal {
    // url for the image
    var imageUrl: String
    // image Data
    var imageData: Data?
    
    init() {
        self.imageUrl = ""
        self.imageData = nil
    }
    
    init?(json: [String: Any]) {
        //check that JSON has a url
        guard let imageUrl = json["url"] as? String else { return nil }
        
        // set the animal properties
        self.imageUrl = imageUrl
        self.imageData = nil
        
        //Download the image data
        getImage()
    }
    
    func getImage() {
        // ceate a url object
        let url = URL(string: imageUrl)
        
        //check that the url isn't nil
        guard url != nil else {
            print("Couldn't get url object")
            return
        }
        
        // get a url session
        let session = URLSession.shared
        
        //create the data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                self.imageData = data
            }
        }
        
        //start the data task
        dataTask.resume()
    }
}
