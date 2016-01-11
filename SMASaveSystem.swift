//
//  SMASaveSystem.swift
//  simpleinout-mac
//
//  Created by Bill Burgess on 1/11/16.
//  Copyright © 2016 Simply Made Apps. All rights reserved.
//

import Cocoa
import Foundation
import CryptoSwift

struct SMASaveSystemConstants {
    static let Encryption: Bool = true
    static let EncryptionKey = "secret0key000000"
    static let IV = "0123456789012345"
    static let Logging: Bool = true
}

struct SMASaveSystemOS {
    var value: UInt32
    init(_ val: UInt32) { value = val }
}
let SMASaveSystemOSNone = SMASaveSystemOS(0)
let SMASaveSystemOSMacOSX = SMASaveSystemOS(1)
let SMASaveSystemOSIOS = SMASaveSystemOS(2)

class SMASaveSystem: NSObject {
    
    // MARK: Helper
    class func appName() -> String? {
        let bundlePath = NSBundle.mainBundle().bundleURL.lastPathComponent
        return (bundlePath as NSString!).lastPathComponent.lowercaseString
    }
    
    class func os() -> SMASaveSystemOS {
        #if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
        return SMASaveSystemOSIOS
        #else
        return SMASaveSystemOSMacOSX
        #endif
    }
    
    class func filePathEncryption(encryption: Bool) -> String? {
        let os = self.os()
        
        let fileExt = encryption ? ".abssen" : ".abss"
        let fileName = self.appName()! + fileExt
        
        if os.value == SMASaveSystemOSIOS.value {
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDirectory = paths[0]
            let path = (documentsDirectory as NSString!).stringByAppendingPathComponent(fileName)
            return path
        } else if os.value == SMASaveSystemOSMacOSX.value {
            let fileManager = NSFileManager.defaultManager()
            var folderPath = "~/Library/Application Support/" + self.appName()! + "/"
            folderPath = (folderPath as NSString!).stringByExpandingTildeInPath
            if fileManager.fileExistsAtPath(folderPath) == false {
                do {
                    try fileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    print(error)
                }
            }
            return (folderPath as NSString!).stringByAppendingPathComponent(fileName)
        }
        return nil
    }
    
    class func loadDictionaryEncryption(encryption: Bool) -> NSMutableDictionary? {
        let binaryFile = NSData(contentsOfFile: self.filePathEncryption(encryption)!)
        
        if binaryFile == nil {
            return nil
        }
        
        var dictionary: NSMutableDictionary
        
        if encryption == true {
            let decryptedData = self.decryptData(binaryFile!)
            dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(decryptedData!) as! NSMutableDictionary
        } else {
            dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(binaryFile!) as! NSMutableDictionary
        }
        
        return dictionary
    }
    
    // MARK: Objects
    
    // MARK: NSData
    class func saveData(data: NSData?, key: String!, encryption: Bool) {
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(self.filePathEncryption(encryption)!)
        var tempDic: NSMutableDictionary?
        if fileExists == true {
            tempDic = self.loadDictionaryEncryption(encryption)!
        } else {
            tempDic = NSMutableDictionary()
        }
        
        tempDic?.setObject(data!, forKey: key)
        
        let dicData = NSKeyedArchiver.archivedDataWithRootObject(tempDic!)
        if encryption == true {
            let encryptedData = self.encryptData(dicData)
            let options: NSDataWritingOptions = .DataWritingAtomic
            try! encryptedData?.writeToFile(self.filePathEncryption(encryption)!, options: options)
        } else {
            try! dicData.writeToFile(self.filePathEncryption(encryption)!, options: .DataWritingAtomic)
        }
    }
    
    class func saveData(data: NSData?, key: String!) {
        self.saveData(data, key: key, encryption: SMASaveSystemConstants.Encryption)
    }
    
    class func removeData(key: String!, encryption: Bool) {
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(self.filePathEncryption(encryption)!)
        let tempDic: NSMutableDictionary?
        if fileExists == true {
            tempDic = self.loadDictionaryEncryption(encryption)!
        } else {
            tempDic = NSMutableDictionary()
        }
        
        tempDic?.removeObjectForKey(key)
        
        let dicData = NSKeyedArchiver.archivedDataWithRootObject(tempDic!)
        if encryption == true {
            let encryptedData = self.encryptData(dicData)
            do {
                try encryptedData?.writeToFile(self.filePathEncryption(encryption)!, options: .DataWritingAtomic)
            } catch {
                print("SMASaveSystem Error Removing Data: \(key) : \(error)")
            }
        } else {
            do {
                try dicData.writeToFile(self.filePathEncryption(encryption)!, options: .DataWritingAtomic)
            } catch {
                print("SMASaveSystem Error Removing Data: \(key) : \(error)")
            }
        }
    }
    
    class func removeData(key: String!) {
        self.removeData(key, encryption: SMASaveSystemConstants.Encryption)
    }
    
