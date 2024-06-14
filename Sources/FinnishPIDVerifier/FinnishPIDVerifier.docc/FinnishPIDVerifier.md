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

### Getting started

Use the struct ``FinnishPID`` and the `FinnishPID.verify(pid:)` method to verify a Finnish PID. See below for an example of the usage.

```swift
let verifier = FinnishPID.verify(pid: "010101-123N")
if verifier.isValid {
   print("Is a valid Finnish PID")
} else {
   print("Invalid Finnish PID!)
}
/// prints:
/// Is a valid Finnish PID
print(verifier)
/// prints (when locale is fi): 
/// Oikeellinen hetu: 010101-123N, syntynyt: 1.1.1901, sukupuoli: mies
```

The returned `verifier` struct has properties you can use to query the result from the verification. See the ``FinnishPID`` struct documentation for details

The library is localized in Finnish, Swedish and English. Date formats are fixed, but `genderString` and `description` return strings for these languages.

The library also includes a generator to generate valid and test PIDs. Use the `FinnishPIDGenerator` to generate PIDs for testing and development.


Add the depencendy to this package in your `Package.swift` using the URL to this repository:

```Swift
   .package(url: "https://github.com/anttijuu/FinnishPIDVerifier.git", branch: "main"),
```

Alternatively, use Xcode: File > Add Packages....


- ``FinnishPID``
- ``FinnishPIDGenerator``

