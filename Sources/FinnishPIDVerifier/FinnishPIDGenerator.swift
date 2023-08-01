//
//  FinnishPIDGenerator.swift
//  
//
//  Created by Antti Juustila on 27.7.2023.
//

import Foundation

/// The `FinnishPIDGenerator` can be used to generate Finnish Person ID strings.
///
/// Use the `generatePID()` and `generatePIDs(count:)` methods to generate
/// valid and/or test PIDs.
///
/// Usage when generating a single PID:
/// ```Swift
/// let generator = FinnishPIDGenerator(range: 1800...2099, validity: .validPID)
/// let pidString = generator.generatePID()
/// ```
/// Where the range must be a range of valid years to generate PIDs for. The lowest possible year is 1800 while
/// the upper limit is 2099 (inclusive).
///
/// To generate an array of valid PID strings having 42 PID strings with default range of birth years:
/// ```Swift
/// let generator = FinnishPIDGenerator()
/// let pidStrings = generator.generatePIDs(count: 42)
/// ```
///Note that the generator may generate identical PID strings on the same run, since generation is random.
///For centuries 1900 and 2000, the century separator character is selected randomly from the set of valid characters.
///
///The generator does not generate invalid PID strings.
public struct FinnishPIDGenerator {

	/// Default range for year of birth.
	public var range: ClosedRange<Int> = 1966...2042
	/// Generate valid PIDs by default.
	public var validity: FinnishPID.Validity = .validPID

	public init(range: ClosedRange<Int> = 1966...2042, validity: FinnishPID.Validity = .validPID) {
		self.range = range
		self.validity = validity
	}
	
	/// Generates a single PID using the initialized `range` and `validity`.
	/// - Returns: A generated PID string or `nil` if something went wrong.
	public func generatePID() -> String? {
		guard range.lowerBound >= 1800 && range.upperBound < 2100 else {
			return nil
		}
		if let date = randomDate() {
			var pid = ""
			let components = FinnishPID.calendar.dateComponents([.day, .month, .year], from: date)
			let yearString = String(format: "%02d", components.year!).suffix(2)
			pid = "\(String(format: "%02d", components.day!))\(String(format: "%02d", components.month!))\(yearString)"
			if let centuryChar = centuryChar(for: components.year!) {
				pid += centuryChar
			} else {
				return nil
			}
			if validity == .validPID {
				pid += String(format: "%03d", FinnishPID.validIndividualNumberRange.randomElement()!)
			} else if validity == .testPID {
				pid += String(format: "%03d", FinnishPID.validIndividualNumberTestRange.randomElement()!)
			}
			let checkSumString = pid.prefix(6) + pid.suffix(3)
			if let checkSum = Int(checkSumString) {
				let index = checkSum % FinnishPID.checkSumDivider
				pid += String(FinnishPID.checkSumChar(at: index))
			}
			return pid
		}
		return nil
	}
	
	/// Generates an array of PID strings containing a `count` of PID strings.
	///
	/// Note that if generating a PID string fails, the array may contain less than `count` of PIDs.
	/// - Parameter count: The count of PID strings to generate.
	/// - Returns: An array of PID Strings.
	public func generatePIDs(count: Int) -> [String] {
		var pids = [String]()
		for _ in 0..<count {
			if let pid = generatePID() {
				pids.append(pid)
			}
		}
		return pids
	}
	
	/// Creates a random date in the range of years specified in `range` property.
	///
	/// If creating a random date fails, returns nil.
	/// - Returns: A random date in the range or nil.
	private func randomDate() -> Date? {
		let year = Int.random(in: range)
		let month = Int.random(in: 1...12)
		var day = Int.random(in: 1...28)
		if let date = FinnishPID.calendar.date(from: DateComponents(calendar: FinnishPID.calendar, year: year, month: month)) {
			if let dayRange = FinnishPID.calendar.range(of: .day, in: .month, for: date) {
				day = dayRange.randomElement()!
			}
		}
		return FinnishPID.calendar.date(from: DateComponents(calendar: FinnishPID.calendar, year: year, month: month, day: day))
	}
	
	/// Returns the century character for the specified year.
	///
	/// Note that only the first two digits of the year have any significance.
	/// If there is no proper century char for the year, returns nil.
	/// - Parameter year: Year to loop up the century char for.
	/// - Returns: The century character in a string or nil if there is no century char for this year.
	private func centuryChar(for year: Int) -> String? {
		let validCharsForYear = FinnishPID.centuryChars.filter({ (key, value) in
			(year / 100) * 100 == value
		})
		return validCharsForYear.randomElement()?.key
	}

}
