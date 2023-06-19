//
//  FinnishPID+Equatable.swift
//
//
//  Created by Antti Juustila on 18.6.2023.
//
import Foundation

/// `FinnishPID` verifies Finnish Person ID strings.
/// 
/// The string format is `ddmmyyAnnnX`, where:
/// * dd is the day of birth
/// * mm is the month of birth
/// * yy is the last two digits of the year of birth
/// * A is the century character, indicating which century (1800, 1900 or 2000) the person was born
/// * nnn is the daily number given to persons born on that day. Values >= 900 are used for test PIDs only. Even numbers are for females, odd numbers for males.
/// * X is a control character, calculated from ddmmyynnn and using a lookup table.
///
/// The function `FinnishPID.verify(pid:)` returns an object that you can use to check for validity, using properties such as:
/// * validity
/// * gender
/// * birthDay and
/// * day, month and year
///
/// For details, see [https://dvv.fi/henkilotunnus](https://dvv.fi/henkilotunnus).
///
public struct FinnishPID {

	// MARK: - Public interface
	
	/// The validity enumeration.
	public enum Validity {
		/// The PID was proven to be a valid PID.
		case validPID
		/// The PID was proven to be an invalid PID.
		case invalidPID
		/// The PID was proven to be a valid PID but one for testing only.
		case testPID
	}
	
	/// Gender enumeration.
	public enum Gender {
		/// The validity has not yet been determined.
		case undefined
		/// PID is for a male person.
		case male
		/// PID is for a female person.
		case female
	}
	
	/// Use this function to verify if a Finnish PID is valid or not.
	///
	/// - Parameter pid: The string to verify
	/// - Returns: A FinnishPID object you can use to check the properties of the verified pid.
	public static func verify(pid: String) -> FinnishPID {
		var verifier = FinnishPID(pid: pid)
		guard pid.count == 11 else {
			return verifier
		}
		let centuryChar = pid[pid.index(pid.startIndex, offsetBy: 6)]
		guard verifier.isValidCenturyChar(centuryChar) else {
			return verifier
		}
		if let date = verifier.dateFrom(dateString: String(pid.prefix(6)), centuryChar: centuryChar) {
			if verifier.isCorrectCheckChar(from: pid) {
				verifier.birthDay = date
				if let personNumber = verifier.dailyNumber {
					verifier.gender = personNumber % 2 == 0 ? .female : .male
					if personNumber >= 2 && personNumber <= 899 {
						verifier.validity = .validPID
					} else if personNumber >= 900 && personNumber <= 999 {
						verifier.validity = .testPID
					} else {
						verifier.validity = .invalidPID
					}
				}
			}
		}
		return verifier
	}

	/// Stored from parameter in `verify(pid:)` so that we can use it later.
	public let pid: String
	/// The validity of the checked PID.
	public private (set) var validity: Validity = .invalidPID
	/// The gender of the person based on the PID.
	public private (set) var gender: Gender = .undefined
	/// The birth date of the person based on the PID. If PID was invalid, is `nil`.
	public private (set) var birthDay: Date?
	
	/// True, if the PID was valid and *not* a test PID.
	public var isValid: Bool {
		get {
			return validity == .validPID
		}
	}
	
	/// The birthdate of the person in format "mm.dd.yyyy" or nil if invalid PID.
	public var dateString: String? {
		get {
			if validity == .validPID || validity == .testPID {
				return "\(day!).\(month!).\(year!)"
			} else {
				return nil
			}
		}
	}
	
	/// The gender of the person based on PID in English.
	public var genderString: String {
		switch gender {
			case .female:
				return NSLocalizedString("female", bundle: Bundle.module, comment: "Gender is female")
			case .male:
				return NSLocalizedString("male", bundle: Bundle.module, comment: "Gender is male")
			case .undefined:
				return NSLocalizedString("undefined", bundle: Bundle.module, comment: "Gender is undefined since PID was invalid")
		}
	}
	
	/// The year of birth or nil if not a valid birthday.
	public var year: Int? {
		get {
			if let birthDay {
				let dateComponens = FinnishPID.calendar.dateComponents([.year], from: birthDay)
				return dateComponens.year
			} else {
				return nil
			}
		}
	}
	
	/// The month of birth or nil if not a valid birthday.
	public var month: Int? {
		get {
			if let birthDay {
				let dateComponens = FinnishPID.calendar.dateComponents([.month], from: birthDay)
				return dateComponens.month
			} else {
				return nil
			}
		}
	}
	
	/// The day of birth or nil if not a valid birthday.
	public var day: Int? {
		get {
			if let birthDay {
				let dateComponens = FinnishPID.calendar.dateComponents([.day], from: birthDay)
				return dateComponens.day
			} else {
				return nil
			}
		}
	}
	
