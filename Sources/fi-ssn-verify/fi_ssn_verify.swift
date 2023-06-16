import Foundation

public struct SSNFiVerifier {

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

	public static func verify(ssn: String) -> SSNFiVerifier? {
		guard ssn.count == 11 else {
			return nil
		}
		var verifier = SSNFiVerifier()
		let centuryChar = ssn[ssn.index(ssn.startIndex, offsetBy: 6)]
		if verifier.isValidCenturyChar(centuryChar) {
			let date = verifier.dateFrom(dateString: String(ssn.prefix(6)), centuryChar: centuryChar)
		}
		return verifier
	}

	private (set) var isValid: Bool = false
	private (set) var isTestSSN: Bool = false
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
			return dateComponents.date
		}
		return nil
	}

	private func isValidCenturyChar(_ character: Character) -> Bool {
		if centuryChars.keys.contains(String(character)) {
			return true
		}
		return false
	}

	private func centuryFromCenturyChar(_ character: Character) -> Int? {
		centuryChars[String(character)]
	}
}
