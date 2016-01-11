# SMASaveSystem

SMASaveSystem is a simple wrapper for saving data on Mac OS X and iOS.

##Basics
SMASaveSystem consists only of class methods, import the class and go.
```swift 
import SMASaveSystem
```
All data is saved into a binary file named appname.abss, in the Documents directory on iOS or the "Application Support/appname>" directory on OS X.

##Save 
```swift
//NSData
SMASaveSystem.saveData(myData, key: "myDataKey")

//NSString
SMASaveSystem.saveString(myString, key: "myStringKey")

//AnyObject
SMASaveSystem.saveObject(myObject, key: "myObjectKey")

//NSNumber
SMASaveSystem.saveNumber(myNumber, key: "myNumberKey")

//NSDate
SMASaveSystem.saveDate(myDate, key: "myDateKey")

//NSInteger
SMASaveSystem.saveInteger(23, key: "myIntegerKey")

//Float
SMASaveSystem.saveFloat(123.45, key: "myFloatKey")

//BOOL
SMASaveSystem.saveBool(true, key: "myBoolKey")

```

##Load
```swift
//NSData
let myData = SMASaveSystem.data("myDataKey")

//NSInteger
let myInteger = SMASaveSystem.integer("myIntegerKey")

//The other load methods follow the same naming convention
```

##Misc
```swift
//Log all saved values
SMASaveSystem.logSavedValues()

//Delete all saved data
SMASaveSystem.truncate()

```

##Thanks

This was originally inspired by [ABSaveSystem](https://github.com/alexblunck/ABSaveSystem) which hasn't been updated in quite a while. We use this quite a bit so we decided to modernize it for Swift so we can continue using it going forward.

##LICENSE
SMASaveSystem is licensed under the MIT License. Check the LICENSE file, of course attribution is always a nice thing.
