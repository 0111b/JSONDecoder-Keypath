import XCTest
@testable import JSONDecoder_Keypath

struct Item: Codable, Equatable {
    let title: String
    let number: Int

    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.title == rhs.title && lhs.number == rhs.number
    }
}

class JSONDecoder_KeypathTests: XCTestCase {
    var decoder: JSONDecoder!

    override func setUp() {
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

    static var allTests = [
        ("Test Valid Decoding", testValidDecoding),
        ("Test Invalid Keypath", testValidDecoding),
        ("Test Invalid Object", testValidDecoding)
    ]
}
