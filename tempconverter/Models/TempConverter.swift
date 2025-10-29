// Created by Prof. H in 2022
// Part of the tempconverter project
// Using Swift 5.0
// Qapla'
// Updated to use Combine

import Foundation
import Combine

class TempConverter: ObservableObject {

  enum TempUnit: String {
    case fahrenheit = "ºF"
    case celsius = "ºC"
  }

  // MARK: Published Properties (Combine Publishers)

  @Published var inputTemp: Int = 0
  @Published var isConvertingCtoF: Bool = true
  @Published var convertedTemp: Int? = nil

  // MARK: Private Properties

  private var cancellables = Set<AnyCancellable>()


  // MARK: Initialization

  init() {
    setupCombinePipeline()
  }


  // MARK: Combine Pipeline Setup

  private func setupCombinePipeline() {
    // Combine the input temperature and conversion direction publishers
    // This demonstrates combineLatest operator
    Publishers.CombineLatest($inputTemp, $isConvertingCtoF)
      .map { [weak self] (temp, convertingCtoF) -> Int? in
        guard let self = self else { return nil }

        // Check if above absolute zero
        let isValid = self.isAboveAbsoluteZero(temp: temp, convertingCtoF: convertingCtoF)
        guard isValid else { return nil }

        // Perform conversion based on direction
        return convertingCtoF ? self.convertCtoF(temp) : self.convertFtoC(temp)
      }
      .assign(to: &$convertedTemp)  // Automatically assigns to @Published property
  }


  // MARK: Private Conversion Methods

  private func isAboveAbsoluteZero(temp: Int, convertingCtoF: Bool) -> Bool {
    switch convertingCtoF {
    case true:
      return temp > -274  // Celsius absolute zero is -273.15
    case false:
      return temp > -460  // Fahrenheit absolute zero is -459.67
    }
  }

  private func convertCtoF(_ celsius: Int) -> Int {
    return Int((Double(celsius) * 9.0 / 5.0) + 32.0)
  }

  private func convertFtoC(_ fahrenheit: Int) -> Int {
    return Int((Double(fahrenheit) - 32.0) * 5.0 / 9.0)
  }
}
