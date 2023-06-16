import XCTest
@testable import fi_pid_verify

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
	let validPIDs = ["210911+0785",
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
			var verifier: FiPIDVerifier!
			XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: pid))
			XCTAssertNotNil(verifier)
			XCTAssertEqual(FiPIDVerifier.Validity.invalidPID, verifier.validity)
			print(verifier!)
		}
	}
	
	func testValidPIDs() throws {
		for pid in validPIDs {
			var verifier: FiPIDVerifier!
			XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: pid))
			XCTAssertNotNil(verifier)
			XCTAssertEqual(FiPIDVerifier.Validity.validPID, verifier?.validity)
			print(verifier!)
		}
	}
	
	func testValidTestPIDs() throws {
		for pid in validTestPIDs {
			var verifier: FiPIDVerifier!
			XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: pid))
			XCTAssertNotNil(verifier)
			XCTAssertEqual(FiPIDVerifier.Validity.testPID, verifier?.validity)
			XCTAssertTrue(verifier?.gender != FiPIDVerifier.Gender.undefined)
			XCTAssertTrue(verifier?.gender != FiPIDVerifier.Gender.other)
			print(verifier!)
		}
	}
	
	func testValidGender() throws {
		var verifier: FiPIDVerifier!
		XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: "210911+0785"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FiPIDVerifier.Validity.validPID, verifier?.validity)
		XCTAssertEqual(FiPIDVerifier.Gender.female, verifier?.gender)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: "050301-679T"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FiPIDVerifier.Validity.validPID, verifier?.validity)
		XCTAssertEqual(FiPIDVerifier.Gender.male, verifier?.gender)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: "211123A965F"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FiPIDVerifier.Validity.testPID, verifier?.validity)
		XCTAssertEqual(FiPIDVerifier.Gender.male, verifier?.gender)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: "260503-998S"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FiPIDVerifier.Validity.testPID, verifier?.validity)
		XCTAssertEqual(FiPIDVerifier.Gender.female, verifier?.gender)
		print(verifier!)
	}
	
	func testValidDate() throws {
		var verifier: FiPIDVerifier!
		XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: "210911+0785"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FiPIDVerifier.Validity.validPID, verifier?.validity)
		XCTAssertEqual(21, verifier?.day)
		XCTAssertEqual(9, verifier?.month)
		XCTAssertEqual(1811, verifier?.year)
		XCTAssertEqual("21.9.1811", verifier?.dateString)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: "050301-679T"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FiPIDVerifier.Validity.validPID, verifier?.validity)
		XCTAssertEqual(5, verifier?.day)
		XCTAssertEqual(3, verifier?.month)
		XCTAssertEqual(1901, verifier?.year)
		XCTAssertEqual("5.3.1901", verifier?.dateString)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: "211123A965F"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FiPIDVerifier.Validity.testPID, verifier?.validity)
		XCTAssertEqual(21, verifier?.day)
		XCTAssertEqual(11, verifier?.month)
		XCTAssertEqual(2023, verifier?.year)
		XCTAssertEqual("21.11.2023", verifier?.dateString)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: "260503-998S"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FiPIDVerifier.Validity.testPID, verifier?.validity)
		XCTAssertEqual(26, verifier?.day)
		XCTAssertEqual(5, verifier?.month)
		XCTAssertEqual(1903, verifier?.year)
		XCTAssertEqual("26.5.1903", verifier?.dateString)
		print(verifier!)
		
		XCTAssertNoThrow(verifier = FiPIDVerifier.verify(pid: "261027C053H"))
		XCTAssertNotNil(verifier)
		XCTAssertEqual(FiPIDVerifier.Validity.validPID, verifier?.validity)
		XCTAssertEqual(26, verifier?.day)
		XCTAssertEqual(10, verifier?.month)
		XCTAssertEqual(2027, verifier?.year)
		XCTAssertEqual("26.10.2027", verifier?.dateString)
		print(verifier!)
	}

}
