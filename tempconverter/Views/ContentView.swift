// Created by Prof. H in 2022
// Part of the tempconverter project
// Using Swift 5.0
// Qapla'

import SwiftUI

struct ContentView: View {

  // MARK: Setting up observer (Combine will handle reactive updates)
  @ObservedObject var viewController = ViewController()

  var body: some View {
    NavigationView {
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


        // MARK: Main Content
        VStack {
          Spacer()

          // Display converted temperature (updates automatically via Combine)
          if viewController.isConvertingCtoF {
            Text("\(viewController.convertedTempString) ºF")
              .font(.largeTitle)
              .fontWeight(.ultraLight)
          } else {
            Text("\(viewController.convertedTempString) ºC")
              .font(.largeTitle)
              .fontWeight(.ultraLight)
          }

          Spacer()

          Text("Enter Temperature:")
            .fontWeight(.bold)

          // TextField bound directly to ViewModel - Combine handles conversion automatically!
          TextField("temperature", text: $viewController.inputTempString)
            .padding(.horizontal)
            .frame(width: 200.0, height: 35.0)
            .border(Color.white, width: 0.50)
            .multilineTextAlignment(.center)
            .keyboardType(.numbersAndPunctuation)

          Spacer()

          HStack(alignment: .center) {
            Text("ºF -> ºC")
              .fontWeight(.thin)
            Toggle(isOn: $viewController.isConvertingCtoF) {
              Text("")
            }
            .labelsHidden()
            .frame(width: 50)
            .padding()
            Text("ºC -> ºF")
              .fontWeight(.thin)
          }
          .padding()

          // Note: No Convert button needed! Combine pipelines handle conversion automatically
          Text("Conversion happens automatically")
            .font(.caption)
            .italic()
            .foregroundColor(.white.opacity(0.7))

          Spacer()

          NavigationLink(destination: InfoView()) {
            Image(systemName: "info.circle")
              .foregroundColor(.white)
          }
          .padding(.bottom, 50)
        }
        .padding()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