	/// The sequence number for this PID among the daily count of persons born on the same day, or nil if not a valid PID.
	public var dailyNumber: Int? {
		get {
			return Int(String(pid.suffix(4)).prefix(3))
		}
	}

	// MARK: - Private properties

	/// Private initializer. Use the static method `verify(pid:)` to verify PIDs.
	/// - Parameter pid: The person ID to verify
	private init(pid: String) {
		self.pid = pid
	}
	
	/// Needed in calendar/date related operations, Gregorian calendar used.
	private static let calendar = Calendar(identifier: .gregorian)

	/// The different century characters and related century.
	private let centuryChars = [ "+": 1800,
										  "-": 1900,
										  "Y": 1900,
										  "X": 1900,
										  "W": 1900,
										  "V": 1900,
										  "U": 1900,
										  "A": 2000,
										  "B": 2000,
										  "C": 2000,
										  "D": 2000,
										  "E": 2000,
										  "F": 2000
										]

	/// Used in calculating the control character from the PID and validating it.
	private let checkSumChars = "0123456789ABCDEFHJKLMNPRSTUVWXY"
	/// The divider used in checksum calculation.
	private let checkSumDivider = 31
	
	/// From a PID, checks if the last control character in the pid is correct.
	/// - Parameter pid: The whole PID string.
	/// - Returns: True if the control character was correct.
	private func isCorrectCheckChar(from pid: String) -> Bool {
		let string = pid.prefix(6) + pid.suffix(4).dropLast(1)
		guard string.allSatisfy( { $0.isNumber }), let checkSum = Int(string) else {
			return false
		}
		let index = checkSum % checkSumDivider
		return checkSumChars[checkSumChars.index(checkSumChars.startIndex, offsetBy: index)] == pid.last
	}
	
	/// Creates a Date object from the date part of the PID, using the century character to do it.
	///
	/// The dateString must be in the format "ddmmyy", extracted from the PID.
	///
	/// - Parameters:
	///   - dateString: The date part of the PID string
	///   - centuryChar: The century character from PID.
	/// - Returns: A date of birth based on the PID, or null if PID does not contain a valid date.
	private mutating func dateFrom(dateString: String, centuryChar: Character) -> Date? {
		guard dateString.count == 6 else {
			return nil
		}
		guard dateString.allSatisfy( { $0.isNumber }) else {
			return nil
		}
		guard let century = centuryFromCenturyChar(centuryChar) else {
			return nil
		}
		let day = Int(dateString.prefix(2))
		let month = Int(dateString.dropFirst(2).prefix(2))
		let year = Int(dateString.dropFirst(4).prefix(2))
		if let day, let month, let year {
			let dateComponents = DateComponents(calendar: FinnishPID.calendar, year: century + year, month: month, day: day)
			if dateComponents.isValidDate(in: FinnishPID.calendar) {
				return dateComponents.date
			}
		}
		return nil
	}

	/// Checks if the provided character is a valid century character in a PID.
	///
	/// - Parameter character: A century character from the PID
	/// - Returns: True if the character is a valid century character, false otherwise.
	private func isValidCenturyChar(_ character: Character) -> Bool {
		if centuryChars.keys.contains(String(character)) {
			return true
		}
		return false
	}

	/// Returns a century for a specific century character in PID string.
	///
	/// - Parameter character: A character from the PID describing the century.
	/// - Returns: Returns either 1800, 1900 or 2000.
	private func centuryFromCenturyChar(_ character: Character) -> Int? {
		centuryChars[String(character)]
	}
}

/// Provides a localized  summary of the verification.
extension FinnishPID: CustomStringConvertible {
	public var description: String {
		switch validity {
			case .validPID:
				let format = NSLocalizedString("VALID_PID_KEY", bundle: Bundle.module, value: "Valid PID: %@, born: %@, gender: %@", comment: "A string with variables PID, date and gender")
				return String.localizedStringWithFormat(format, pid, dateString!, genderString)
			case .testPID:
				let format = NSLocalizedString("TEST_PID_KEY", bundle: Bundle.module, value: "Test PID: %@, born: %@, gender: %@", comment: "A string with variables PID, date and gender")
				return String.localizedStringWithFormat(format, pid, dateString!, genderString)
			case .invalidPID:
				let format = NSLocalizedString("INVALID_PID_KEY", bundle: Bundle.module, value: "Invalid PID: \(pid)", comment: "Invalid value for the PID")
				return String.localizedStringWithFormat(format, pid)
		}
	}
}
