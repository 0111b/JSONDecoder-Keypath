import Foundation

public extension JSONDecoder {

    /// Decode value at the keypath of the given type from the given JSON representation
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode.
    ///   - data: The data to decode from.
    ///   - keyPath: The JSON keypath
    /// - Returns: A value of the requested type.
    /// - Throws: An error if any value throws an error during decoding.
    func decode<T>(_ type: T.Type, from data: Data, keyPath: String) throws -> T where T : Decodable {
        userInfo[keyPathUserInfoKey] = keyPath
        return try decode(KeyPathWrapper<T>.self, from: data).object
    }
}

/// The keypath key in the `userInfo`
private let keyPathUserInfoKey = CodingUserInfoKey(rawValue: "keyPathUserInfoKey")!

/// Object which is representing value
private final class KeyPathWrapper<T: Decodable>: Decodable {

    enum KeyPathError: Error {
        case `internal`
    }

    /// Naive coding key implementation
    struct Key: CodingKey {
        init?(intValue: Int) {
            self.intValue = intValue
            stringValue = String(intValue)
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
            intValue = nil
        }

        let intValue: Int?
        let stringValue: String
    }


    init(from decoder: Decoder) throws {
        guard let keyPath = decoder.userInfo[keyPathUserInfoKey] as? String,
            let key = Key(stringValue: keyPath)
            else { throw KeyPathError.internal }

        let keyedContainer = try decoder.container(keyedBy: Key.self)
        object = try keyedContainer.decode(T.self, forKey: key)
    }
    let object: T
}
