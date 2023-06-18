# ``FinnishPIDVerifier``

This Swift library verifies a Finnish Person ID (PID) strings (in Finnish: "henkilötunnus").

## Overview

This Swift library verifies a Finnish Person ID (PID) strings (in Finnish: "henkilötunnus").

Finnish PIDs are strings in format `ddmmyyAnnnX`, where:

* dd is the day of birth,
* mm is the month of birth,
* yy is the last two digits of the year of birth,
* A is the century character, indicating which century (1800, 1900 or 2000) the person was born,
* nnn is the individual daily number given to persons born on that day, from range 002-899 (inclusive),
* Even numbers are for females, odd numbers for males,
* Values >= 900 are used for test PIDs only,
* X is a control character, calculated from ddmmyynnn and using a lookup table.

For details, see [https://dvv.fi/henkilotunnus](https://dvv.fi/henkilotunnus).

## Topics

### Usage

Use the struct ``FPIDVerifier`` and the `verify(pid:)` method to verify a Finnish PID:

```Swift
let verifier = FPIDVerifier.verify(pid: "010101-123N")
if verifier.isValid {
	print("Is a valid Finnish PID")
} else {
	print("Invalid Finnish PID!)
}
// prints:
// Is a valid Finnish PID
print(verifier)
// prints (when locale is fi): 
// Oikeellinen hetu: 010101-123N, syntynyt: 1.1.1901, sukupuoli: Mies
```

The returned `verifier` struct has properties you can use to query the result from the verification:

* `isValid`, is `true` if the PID was a valid PID not in the test range.
* `validity` enumeration `Validity`, either `validPID`, `invalidPID` or `testPID`.
* `gender` enumeration `Gender`, either `.female`, `.male` or `.undefined` if not a valid PID. Has also value `.other` but that is not used in Finnish PIDs.
* `birthDay`, a `Date` object or `nil` if PID was not valid.
* `dateString`, the birthday of the person in format "dd.mm.yyyy" or `nil` if PID is not valid nor test PID.
* `genderString`, the gender of the person as a string.
* `year`, `month` and `day` of the birthday, or `nil` if PID was not valid.
* `description`, providing a string representation of the verification, e.g. (in English locale):

```
Valid PID 210911+0785: born: 21.9.1811, gender: Female
Test PID: 211123A965F: born: 21.11.2023, gender: Male
```

The library is localized to English and Finnish. Date formats are fixed, but `genderString` and `description` return strings for these languages.

### Using in your projects

Add the depencendy to this package in your `Package.swift` using the URL to this repository, or using Xcode (File > Add Packages...).

### Getting started

- ``FPIDVerifier``

