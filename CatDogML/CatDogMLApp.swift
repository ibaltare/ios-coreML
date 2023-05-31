//
//  CatDogMLApp.swift
//  CatDogML
//
//  Created by Nicolas on 30/05/23.
//

import SwiftUI

@main
struct CatDogMLApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: AnimalModel())
        }
    }
}
