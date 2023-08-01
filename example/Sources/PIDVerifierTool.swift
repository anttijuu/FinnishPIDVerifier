// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import FinnishPIDVerifier

/// An example for how to use the `FPIDVerifier`.
/// Note that this command line tool is not localized, contrary to `FinnishPIDVerifier` library,
/// so do not expect correct locale specific output from here.
@main
struct PIDVerifierTool: ParsableCommand {

	static var configuration = CommandConfiguration(
		abstract: "A tool for verifying and generating Finnish PIDS.",
		usage: """
			PIDVerifierTool verify --pid 010101-123N
			PIDVerifierTool generate --count 10 --real
			""",
		subcommands: [Verify.self, Generate.self],
		defaultSubcommand: Verify.self)

	mutating func run() throws {
		// Empty, subcommands do the work.
	}

}

extension PIDVerifierTool {

	struct Verify: ParsableCommand {
		@Option(help: "The PID to verify") var pid: String

		mutating func run() throws {
			print("Verifying \(pid)...")
			let verifier = FinnishPID.verify(pid: pid)
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
			}
		}
	}

	struct Generate: ParsableCommand {
		/// Generates count of PIDs.
		@Option(help: "The count of PIDs to generate") var count: Int = 10

		/// Generates real or test (false) PIDs.
		@Flag(help: "Generates either test or real PIDs") var real = false

		mutating func run() throws {
			guard count > 0 else {
				print("Count of PIDS to generate must be > 0")
				return
			}
			let kind = real ? "real" : "test"
			print("Generating \(count) \(kind) PIDs")
			var generator = FinnishPIDGenerator()
			generator.validity = real ? .validPID : .testPID
			let pids = generator.generatePIDs(count: count)
			for pid in pids {
				print("\(pid)")
			}
		}
	}
}
