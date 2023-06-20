//
//  FinnishPID+Comparable.swift
//  
//
//  Created by Antti Juustila on 18.6.2023.
//

import Foundation

/// FinnishPID implements the `Comparable` conformance by comparing the PIDs.
extension FinnishPID: Comparable {

	/// Compares if two PIDs are the same.
	///
	/// - Parameter lsh: Left hand side variable.
	/// - Parameter rhs: Right hand side variable.
	/// - Returns: True if the PIDs are the same PID.
	public static func == (lhs: FinnishPID, rhs: FinnishPID) -> Bool {
		return lhs.pid == rhs.pid
	}

	
	/// Compares the birthDays and daily person numbers of a valid PID.
	///
	/// Comparison is done for valid PIDs so that a person born earlier is smaller. If the birthdays
	/// are the same, the sequence number of persons born that day is compared, smaller number
	/// coming first.
	///
	/// If sorting a container that has test or invalid PIDs, they are left at the end, unsorted.
	///
	/// - Parameters:
	///   - lhs: Left side PID to compare.
	///   - rhs: Right side PID to compare.
	/// - Returns: True if left side is smaller than right side.
	public static func < (lhs: FinnishPID, rhs: FinnishPID) -> Bool {
		guard lhs.validity == .validPID && rhs.validity == .validPID else {
			return false
		}
		guard lhs.birthDay == rhs.birthDay else {
			return lhs.birthDay! < rhs.birthDay!
		}
		if let lhsIndividualNumber = lhs.individualNumber, let rhsIndividualNumber = rhs.individualNumber {
			return lhsIndividualNumber < rhsIndividualNumber
		}
		return false
	}
}
