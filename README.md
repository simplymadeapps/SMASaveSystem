# SMASaveSystem

SMASaveSystem is a simple wrapper for saving data on Mac OS X and iOS.

# Disclaimer

We are still in the process of cleaning up this project and making it a bit easier to use and import. I'll add a quick list of things that are still in the works, so please bear with us.

1. Create Cocoapod
2. Currently dependent on CryptoSwift Cocoapod
3. Create a better way to set the options for encryption, logging, encryption key, iv, etc.
4. Finish updating README

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
The MIT License (MIT)

Copyright (c) 2016 Simply Made Apps

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
