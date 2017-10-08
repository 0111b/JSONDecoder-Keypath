# JSONDecoder-Keypath

[![CircleCI](https://img.shields.io/circleci/project/github/0111b/JSONDecoder-Keypath.svg)](https://circleci.com/gh/0111b/JSONDecoder-Keypath) [![Isues](https://img.shields.io/github/issues/0111b/JSONDecoder-Keypath.svg)](https://github.com/0111b/JSONDecoder-Keypath/issues) ![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-0.1.0-orange.svg)

Add nested key path support to the Swift.JSONDecoder

<!-- TOC -->

- [Rationale](#rationale)
- [Usage](#usage)
- [Under the hood](#under-the-hood)
- [Installation](#installation)
    - [Swift Package Manager:](#swift-package-manager)
- [Conclusion](#conclusion)
- [In the plans:](#in-the-plans)

<!-- /TOC -->

### Rationale

At the time of writing, I found that most of the popular frameworks (mostly network wrappers) when dealing with keypath do some terrible things.

So, suppose we have a `Decodable` (`Codable`) object but in the API response we are getting it under some custom path.  Most of the solutions already have interface to extract object by keypath and also added `Codable` support. But the problem is that in almost all cases that I've seen implementation is next:
1. Extract  `[String: Any]` from the `Data` with `JSONSerialization`
2. Follow keypath in this dictionary
3. Convert given object to `Data`
4. Use `JSONDecoder` to parse object

It is obvious that the conversion of data back and forth is an extra waste of resources. In addition, on large amounts of data, this is highly not advisable.

This package eliminates first 3 steps.

### Usage

Say you have a `Item` model

```Swift
struct Item: Codable {
 ...
}
```

And we have a following JSON:

```JSON
{
 "foo" : <actual object>
}
```

To parse this you need to write:

```Swift
let jsonData: Data = ...
let item = try decoder.decode(Item.self, from: jsonData, keyPath: "foo")
```

Nested keypath are also supported:

```Swift
let item = try decoder.decode(Item.self, from: jsonData, keyPath: "foo.bar")
```

Keypath separator can be configured:

```Swift
let item = try decoder.decode(Item.self, from: jsonData, keyPath: "foo/bar", keyPathSeparator: "/")
```

### Under the hood

Package adds new method to the `JSONDecoder`

```Swift
func decode<T>(_ type: T.Type,
                   from data: Data,
                   keyPath: String,
                   keyPathSeparator separator: String = ".") throws -> T where T : Decodable
```

In this call `keypath` is stored in the `JSONDecoder.userInfo` and then standard `decode` method is called with private class `KeyPathWrapper<T>` as a type parameter. In the `KeyPathWrapper` constructor keypath data is fetched from the `userInfo` and decoder is traversed with this values. After that original type is decoded.

### Installation

#### Swift Package Manager:

Add the line `.Package(url: "https://github.com/0111b/JSONDecoder-Keypath.git")` to your `Package.swift`

### Conclusion
Mostly this is a naive implementation of the custom object encoding and took from me no more than a few hours. But it is showing that we must think how we are working with provided API's and not be lazy to look under the hood

### In the plans: 
- [ ] Extend unit tests
- [ ] Add cocoapods spec 
