//
//  File.swift
//  
//
//  Created by Antti Juustila on 18.6.2023.
//

import Foundation

/// FPIDVerifier implements the `Comparable` conformance by comparing the PIDs.
extension FPIDVerifier: Comparable {

	/// Compares if two PIDs are the same.
	///
	/// - Parameter lsh: Left hand side variable.
	/// - Parameter rhs: Right hand side variable.
	/// - Returns: True if the PIDs are the same PID.
	public static func == (lhs: FPIDVerifier, rhs: FPIDVerifier) -> Bool {
		return lhs.pid == rhs.pid
	}

	public static func < (lhs: FPIDVerifier, rhs: FPIDVerifier) -> Bool {
		guard lhs.validity == .validPID && rhs.validity == .validPID else {
			return false
		}
		guard lhs.birthDay != rhs.birthDay else {
			return lhs.birthDay! < rhs.birthDay!
		}
		let lhsPersonNumber = lhs.pid.suffix(4)
	}
}
