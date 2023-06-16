# Finnish Person ID Verifier

This Swift library verifies a Finnish Person ID (PID) strings.

Finnish PIDs are strings in format "ddmmyyAnnnX", where:

* dd is the day of birth,
* mm is the month of birth,
* yy is the last two digits of the year of birth,
* A is the century character, indicating which century (1800, 1900 or 2000) the person was born,
* nnn is the individual daily number given to persons born on that day, from range 002-899 (inclusive),
  * Even numbers are for females, odd numbers for males,
  * Values >= 900 are used for test PIDs only,
* X is a control character, calculated from ddmmyynnn and using a lookup table.

For details, see [https://dvv.fi/henkilotunnus](https://dvv.fi/henkilotunnus).


## Usage

```Swift
let verifier = FiPIDVerifier.verify(pid: "010101-123N")
if verifier.isValid {
   print("Is a valid Finnish PID")
} else {
   print("Invalid Finnish PID!)
}
```
The returned `verifier` struct has properties you can use to query the result from the verification:

* `isValid`, is `true` if the PID was a valid PID not in the test range.
* `validity` enumeration of the input to `verify(pid:)`, either `validPID`, `invalidPID` or `testPID`.
* `gender` enumeration of the person, based on the PID, or `.undefined` if not a valid PID.
* `birthDay`, a `Date` object or `nil` if PID was not valid.
* `dateString`, the birthday of the person in format "dd.mm.yyyy" or `nil` if PID is not valid/test PID.
* `genderString`, the gender of the person as a string.
* `year`, `month` and `day` of the birthday, or `nil` if PID was not valid.
* `description`, having a string representation of the verification, e.g.:

```
Valid PID 210911+0785: born: 21.9.1811, gender: Female
Test PID: 211123A965F: born: 21.11.2023, gender: Male
```

## Tests

The Tests folder contains tests you can use to test the implementation with generated valid Finnish PIDs as well as some test and invalid PIDS.


## Dependencies

Depends on Swift `Foundation`.


## Using in your projects

Add the depencendy to this package in your `Package.swift` or using Xcode.


## License

* MIT LICENSE

Copyright (c) 2023 Antti Juustila

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.





