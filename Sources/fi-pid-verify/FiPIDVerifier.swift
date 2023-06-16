import Foundation

/// `FiPIDVerifier` verifies Finnish Person ID strings.
/// 
/// The string format is `ddmmyyAnnnX`, where:
/// * dd is the day of birth
/// * mm is the month of birth
/// * yy is the last two digits of the year of birth
/// * A is the century character, indicating which century (1800, 1900 or 2000) the person was born
/// * nnn is the daily number given to persons born on that day. Values >= 900 are used for test PIDs only. Even numbers are for females, odd numbers for males.
/// * X is a control character, calculated from ddmmyynnn and using a lookup table.
///
/// The function `FiPIDVerifier.verify(pid:)` returns an object that you can use to check for validity, using properties such as:
/// * validity
/// * gender
/// * birthDay and
/// * day, month and year
///
/// For details, see https://dvv.fi/henkilotunnus
public struct FiPIDVerifier {

	// MARK: - Public interface
	
	/// The validity enumeration.
	public enum Validity {
		case validPID		/// The PID was proven to be a valid PID.
		case invalidPID	/// The PID was proven to be an invalid PID.
		case testPID		/// The PID was proven to be a valid PID but one for testing only.
	}
	
	/// Gender enumeration.
	/// Since the Finnish PID system only uses male and female, the `other` case is not used.
	public enum Gender {
		case undefined		/// The validity has not yet been determined.
		case male			/// PID is for a male person.
		case female			/// PID is for a female person.
		case other			/// Not used.
	}
	
	/// Use this function to verify if a Finnish PID is valid or not.
	///
	/// - Parameter pid: The string to verify
	/// - Returns: A FiPIDVerifier object you can use to check the properties of the verified pid.
	public static func verify(pid: String) -> FiPIDVerifier {
		var verifier = FiPIDVerifier(pid: pid)
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
				let personNumberString = pid.suffix(4).dropLast(1)
				if let personNumber = Int(personNumberString) {
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

	/// The validity of the checked PID.
	private (set) var validity: Validity = .invalidPID
	/// The gender of the person based on the PID.
	private (set) var gender: Gender = .undefined
	/// The birth date of the person based on the PID.
	private (set) var birthDay: Date?
	
	/// The birthdate of the person in format "mm.dd.yyyy" or nil if invalid PID.
	var dateString: String? {
		get {
			if validity == .validPID || validity == .testPID {
				return "\(day!).\(month!).\(year!)"
			} else {
				return nil
			}
		}
	}
	
	/// The gender of the person based on PID in English.
	var genderString: String {
		switch gender {
			case .female:
				return "Female"
			case .male:
				return "Male"
			case .other:
				return "Other"
			case .undefined:
				return "Undefined"
		}
	}
	
	/// The year of birth or nil if not a valid birthday.
	var year: Int? {
		get {
			if let birthDay {
				let calendar = Calendar(identifier: .gregorian)
				let dateComponens = calendar.dateComponents([.year], from: birthDay)
				return dateComponens.year
			} else {
				return nil
			}
		}
	}
	
	/// The month of birth or nil if not a valid birthday.
	var month: Int? {
		get {
			if let birthDay {
				let calendar = Calendar(identifier: .gregorian)
				let dateComponens = calendar.dateComponents([.month], from: birthDay)
				return dateComponens.month
			} else {
				return nil
			}
		}
	}
	
	/// The day of birth or nil if not a valid birthday.
	var day: Int? {
		get {
			if let birthDay {
				let calendar = Calendar(identifier: .gregorian)
				let dateComponens = calendar.dateComponents([.day], from: birthDay)
				return dateComponens.day
			} else {
				return nil
			}
		}
	}

	// MARK: - Private properties

	/// Private initializer. Use the static method `verify(pid:)` to verify PIDs.
	/// - Parameter pid: The person ID to verify
	private init(pid: String) {
		self.pid = pid
	}
	
	/// Saved from `verify(pid:)` so that we can print it out when needed.
	private let pid: String

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
			let calendar = Calendar(identifier: .gregorian)
			let dateComponents = DateComponents(calendar: calendar, year: century + year, month: month, day: day)
			if dateComponents.isValidDate(in: calendar) {
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

extension FiPIDVerifier: CustomStringConvertible {
	public var description: String {
		switch validity {
			case .validPID:
				return "Valid PID \(pid): born: \(dateString), gender: \(genderString)"
			case .testPID:
				return "Test PID: \(pid): born: \(dateString), gender: \(genderString)"
			case .invalidPID:
				return "Invalid PID"
		}
	}
}
