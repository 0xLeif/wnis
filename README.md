# wnis

## Resources

- [What's new in Swift?](https://www.whatsnewinswift.com/?from=4.2&to=5.5)
- [Swift CHANGELOG](https://github.com/apple/swift/blob/main/CHANGELOG.md)
- [Swift Evolution](https://github.com/apple/swift-evolution/tree/master/proposals)

## Usage

```
$ swift run

What's new in Swift (5.0, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6):
```

## Example Usage

```
What's new in Swift (5.0, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6): 5.5

# What's new in Swift 5.5?

Start (y/n): y

SE-0296: Async await (y/n): y

	[Name]: Async await
	[Evolution ID]: SE-0296

	[Description]

	Modern Swift development involves a lot of asynchronous (or "async") programming using closures and completion handlers, but these APIs are hard to use. This gets particularly problematic when many asynchronous operations are used, error handling is required, or control flow between asynchronous calls gets complicated. This proposal describes a language extension to make this a lot more natural and less error prone.

	See an example (y/n): y

	[Code]

	```
	class Teacher {
	  init(hiringFrom: College) async throws {
	    ...
	  }

	  private func raiseHand() async -> Bool {
	    ...
	  }
	}
	```

	See an example (y/n):
```
