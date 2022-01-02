// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mangaDexChapterImagesREST = try? newJSONDecoder().decode(MangaDexChapterImagesREST.self, from: jsonData)

import Foundation

// MARK: - MangaDexChapterImagesREST
struct MangaDexChapterImagesREST: Codable {
    let result: String?
    let response: String?
    let data: [MangaDexChapterImagesDatum]?
    let limit: Int?
    let offset: Int?
    let total: Int?
}

// MARK: - MangaDexChapterImagesDatum
struct MangaDexChapterImagesDatum: Codable {
    let id: String?
    let type: String?
    let attributes: MangaDexChapterImagesDatumAttributes?
    let relationships: [MangaDexChapterImagesRelationship]?
}

// MARK: - MangaDexChapterImagesDatumAttributes
struct MangaDexChapterImagesDatumAttributes: Codable {
    let volume: String?
    let chapter: String?
    let title: String?
    let translatedLanguage: String?
    let hash: String?
    let data: [String]?
    let dataSaver: [String]?
    let externalURL: String?
    let publishAt: String?
    let createdAt: String?
    let updatedAt: String?
    let version: Int?
}

// MARK: - MangaDexChapterImagesRelationship
struct MangaDexChapterImagesRelationship: Codable {
    let id: String?
    let type: String?
    let attributes: MangaDexChapterImagesRelationshipAttributes?
}

// MARK: - MangaDexChapterImagesRelationshipAttributes
struct MangaDexChapterImagesRelationshipAttributes: Codable {
    let username: String?
    let roles: [String]?
    let version: Int?
}
