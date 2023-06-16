import Foundation

public struct FiPIDVerifier {

	private init() {
		// Empty
	}

	public enum Gender {
		case undefined
		case male
		case female
		case other
	}

	public enum Validity {
		case validSSN
		case invalidSSN
		case testSSN
	}

	public static func verify(ssn: String) -> FiPIDVerifier? {
		var verifier = FiPIDVerifier()
		guard ssn.count == 11 else {
			return verifier
		}
		let centuryChar = ssn[ssn.index(ssn.startIndex, offsetBy: 6)]
		guard verifier.isValidCenturyChar(centuryChar) else {
			return verifier
		}
		if let date = verifier.dateFrom(dateString: String(ssn.prefix(6)), centuryChar: centuryChar) {
			if verifier.isCorrectCheckChar(from: ssn) {
				verifier.birthDay = date
				let personNumberString = ssn.suffix(4).dropLast(1)
				if let personNumber = Int(personNumberString) {
					verifier.gender = personNumber % 2 == 0 ? .female : .male
					if personNumber > 2 && personNumber < 900 {
						verifier.validity = .validSSN
					} else if personNumber >= 900 {
						verifier.validity = .testSSN
					}
				}
			}
		}
		return verifier
	}

	private (set) var validity: Validity = .invalidSSN
	private (set) var gender: Gender = .undefined
	private (set) var birthDay: Date?

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

	private let checkSumChars = "0123456789ABCDEFHJKLMNPRSTUVWXY"
	private let checkSumDivider = 31

	private func isCorrectCheckChar(from ssn: String) -> Bool {
		let string = ssn.prefix(6) + ssn.suffix(4).dropLast(1)
		guard string.allSatisfy( { $0.isNumber }), let checkSum = Int(string) else {
			return false
		}
		let index = checkSum % checkSumDivider
		return checkSumChars[checkSumChars.index(checkSumChars.startIndex, offsetBy: index)] == ssn.last
	}

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
