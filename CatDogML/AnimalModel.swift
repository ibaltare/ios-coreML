//
//  AnimalModel.swift
//  CatDogML
//
//  Created by Nicolas on 30/05/23.
//

import Foundation

class AnimalModel: ObservableObject {
    
    @Published var animal = Animal()
    
    func getAnimal() {
        let stringUrl = Bool.random() ? catUrl : dogUrl
        
        // create a URL object
        let url = URL(string: stringUrl)
        
        // check that the url is not nil
        guard url != nil else {
            print("Couldn't create url object")
            return
        }
        
        // get a url session
        let session = URLSession.shared
        
        // create a data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]] {
                        let item = json.isEmpty ? [:] : json[0]
                        if let animal = Animal(json: item) {
                            DispatchQueue.main.async {
                                while animal.imageData == nil {}
                                self.animal = animal
                            }
                        }
                    }
                } catch {
                    print("Couldn't parse JSON")
                }
            }
        }
        
        // start the data task
        dataTask.resume()
    }
}
