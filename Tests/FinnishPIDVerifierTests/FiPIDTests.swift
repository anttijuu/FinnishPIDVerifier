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
						  "161001-154L",
						  "131052-308T"]
		
	func testInvalidPIDs() throws {
		for pid in invalidPIDs {
			var verifier: FinnishPID!
			XCTAssertNoThrow(verifier = FinnishPID.verify(pid: pid))
			XCTAssertNotNil(verifier)
			XCTAssertEqual(FinnishPID.Validity.invalidPID, verifier.validity)
			XCTAssertFalse(verifier.isValid)
			print(verifier!)
		}
	}
	
	func testValidPIDs() throws {
		for pid in validPIDs {
			var verifier: FinnishPID!
			XCTAssertNoThrow(verifier = FinnishPID.verify(pid: pid))
			XCTAssertNotNil(verifier)
			XCTAssertEqual(FinnishPID.Validity.validPID, verifier.validity)
			XCTAssertTrue(verifier.isValid)
			print(verifier!)
		}
	}
	
	func testValidTestPIDs() throws {
		for pid in validTestPIDs {
			var verifier: FinnishPID!
			XCTAssertNoThrow(verifier = FinnishPID.verify(pid: pid))
			XCTAssertNotNil(verifier)
			XCTAssertEqual(FinnishPID.Validity.testPID, verifier.validity)
			XCTAssertTrue(verifier.gender != FinnishPID.Gender.undefined)
			XCTAssertFalse(verifier.isValid)
			print(verifier!)
		}
	}
	
	func testValidGender() throws {
		var verifier: FinnishPID!
		XCTAssertNoThrow(verifier = FinnishPID.verify(pid: "210911+0785"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FinnishPID.Validity.validPID, verifier.validity)
		XCTAssertTrue(verifier.isValid)
		XCTAssertEqual(FinnishPID.Gender.female, verifier.gender)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FinnishPID.verify(pid: "050301-679T"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FinnishPID.Validity.validPID, verifier.validity)
		XCTAssertEqual(FinnishPID.Gender.male, verifier.gender)
		XCTAssertTrue(verifier.isValid)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FinnishPID.verify(pid: "211123A965F"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FinnishPID.Validity.testPID, verifier.validity)
		XCTAssertEqual(FinnishPID.Gender.male, verifier.gender)
		XCTAssertFalse(verifier.isValid)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FinnishPID.verify(pid: "260503-998S"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FinnishPID.Validity.testPID, verifier.validity)
		XCTAssertEqual(FinnishPID.Gender.female, verifier.gender)
		XCTAssertFalse(verifier.isValid)
		print(verifier!)
	}
	
	func testValidDate() throws {
		var verifier: FinnishPID!
		XCTAssertNoThrow(verifier = FinnishPID.verify(pid: "210911+0785"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FinnishPID.Validity.validPID, verifier.validity)
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
		
		XCTAssertNoThrow(verifier = FinnishPID.verify(pid: "050301-679T"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FinnishPID.Validity.validPID, verifier.validity)
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
		
		XCTAssertNoThrow(verifier = FinnishPID.verify(pid: "211123A965F"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FinnishPID.Validity.testPID, verifier.validity)
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
		
		XCTAssertNoThrow(verifier = FinnishPID.verify(pid: "260503-998S"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FinnishPID.Validity.testPID, verifier.validity)
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
		
		XCTAssertNoThrow(verifier = FinnishPID.verify(pid: "261027C053H"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FinnishPID.Validity.validPID, verifier.validity)
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

	func testSortOrder() {
		var pids = [FinnishPID]()
		for pid in validPIDs {
			pids.append(FinnishPID.verify(pid: pid))
		}
		pids = pids.sorted()
		var previousDate: Date?
		var previousPersonNumber: Int?
		for pid in pids {
			print(pid)
			if let previousDate, let currentDate = pid.birthDay {
				XCTAssertLessThanOrEqual(previousDate, currentDate)
				if previousDate == currentDate, let previousPersonNumber, let currentNumber = pid.individualNumber {
					XCTAssertLessThanOrEqual(previousPersonNumber, currentNumber)
				}
			}
			previousDate = pid.birthDay
			previousPersonNumber = pid.individualNumber
		}
	}
}
