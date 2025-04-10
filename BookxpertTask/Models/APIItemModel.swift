//
//  APIItemModel.swift
//  BookxpertTask
//
//  Created by Alyx on 10/04/25.
//

import Foundation

struct APIItemModel: Codable {
    let id: String
    let name: String
    let data: [String: CodableValue]?
}

/// CodableValue is a wrapper to decode any value
enum CodableValue: Codable {
    case string(String)
    case int(Int)
    case double(Double)
    case dictionary([String: CodableValue])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let v = try? container.decode(String.self) {
            self = .string(v)
        } else if let v = try? container.decode(Double.self) {
            self = .double(v)
        } else if let v = try? container.decode(Int.self) {
            self = .int(v)
        } else if let v = try? container.decode([String: CodableValue].self) {
            self = .dictionary(v)
        } else {
            throw DecodingError.typeMismatch(CodableValue.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                debugDescription: "Not a supported value"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let v): try container.encode(v)
        case .int(let v): try container.encode(v)
        case .double(let v): try container.encode(v)
        case .dictionary(let v): try container.encode(v)
        }
    }
}
