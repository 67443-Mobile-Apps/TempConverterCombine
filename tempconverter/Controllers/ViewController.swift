// Created by Prof. H in 2022
// Part of the tempconverter project
// Using Swift 5.0
// Qapla'
// Updated to use Combine pipelines

import Foundation
import Combine

class ViewController: ObservableObject {

  // MARK: Model instance
  @Published var tempConverter: TempConverter = TempConverter()


  // MARK: Published Properties
  @Published var inputTempString: String = ""
  @Published var convertedTempString: String = "--"
  @Published var isConvertingCtoF: Bool = true


  // MARK: Private Properties
  private var cancellables = Set<AnyCancellable>()


  // MARK: Initialization
  init() {
    setupCombinePipelines()
  }


  // MARK: Combine Pipeline Setup
  private func setupCombinePipelines() {
    // Pipeline 1: Convert input string to integer and update model
    // Demonstrates: debounce, compactMap, removeDuplicates, sink
    $inputTempString
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)  // Wait for user to stop typing
      .compactMap { Int($0) }   // Filter out non-integer inputs
      .removeDuplicates()       // Only process when value actually changes
      .sink { [weak self] temp in
        self?.tempConverter.inputTemp = temp
      }
      .store(in: &cancellables)


    // Pipeline 2: Sync conversion direction between ViewModel and Model
    // Demonstrates: sink for side effects
    $isConvertingCtoF
      .sink { [weak self] isConverting in
        self?.tempConverter.isConvertingCtoF = isConverting
      }
      .store(in: &cancellables)


    // Pipeline 3: Convert model's output to display string
    // Demonstrates: map operator for transformation
    tempConverter.$convertedTemp
      .map { temp -> String in
        guard let temp = temp else { return "N/A" }
        return String(temp)
      }
      .assign(to: &$convertedTempString)
  }
}