    class func data(key: String!, encryption: Bool) -> NSData? {
        let tempDic = self.loadDictionaryEncryption(encryption)
        if let data = tempDic?.objectForKey(key) {
            return data as? NSData
        } else {
            if SMASaveSystemConstants.Logging == true {
                print("SMASaveSystem ERROR: data(key: \(key)) does not exist!")
            }
            return nil
        }
    }
    
    class func data(key: String!) -> NSData? {
        return self.data(key, encryption: SMASaveSystemConstants.Encryption)
    }
    
    // MARK: NSObject
    class func saveObject(object: AnyObject, key: String!) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(object)
        self.saveData(data, key: key)
    }
    
    /*
    class func object(key: String!, checkClass: AnyClass?) -> AnyObject? {
        if let data = self.data(key) {
            let object = NSKeyedUnarchiver.unarchiveObjectWithData(data)
            if (checkClass == nil || object?.isKindOfClass(checkClass!) != nil) {
                return object
            } else {
                if SMASaveSystemConstants.Logging == true {
                    print("SMASaveSystem ERROR: object(key: \(key) -> saved object is \(object?.classDescription) not a \(checkClass)")
                }
            }
        }
        return nil
    }
    */
    
    class func object(key: String!) -> AnyObject? {
        //return self.object(key)
        if let data = self.data(key) {
            if let object = NSKeyedUnarchiver.unarchiveObjectWithData(data) {
                return object
            } else {
                if SMASaveSystemConstants.Logging == true {
                    print("SMASaveSystem ERROR: object(key: \(key) does not exist!")
                }
            }
        }
        return nil
    }
    
    // MARK: String
    class func saveString(string: String!, key: String!) {
        self.saveObject(string, key: key)
    }
    
    class func string(key: String!) -> String? {
        return self.object(key) as? String
    }
    
    // MARK: NSNumber
    class func saveNumber(number: NSNumber!, key: String!) {
        self.saveObject(number, key: key)
    }
    
    class func number(key: String!) -> NSNumber? {
        return self.object(key) as? NSNumber
    }
    
    // MARK: NSDate
    class func saveDate(date: NSDate!, key: String!) {
        self.saveObject(date, key: key)
    }
    
    class func date(key: String!) -> NSDate? {
        return self.object(key) as? NSDate
    }
    
    // MARK: Primitives
    
    // MARK: NSInteger
    class func saveInteger(integer: NSInteger!, key: String!) {
        self.saveObject(NSNumber(integer: integer), key: key)
    }
    
    class func integer(key: String!) -> NSInteger? {
        return self.object(key) as? NSInteger
    }
    
    // MARK: CGFloat
    class func saveFloat(float: Float!, key: String!) {
        self.saveObject(NSNumber(float: float), key: key)
    }
    
    class func float(key: String!) -> Float? {
        return self.object(key) as? Float
    }
    
    // MARK: Bool
    class func saveBool(bool: Bool, key: String!) {
        self.saveObject(NSNumber(bool: bool), key: key)
    }
    
    class func bool(key: String!) -> Bool {
        return self.object(key) as! Bool
    }
    
    // MARK: Logging
    class func logSavedValues() {
        self.logSavedValues(SMASaveSystemConstants.Encryption)
    }
    
    class func logSavedValues(encryption: Bool) {
        let baseLogMessage = encryption ? "SMASaveSystem: logSavedValues (Encrypted)" : "SMASaveSystem: logSavedValues"
        
        if let tempDic = self.loadDictionaryEncryption(encryption) {
            print("\(baseLogMessage) -> START LOG")
            tempDic.enumerateKeysAndObjectsUsingBlock {
                (key, value, pointer) in
                let valueString = NSKeyedUnarchiver.unarchiveObjectWithData(value as! NSData)
                print("\(baseLogMessage) -> Key: \(key) -> \(valueString)")
            }
            
            print("\(baseLogMessage) -> END LOG")
        } else {
            print("\(baseLogMessage) -> NO DATA SAVED")
            return
        }
        
    }
    
    // MARK: Cleanup
    class func truncate() {
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtPath(self.filePathEncryption(SMASaveSystemConstants.Encryption)!)
            print("Data file successfully removed")
        } catch {
            let fileExt = SMASaveSystemConstants.Encryption ? ".abssen" : ".abss"
            let fileName = self.appName()! + fileExt
            print("Could not delete file: \(fileName)")
        }
    }
    
    // MARK: Encryption Helpers
    class func encryptData(data: NSData) -> NSData? {
        let encrypted = try! data.encrypt(AES(key: SMASaveSystemConstants.EncryptionKey, iv: SMASaveSystemConstants.IV))
        return encrypted
    }
    
    class func decryptData(data: NSData) -> NSData? {
        let decrypted = try! data.decrypt(AES(key: SMASaveSystemConstants.EncryptionKey, iv: SMASaveSystemConstants.IV))
        return decrypted
    }
}