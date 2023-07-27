//
//  FinnishPIDGenerator.swift
//  
//
//  Created by Antti Juustila on 27.7.2023.
//

import Foundation

public struct FinnishPIDGenerator {

	public var range: ClosedRange<Int> = 1900...1900
	public var validity: FinnishPID.Validity = .validPID

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

	public func generatePIDs(count: Int) -> [String] {
		var pids = [String]()
		for _ in 0..<count {
			if let pid = generatePID() {
				pids.append(pid)
			}
		}
		return pids
	}

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

	private func centuryChar(for year: Int) -> String? {
		let validCharsForYear = FinnishPID.centuryChars.filter({ (key, value) in
			(year / 100) * 100 == value
		})
		return validCharsForYear.randomElement()?.key
	}

}
