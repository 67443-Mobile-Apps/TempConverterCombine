# Temperature Converter - Refactored with Combine


To demonstrate some of the key ideas of Combine, I've taken one of our early lab assignments and refactored it so that it uses Combine -- Apple's framework for reactive programming.  Below I've highlighted some key changes and core concepts that you ought to pay attention to as you review this code on your own. (We've gone through it in class, but assuming you'll go through it again later. 😉)

---

## Key Changes

### **TempConverter.swift** (Model)
- Now uses `@Published` properties for reactive state (`inputTemp`, `isConvertingCtoF`, `convertedTemp`)
- Uses **`Publishers.CombineLatest`** to combine two input streams (temperature + conversion direction)
- Uses **`.map`** operator to transform and validate inputs
- Uses **`.assign(to:)`** to automatically update the converted temperature
- Conversion happens automatically when any input changes - no manual `convert()` call needed!

### **ViewController.swift** (ViewModel)
Demonstrates three separate Combine pipelines:

1. **Pipeline 1** - Input validation & transformation:
   - **`.debounce(for:)`** - waits 300ms after user stops typing
   - **`.compactMap`** - filters out non-integer inputs and transforms String → Int
   - **`.removeDuplicates()`** - only processes actual value changes
   - **`.sink`** - subscribes and updates the model

2. **Pipeline 2** - Syncing toggle state:
   - **`.sink`** - passes conversion direction to model

3. **Pipeline 3** - Output formatting:
   - **`.map`** - transforms optional Int to display String
   - **`.assign(to:)`** - automatically updates the UI string

### **ContentView.swift** (View)
- Removed the "Convert" button entirely - conversion now happens automatically!
- TextField bound directly to ViewModel using `$viewController.inputTempString`
- Added note about automatic conversion to highlight the reactive approach

---

## Combine Concepts Demonstrated

This refactored app is perfect for teaching these Combine concepts:

- **@Published** property wrapper
- **Publishers.CombineLatest** - combining multiple publishers
- **.map** - transforming values
- **.compactMap** - filtering and transforming
- **.debounce** - throttling/delaying events
- **.removeDuplicates** - avoiding redundant updates
- **.sink** - subscribing to publishers
- **.assign(to:)** - binding publisher output to properties
- **AnyCancellable** & **Set<AnyCancellable>** - subscription lifecycle management
- **Reactive data flow** - no imperative update calls needed



The app demonstrates true reactive programming where data flows automatically through pipelines without manual intervention.  

Qapla'
