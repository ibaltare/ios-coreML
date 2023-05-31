//
//  ContentView.swift
//  CatDogML
//
//  Created by Nicolas on 30/05/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: AnimalModel
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Image(uiImage: UIImage(data: model.animal.imageData ?? Data()) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
            }
            
            HStack {
                Text("What is it?")
                    .font(.title)
                    .bold()
                    .padding(.leading, 10)
                Spacer()
                Button {
                    self.model.getAnimal()
                } label: {
                    Text("Next")
                        .bold()
                }
                .padding(.trailing, 10)
            }
            if #available(iOS 14.0, *) {
                ScrollView {
                    LazyVStack {
                        ForEach(model.animal.results) {
                            result in
                            AnimalRow(imageLabel: result.imageLabel,
                                      confidence: result.confidence)
                        }
                        .padding(.horizontal,10)
                    }
                }
            } else {
                List(model.animal.results) { result in
                    AnimalRow(imageLabel: result.imageLabel,
                              confidence: result.confidence)
                }
                .padding(.horizontal,10)
            }
        }
        .onAppear(perform: model.getAnimal)
        .opacity(model.animal.imageData == nil ? 0 : 1)
        .animation(.easeIn)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: AnimalModel())
    }
}
