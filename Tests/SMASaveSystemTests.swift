//
//  SMASaveSystemTests.swift
//  SMASaveSystemTests
//
//  Created by Bill Burgess on 1/12/16.
//  Copyright © 2016 Simply Made Apps. All rights reserved.
//

import XCTest
@testable import SMASaveSystem

class SMASaveSystemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        SMASaveSystem.truncate()
        
        super.tearDown()
    }
    
    func testThatAppNameWorks() {
        let name = SMASaveSystem.appName()
        XCTAssertNotNil(name, "App name should not be nil")
    }
    
    func testThatSMASaveSystemOSWorks() {
        let os = SMASaveSystem.os()
        XCTAssertNotNil(os, "OS should not be nil")
        XCTAssertEqual(os.value, SMASaveSystemOSMacOSX.value, "OS should match")
    }
    
    func testThatFilePathWithEncryptionWorks() {
        let path = SMASaveSystem.filePathEncryption(true)
        XCTAssertNotNil(path, "Path should not be nil")
        let ext = (path as NSString!).pathExtension
        XCTAssertEqual(ext, "abssen", "File name should have correct extension")
    }
    
    func testThatFilePathWithoutEncryptionWorks() {
        let path = SMASaveSystem.filePathEncryption(false)
        XCTAssertNotNil(path, "Path should not be nil")
        let ext = (path as NSString!).pathExtension
        XCTAssertEqual(ext, "abss", "File name should have correct extension")
    }
    
    func testThatLoadDictionaryWithEncryptionWorks() {
        let dict1 = SMASaveSystem.loadDictionaryEncryption(true)
        XCTAssertNil(dict1, "Dictionary should return nil")
        
        let value = "testvalue"
        let key = "key"
        SMASaveSystem.saveString(value, key: key, encryption: true)
        
        let dict2 = SMASaveSystem.loadDictionaryEncryption(true)
        XCTAssertNotNil(dict2, "Dictionary should not be nil")
    }
    
    func testThatLoadDictionaryWithoutEncryptionWorks() {
        let dict1 = SMASaveSystem.loadDictionaryEncryption(false)
        XCTAssertNil(dict1, "Dictionary should return nil")
        
        let value = "testvalue"
        let key = "key"
        SMASaveSystem.saveString(value, key: key, encryption: false)
        
        let dict2 = SMASaveSystem.loadDictionaryEncryption(false)
        XCTAssertNotNil(dict2, "Dictionary should not be nil")
    }
}
