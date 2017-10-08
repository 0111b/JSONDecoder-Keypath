import XCTest
@testable import JSONDecoder_Keypath
//swiftlint:disable force_unwrapping
struct Item: Codable, Equatable {
    let title: String
    let number: Int

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.title == rhs.title && lhs.number == rhs.number
    }
}

class JSONDecoderKeypathTests: XCTestCase {
    var decoder: JSONDecoder!

    override func setUp() {
        super.setUp()
        decoder = JSONDecoder()
    }

    func testValidDecoding() {
        let json  = """
                    {
                        "custom": {
                                "title" : "Item title",
                                "number" : 2
                                }
                     }
                    """
        let jsonData = json.data(using: .utf8)!
        do {
            let object = try decoder.decode(Item.self, from: jsonData, keyPath: "custom")
            XCTAssertEqual(Item(title: "Item title", number: 2), object)
        } catch let error {
            XCTFail("Error thrown: \(error)")
        }
    }

    func testInvalidKeyPath() {
        let json  = """
                    {
                        "custom": {
                                "title" : "Item title",
                                "number" : 2
                                }
                     }
                    """

        let jsonData = json.data(using: .utf8)!
        XCTAssertThrowsError(try decoder.decode(Item.self, from: jsonData, keyPath: "invalid"))
    }

    func testInvalidObject() {
        let json  = """
                    {
                        "custom": {
                                "title" : "Item title",
                                "number" : "Invalid number"
                                }
                     }
                    """

        let jsonData = json.data(using: .utf8)!
        XCTAssertThrowsError(try decoder.decode(Item.self, from: jsonData, keyPath: "custom"))
    }

    func testObjectArray() {
        let json  = """
                    {
                        "custom": [
                            {
                                "title" : "Item title",
                                "number" : 2
                            }
                        ]
                     }
                    """
        let jsonData = json.data(using: .utf8)!
        do {
            let array = try decoder.decode([Item].self, from: jsonData, keyPath: "custom")
            let object = array.first
            XCTAssertNotNil(object)
            XCTAssertEqual(Item(title: "Item title", number: 2), object!)
        } catch let error {
            XCTFail("Error thrown: \(error)")
        }
    }

    func testValidNestedKeypath() {
        let json  = """
                    {
                        "level1": {
                            "level2": {
                                "title" : "Item title",
                                "number" : 2
                                }
                        }
                     }
                    """
        let jsonData = json.data(using: .utf8)!
        do {
            let object = try decoder.decode(Item.self, from: jsonData, keyPath: "level1.level2")
            XCTAssertEqual(Item(title: "Item title", number: 2), object)
        } catch let error {
            XCTFail("Error thrown: \(error)")
        }
    }

    func testInvalidNestedKeypath() {
        let json  = """
                    {
                        "level1": {
                            "level2": {
                                "title" : "Item title",
                                "number" : 2
                                }
                        }
                     }
                    """
        let jsonData = json.data(using: .utf8)!
        XCTAssertThrowsError(try decoder.decode(Item.self, from: jsonData, keyPath: "level1.invalid"))
    }

    func testCustomSeparator() {
        let json  = """
                    {
                        "level1": {
                            "level2": {
                                "title" : "Item title",
                                "number" : 2
                                }
                        }
                     }
                    """
        let jsonData = json.data(using: .utf8)!
        do {
            let object = try decoder.decode(Item.self, from: jsonData, keyPath: "level1/level2", keyPathSeparator: "/")
            XCTAssertEqual(Item(title: "Item title", number: 2), object)
        } catch let error {
            XCTFail("Error thrown: \(error)")
        }
    }

    static var allTests = [
        ("Test Valid Decoding", testValidDecoding),
        ("Test Invalid Keypath", testInvalidKeyPath),
        ("Test Invalid Object", testInvalidObject),
        ("Test Object Array", testObjectArray),
        ("Test Valid Nested Keypath", testValidNestedKeypath),
        ("Test InValid Nested Keypath", testInvalidNestedKeypath),
        ("Test Custom Separator", testCustomSeparator)
    ]
}
