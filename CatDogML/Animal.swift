//
//  Animal.swift
//  CatDogML
//
//  Created by Nicolas on 30/05/23.
//

import Foundation
import CoreML
import Vision

struct Result: Identifiable {
    var imageLabel: String
    var confidence: Double
    var id = UUID()
}

class Animal {
    // url for the image
    var imageUrl: String
    // image Data
    var imageData: Data?
    
    // classified results
    var results: [Result]
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    //let modelFile = try! CatOrDog_1(configuration: MLModelConfiguration())
    
    init() {
        self.imageUrl = ""
        self.imageData = nil
        self.results = []
    }
    
    init?(json: [String: Any]) {
        //check that JSON has a url
        guard let imageUrl = json["url"] as? String else { return nil }
        
        // set the animal properties
        self.imageUrl = imageUrl
        self.imageData = nil
        self.results = []
        
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
                self.classifyAnimal()
            }
        }
        
        //start the data task
        dataTask.resume()
    }
    
    func classifyAnimal() {
        // get a reference to the model
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        // create an image handler
        let handler = VNImageRequestHandler(data: imageData!)
        
        // create a request to the model
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                print("couldn't classify animal")
                return
            }
            
            //update the results
            for classification in results {
                var identifier = classification.identifier
                identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                self.results.append(Result(imageLabel: identifier, confidence: Double(classification.confidence)))
            }
        }
        
        // Execute the request
        do {
            try handler.perform([request])
        } catch {
            print("invalid image")
        }
    }
}
