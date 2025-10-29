# Temp Converter Combine

This is a class demonstrate that I did using our first lab, TempConverter, and refactoring it so it uses Apple's reactive framework, Combine.  Below are the original instructions as a reference, but I have also included a `key_changes.md` file highlighting some of the changes I went over in class.  _Qapla'_

---


## Lab 1: TempConverter

This lab will build off our TempConverter that we worked with in [67-272](67272.cmuis.net/labs/2) and in our [previous lab](67443.cmuis.net/labs/1) and turn it into a functional iOS app. The app will take some user input, convert it (if valid) from either Celsius to Fahrenheit or Fahrenheit to Celsius. There will also be a toggle switch to change the direction of the conversion and a simple "info" page that describes your app. This is what your app might look like when you are done:

<p float="left" align="center">
  <img src="https://i.imgur.com/9vU4pSA.png" width="50%"/>
</p>


One of the main goals of this lab is to give you an introduction into [SwiftUI](https://developer.apple.com/xcode/swiftui/). SwiftUI is another way of building user interfaces in iOS (other than the Storyboards you used last week in lab).

Part 1: App creation and model building
---

1. Create a new project, a `Single View App`. The Product Name Should be `TempConverterApp`. Select `SwiftUI` for the Use Interface. (Do not check `Core Data`, `Unit Tests` or `UI Tests`.)

1. Create three groups (folders): one called Models, one called Controllers, and the last called Views.  Move the ContentView and the tempconverterApp into the Views folder.

2. Create a new Swift file inside the Models folder called `TempConverter.swift` to hold your model.

   The model should:

   * Be able to convert Fahrenheit temperatures to Celsius
   * Be able to convert Celsius temperatures to Fahrenheit
   * Have a variable to interact with the view controller; to pass the converted temperature as an `Int`. Should be the final temperature after conversion or should be `nil` if the temperature the user inputs is invalid either because it is below absolute zero or it is not a number.

   (There is a partial model outline at the end of the lab if you are stuck, but I know you can figure out an appropriate model on your own given your previous experience, and I would encourage you to do so to maximize your learning.)

3. After you have built your model, check out the boilerplate code at the bottom of the instructions. This time, we separate out the functions for Fahrenheit -> Celsius and Celsius -> Fahrenheit for fewer conditionals in our code and more readable logic. You don't have to implement your model like this, but at least take a look to get a sense of the differences in architecture between this model and the one we wrote last week.


Part 2 -- Initial interface building
---
4. Open the `ContentView.swift` to work on the interface. Let's mock up the interface using SwiftUI. For right now, let's assume that all temperature conversions are from Celsius to Fahrenheit.

   This is the basic idea of what we're looking to do:

   <img src="https://i.imgur.com/PFpqEzW.png" width="45%"/>

1. By default you are given a `VStack`, which is a view that arranges its children in a vertical line [[VStack docs](https://developer.apple.com/documentation/swiftui/vstack)], and within that you have an `Image`("globe") and some `Text`("Hello, world"). You can see how this lays out in the preview on the right side of the screen.  For now, let's remove all the content within the `VStack`

2. Now inside the `VStack`, create a `HStack`, a view that arranges its children in a horizontal line [[HStack docs](https://developer.apple.com/documentation/swiftui/hstack)]. We will use this `HStack` to align the converted temperature and its label.

3. Inside this `HStack`, create 2 `Text` elements (1 for the converted temperature and 1 for the unit; later on when we can toggle the units, the unit label will change independently of the converted temperature, so it is better to keep them separate from the start). You can do this by typing `Text("Temp")` and `Text("ºF")` in `HStack` the editor or you could use the `+` button in the top right, search for `Text` and drag the element directly into the code editor or the canvas. (bonus tip! easily type `º` with the option key + 0)

4. In the same `VStack` (but not in the `HStack`) add a `Text` element with the text `"Enter Temperature:"`.

5. Create another `HStack` under this `Text` element for input temperature and its unit. Add a `TextField` and a `Text` element to this `HStack`. Don't worry about the `text: Value` yet.

6. Try to figure out how to resize the `TextField`. (Hint: Command + click on the element in the editor and select `Show SwiftUI Inspector...`.)

7. Create a `Button` inside the `VStack` but not in any `HStack`. Don't worry about the `action` right now, but do set the text to `Convert`.

8. Add spacing as necessary by using `Spacer()` between elements in the `VStack`.

9. By this point, this is what the code inside your `body` should approximately look like (may differ slightly with the button depending on version of iOS being used):

      ```swift
      VStack {
        Spacer()
        HStack {
          Text("Temp")
          Text("ºF")
        }
        Spacer()
        Text("Enter Temperature:")
        HStack {
          TextField("Temp", text: Value)
          .frame(width: 90.0)
          .multilineTextAlignment(.center)
          Text("ºC")
        }
        Spacer()
        Button(action: {}) {
          Text("Convert")
        }
        Spacer()
      }
      ```

10. Play around with the styling (especially with the SwiftUI Inspector) to make the app a little more appealing. You can change the background color to yellow by creating a `ZStack` outside of your main `VStack` and adding the line `Color.blue.edgesIgnoringSafeArea(.all).opacity(0.80)` just inside the `ZStack` before all the main content. (Hint: You can chain `.opacity` to the end of the previous statement to make the color less intense.) Make sure to change the AppIcon to the icons provided in [this folder](http://67442.cmuis.net/files/67442/lab4/resources_for_lab_4.zip). (Ignore everything except the AppIcon files; see [last weeks's lab](https://67443.cmuis.net/labs/1) if you don't remember how to set the AppIcon.) Try to get your app to look something like this:

       <img src="https://i.imgur.com/sqBVBhp.png" width="45%"/>

       Use `.border(Color.white)` after the `TextField` to get the outline.

       To get the white background behind the button use the following code directly after the `Button`:

       ```swift
       .padding(.all)
       .background(Color.white)
       .cornerRadius(15.0)
       ```

       And here is the code for the gradient (goes after setting the background color):

       ```swift
       LinearGradient(
         gradient: Gradient(colors: [Color.white, Color.gray]),
         startPoint: .topLeading,
         endPoint: .bottomTrailing)
       .edgesIgnoringSafeArea(.all)
       .opacity(0.45)
       ```

Part 3 -- Creating an observable controller
---

5. Once you are happy with the way your interface looks, let's get started on the view controller. Create a new Swift file called `ViewController.swift` inside the Controllers folder. Create a `class` named `ViewController` and make it an `ObservableObject` like this:

   ```swift
   class ViewController: ObservableObject { }
   ```

   You can read more about ObservableObjects [here](https://developer.apple.com/documentation/combine/observableobject), and we will talk more about them later in the semester with [Protocol-Oriented Programming](https://developer.apple.com/videos/play/wwdc2015/408/), but the important thing to know is that ObservableObjects will allow the view to be notified of any changes that happen in the model and allow the view to refresh automatically and change accordingly to reflect the new data.

1. In our `ViewController`, create an instance of `TempConverter` to work with.

2. Next, we are going to create some fields that will interface with our view. We are going to use `@Published` so they will update our view when they are modified. They should look like this:

      ```swift
      @Published var inputTempString: String = "Temp"
      @Published var convertedTempString: String = "Temp"
      @Published var isConvertingCtoF: Bool = true
      ```

      Take a moment to look these over and understand what they do.
      
      As we look over this, we see the first is related to the temperature that we are going to input into the textfield box. The second is related to the large display where we show the results of the conversion.  The third is also related to the interface -- it will be a toggle switch that allows us to switch units -- but that we haven't added yet because we needed this controller first to avoid errors.  The key idea here is that these published variables get updated and any interface that subscribes to this will get that new data as soon as it is available and/or changes.
      
1. We need a method `setInputTempString()` which will take the input string for temperature as an argument and set the property `inputTempString`. 

1. We need a method `setConvertedTempString()` which get the converted temp from the instance of `TempConverter()` we created and if it exists, will set our `convertedTempString` variable to a string of that value and otherwise set it to "N/A"

1. To finish off our setters, we one to set the units in the instance of `TempConverter()` we created.  Because you are really new to Swift and enums, assuming you've followed our model suggestions, the following code will work: 

    ```swift
    func setInputTempUnit() {
      isConvertingCtoF ? tempConverter.setInputUnit(.celsius) : tempConverter.setInputUnit(.fahrenheit)
    }
    ```

1. Now we need to write a `convert()` method for the controller that handles the process of converting a temperature. (As we discussed in 67-272, the actual logic of making the conversion will happen in the model object.)  Between the methods in our model and methods we've written in the controller, this method is pretty straightforward and easy to write.  To implement it, you must:

  - cast the `inputTempString` into a `Int`.  However, since that is an optional and may return nil, we can use nil coalescing to set it to -500 automatically if it is nil. 
  - set the input temp units, using our method in the controller
  - set the input temp in the `tempConverter` object
  - use that model object to `convert` the temp
  - update the converted temp string, using our method in the controller

1. Ideally, we'd have tests for models and controllers to verify, but that will have to come later.  In the meantime, inspect this code one last time and ask for TA help if you are uncertain.


Part 4 -- Tying the controller and view together
---

6. Now let's go back and work on integrating our views with our view controller. Open the `ContentView.swift`.

1. Add the following lines just under `Struct ContentView: View`:

      ```swift
      @ObservedObject var viewController = ViewController()
      @State var inputTemp: String = ""
      ```

      We will access our `ViewController` using the first line, and the second is required for our `TextField`.  Because the viewController is an observed object, any time one of its published properties changes, this view will be notified so the appropriate updates can occur. 
 Similarly, the `@State` is an internal property wrapper struct that just wraps any value to make sure your view will refresh or redraw whenever that value changes.
      
1. As we mentioned earlier, we need some way to toggle between unit types.  Now that we have the view controller, we can add a toggle switch between the `Spacer()` and the `Button()` with the following code:

    ```swift
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
    ```

      The dollar sign in this instance is creating a binding between this toggle controller and our `inConvertingCtoF` property in the controller.  As the toggle switches, so will the property in our controller.

2. Now we need to change the converted temperature label, which we previously had as a `HStack`, with one part being "Temp" and the other being degrees Fahrenheit.  Now we want to change it to the controller's `convertedTempString` and alter the units accordingly.  It's slightly less code to write it as follows:

  ```swift
  if viewController.isConvertingCtoF {
    Text("\(viewController.convertedTempString) ºF")
      .font(.largeTitle)
      .fontWeight(.ultraLight)
  } else {
    Text("\(viewController.convertedTempString) ºC")
      .font(.largeTitle)
      .fontWeight(.ultraLight)
  }
  ```
  
  However, if you want, you can keep the `HStack`, set the temp, and change the units depending on the value of `isConvertingCtoF`.

3. In the `TextField`, change `text: Value` to `text:$inputTemp`.  Again, the dollar sign will create a binding the `@State` property wrapper and the contents of this text field.  If you want to dive into property wrappers in more detail, Apple has an [excellent video on this subject](https://developer.apple.com/videos/play/wwdc2019/415/?time=1412).

4. Within the `action` block of the convert `Button`, update the values in our instance of `ViewController()` from the `TextField` (the controller has a method for that) and call the `convert` function from our instance of `ViewController()`.

5. Now you can test your app.  You can deploy it on an iOS device if you'd like.


Part 5 -- Creating a multi-screen app
---

8. It would be nice to start working towards apps that have more than one screen. (Last week's app was single-screen and so far, so is this one.) To do that, let's create a simple info page for the app that we can navigate to. This will provide us with a brief introduction into [Navigation Views](https://developer.apple.com/documentation/swiftui/navigationview).

1. Wrap everything in the `body` of your `ContentView` in a `NavigationView`.

2. Create a new `SwiftUI View` called `InfoView.swift` inside the Views folder. Style this view however you would like and add some brief text.  If you need some elegant text and can't think of any off the top of your head, the following might do in a pinch: "This is the ever-famous TempConverter turned into a working iOS app. This is a moment of great celebration!  People of the Earth, rejoice!"

3. Add the following `NavigationLink` right after the final `Spacer()` in `ContentView.swift`.

      ```swift
      NavigationLink(destination: InfoView()) {
        Image(systemName: "info.circle")
          .foregroundColor(.white)
      }
      .padding(.bottom, 50)
      ```

      Run this and see how the back button is automatically created for you when you use a `NavigationView`!

Now you have an information button and have successfully linked to another page and your app should be fully functional; congrats on creating your first iOS app using SwiftUI!  We will continue to use this framework for the rest of the semester, so you will become much more familiar with it over time. Qapla'

Addendum -- Model Starter Code
---

If you need a little push with the model code, here is some starter code with comments to guide you:

 ```swift
 class TempConverter {
   
 	// Not essential, but makes code a little cleaner later
   	// See the Enums playground from lecture 2 for more on enums
   	enum TempUnit: String {
     case fahrenheit = "ºF"
     case celsius = "ºC"
  	}
     
   // MARK: Fields
   var isConvertingCtoF: Bool = true
   var inputTemp: Int = 0
   var convertedTemp: Int?
     
   // Checks if the input temperature is below absolute zero
   func isBelowAbsoluteZero() -> Bool { }
     
   // Set the input units (using switch-case instead of if-else, although both work)
   func setInputUnit(_ tempUnit: TempUnit) { }
     
 	// Setter and getter methods
 	func setInputTemp(_ temp: Int) {
     inputTemp = temp
   }

   func getConvertedTemp() -> Int? {
     return convertedTemp
   }
     
   // Separated functions for temperature conversion by unit
   func convertCtoF() { }
   func convertFtoC() { }
     
   // Checks that the value is a valid temp using a guard statement to check if above absolute zero (return nil if not) and calls the appropriate conversion function above
   func convert() { }
 }
 ```
