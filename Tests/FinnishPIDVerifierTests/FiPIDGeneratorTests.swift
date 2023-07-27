//
//  FiPIDGeneratorTests.swift
//  
//
//  Created by Antti Juustila on 27.7.2023.
//

import XCTest
@testable import FinnishPIDVerifier

final class FiPIDGeneratorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeneratedValidPIDS() throws {
		 let range = 1800...2099
		 let generator = FinnishPIDGenerator(range: range, validity: .validPID)
		 XCTAssertEqual(range, generator.range)
		 XCTAssertEqual(FinnishPID.Validity.validPID, generator.validity)
		 for _ in 0...42 {
			 let pidString = generator.generatePID()
			 XCTAssertNotNil(pidString)
			 print(pidString!)
			 let validator = FinnishPID.verify(pid: pidString!)
			 XCTAssertEqual(FinnishPID.Validity.validPID, validator.validity)
		 }
    }

}
