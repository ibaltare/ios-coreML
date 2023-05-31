//
//  ProgressBar.swift
//  CatDogML
//
//  Created by Nicolas on 30/05/23.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double
    var meterColor: Color {
        if value > 0.35 {
            return .green
        } else if value > 0.2 {
            return .yellow
        } else if value > 0.05 {
            return.orange
        } else {
            return .red
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                Rectangle()
                    .frame(width: CGFloat(self.value) * geometry.size.width,
                           height: geometry.size.height)
                    .foregroundColor(meterColor)
            }
        }
        .cornerRadius(45)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: 0.23)
            .previewLayout(.fixed(width: 300, height: 10))
    }
}
