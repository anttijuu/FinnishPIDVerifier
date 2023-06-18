//
//  File.swift
//  
//
//  Created by Antti Juustila on 18.6.2023.
//

import Foundation

extension FPIDVerifier: Equatable {

	/// Compares if two PIDs are the same.
	///
	/// - Parameter lsh Left hand side variable.
	/// - Parameter rhs Right hand side variable.
	/// - Returns: True if the PIDs are the same PID.
	public static func == (lhs: FPIDVerifier, rhs: FPIDVerifier) -> Bool {
		return lhs.pid == rhs.pid
	}

	/// Compares if two PIDs are not the same.
	///
	/// - Parameter lsh Left hand side variable.
	/// - Parameter rhs Right hand side variable.
	/// - Returns: True if the PIDs are not the same PID.
	public static func != (lhs: FPIDVerifier, rhs: FPIDVerifier) -> Bool {
		return lhs.pid != rhs.pid
	}

}
