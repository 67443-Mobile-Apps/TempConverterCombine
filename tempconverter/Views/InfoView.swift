// Created by Prof. H in 2022
// Part of the tempconverter project
// Using Swift 5.0
// Qapla'


import SwiftUI

struct InfoView: View {
    var body: some View {
      ZStack {
        // MARK: Background
        Color.blue
          .edgesIgnoringSafeArea(.all)
          .opacity(0.80)
        
        LinearGradient(
          gradient: Gradient(colors: [Color.white, Color.gray]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
        .opacity(0.45)
        
        // MARK: Snarky text with information
        Text("This is the ever-famous TempConverter turned into a working iOS app. This is a moment of great celebration!  People of the Earth, rejoice!")
          .font(.headline)
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
          .padding(50)
      }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
