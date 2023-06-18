// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import FinnishPIDVerifier

@main
struct PINVerifierTool: ParsableCommand {

	@Argument var pid: String

	mutating func run() throws {
		let verifier = FPIDVerifier.verify(pid: pid)
		switch verifier.validity {
			case .validPID:
				print("PID is valid Finnish PID")
			case .invalidPID:
				print("PID is invalid Finnish PID")
			case .testPID:
				print("PID is valid test PID")
		}
		if verifier.isValid {
			print("PID is valid and not a test PID")
			print("PID is for a person born in \(verifier.dateString!)")
			print("Full date is \(verifier.birthDay!.formatted(date: .complete, time: .omitted))")
			print("Gender of the PID holder is \(verifier.genderString)")
			print("Date elements: day: \(verifier.day!) month: \(verifier.month!) year: \(verifier.year!)")
		} else {
			print("PID is either test PID or invalid")
		}

		let constVerifier = FPIDVerifier.verify(pid: "010201-123N")
		if constVerifier == verifier {
			print("PIDs for \(verifier.) are ")
		}
	}
}
