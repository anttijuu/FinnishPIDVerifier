import XCTest
@testable import FinnishPIDVerifier

final class FiPIDTests: XCTestCase {

	let validTestPIDs = ["260503-998S",
								"260503U998S",
								"220303+996H",
								"211123A965F",
								"211123F965F"]
	
	let invalidPIDs = ["naurispelto",
							"12345678901",
							"261027J053H",
							"52345262724345324523462",
							"42",
							"161001*154L",
							"161a01-154L",
							"     42    ",
							"050301--79T",
							"-050301-179",
							"161001-1p4L",
							"211323A965F"]
	
	// These are generated PIDs.
	let validPIDs = ["010101-123N",
						  "210911+0785",
						  "130311+8502",
						  "190427A874M",
						  "261027A053H",
						  "261027C053H",
						  "190427A874M",
						  "261027A053H",
						  "050301-679T",
						  "050301Y679T",
						  "161001-154L"]
		
	func testInvalidPIDs() throws {
		for pid in invalidPIDs {
			var verifier: FPIDVerifier!
			XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: pid))
			XCTAssertNotNil(verifier)
			XCTAssertEqual(FPIDVerifier.Validity.invalidPID, verifier.validity)
			XCTAssertFalse(verifier.isValid)
			print(verifier!)
		}
	}
	
	func testValidPIDs() throws {
		for pid in validPIDs {
			var verifier: FPIDVerifier!
			XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: pid))
			XCTAssertNotNil(verifier)
			XCTAssertEqual(FPIDVerifier.Validity.validPID, verifier.validity)
			XCTAssertTrue(verifier.isValid)
			print(verifier!)
		}
	}
	
	func testValidTestPIDs() throws {
		for pid in validTestPIDs {
			var verifier: FPIDVerifier!
			XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: pid))
			XCTAssertNotNil(verifier)
			XCTAssertEqual(FPIDVerifier.Validity.testPID, verifier.validity)
			XCTAssertTrue(verifier.gender != FPIDVerifier.Gender.undefined)
			XCTAssertTrue(verifier.gender != FPIDVerifier.Gender.other)
			XCTAssertFalse(verifier.isValid)
			print(verifier!)
		}
	}
	
	func testValidGender() throws {
		var verifier: FPIDVerifier!
		XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: "210911+0785"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FPIDVerifier.Validity.validPID, verifier.validity)
		XCTAssertTrue(verifier.isValid)
		XCTAssertEqual(FPIDVerifier.Gender.female, verifier.gender)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: "050301-679T"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FPIDVerifier.Validity.validPID, verifier.validity)
		XCTAssertEqual(FPIDVerifier.Gender.male, verifier.gender)
		XCTAssertTrue(verifier.isValid)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: "211123A965F"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FPIDVerifier.Validity.testPID, verifier.validity)
		XCTAssertEqual(FPIDVerifier.Gender.male, verifier.gender)
		XCTAssertFalse(verifier.isValid)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: "260503-998S"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FPIDVerifier.Validity.testPID, verifier.validity)
		XCTAssertEqual(FPIDVerifier.Gender.female, verifier.gender)
		XCTAssertFalse(verifier.isValid)
		print(verifier!)
	}
	
	func testValidDate() throws {
		var verifier: FPIDVerifier!
		XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: "210911+0785"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FPIDVerifier.Validity.validPID, verifier.validity)
		XCTAssertEqual(21, verifier.day)
		XCTAssertEqual(9, verifier.month)
		XCTAssertEqual(1811, verifier.year)
		XCTAssertEqual("21.9.1811", verifier.dateString)
		XCTAssertTrue(verifier.isValid)
		var dateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 1811, month: 9, day: 21)
		if let date = dateComponents.date {
			XCTAssertEqual(date, verifier.birthDay)
		}
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: "050301-679T"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FPIDVerifier.Validity.validPID, verifier.validity)
		XCTAssertEqual(5, verifier.day)
		XCTAssertEqual(3, verifier.month)
		XCTAssertEqual(1901, verifier.year)
		XCTAssertEqual("5.3.1901", verifier.dateString)
		XCTAssertTrue(verifier.isValid)
		dateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 1901, month: 3, day: 5)
		if let date = dateComponents.date {
			XCTAssertEqual(date, verifier.birthDay)
		}
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: "211123A965F"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FPIDVerifier.Validity.testPID, verifier.validity)
		XCTAssertEqual(21, verifier.day)
		XCTAssertEqual(11, verifier.month)
		XCTAssertEqual(2023, verifier.year)
		XCTAssertEqual("21.11.2023", verifier.dateString)
		XCTAssertFalse(verifier.isValid)
		dateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2023, month: 11, day: 21)
		if let date = dateComponents.date {
			XCTAssertEqual(date, verifier.birthDay)
		}
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: "260503-998S"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FPIDVerifier.Validity.testPID, verifier.validity)
		XCTAssertEqual(26, verifier.day)
		XCTAssertEqual(5, verifier.month)
		XCTAssertEqual(1903, verifier.year)
		XCTAssertEqual("26.5.1903", verifier.dateString)
		XCTAssertFalse(verifier.isValid)
		dateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 1903, month: 5, day: 26)
		if let date = dateComponents.date {
			XCTAssertEqual(date, verifier.birthDay)
		}
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FPIDVerifier.verify(pid: "261027C053H"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FPIDVerifier.Validity.validPID, verifier.validity)
		XCTAssertEqual(26, verifier.day)
		XCTAssertEqual(10, verifier.month)
		XCTAssertEqual(2027, verifier.year)
		XCTAssertEqual("26.10.2027", verifier.dateString)
		XCTAssertTrue(verifier.isValid)
		dateComponents = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2027, month: 10, day: 26)
		if let date = dateComponents.date {
			XCTAssertEqual(date, verifier.birthDay)
		}
		print(verifier!)
	}

}