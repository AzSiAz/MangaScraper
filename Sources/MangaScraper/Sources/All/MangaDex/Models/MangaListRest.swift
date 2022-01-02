// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mangaDexMangaListEmpty = try? newJSONDecoder().decode(MangaDexMangaListEmpty.self, from: jsonData)

import Foundation

// MARK: - MangaDexMangaListEmpty
struct MangaDexMangaListRest: Codable {
    let result: String?
    let response: String?
    let data: [MangaDexMangaListDatum]?
    let limit: Int?
    let offset: Int?
    let total: Int?
}

// MARK: - MangaDexMangaListDatum
struct MangaDexMangaListDatum: Codable {
    let id: String?
    let type: String?
    let attributes: MangaDexMangaListDatumAttributes?
    let relationships: [MangaDexMangaListRelationship]?
}

// MARK: - MangaDexMangaListDatumAttributes
struct MangaDexMangaListDatumAttributes: Codable {
    let title: MangaDexMangaListTitle?
    let altTitles: [MangaDexMangaListAltTitle]?
    let attributesDescription: MangaDexMangaListDescription?
    let isLocked: Bool?
    let links: MangaDexMangaListLinks?
    let originalLanguage: String?
    let lastVolume: String?
    let lastChapter: String?
    let publicationDemographic: String?
    let status: String?
    let year: Int?
    let contentRating: String?
    let tags: [MangaDexMangaListTag]?
    let state: String?
    let createdAt: String?
    let updatedAt: String?
    let version: Int?
}

// MARK: - MangaDexMangaListAltTitle
struct MangaDexMangaListAltTitle: Codable {
    let en: String?
    let ru: String?
    let ja: String?
    let ko: String?
    let zh: String?
    let vi: String?
    let he: String?
    let fa: String?
    let ar: String?
    let th: String?
    let ne: String?
}

// MARK: - MangaDexMangaListDescription
struct MangaDexMangaListDescription: Codable {
    let en: String?
    let ru: String?
    let pl: String?
    let pt: String?
    let it: String?
    let tr: String?
    let es: String?
    let fr: String?
    let zh: String?
    let esLa: String?
}

// MARK: - MangaDexMangaListLinks
struct MangaDexMangaListLinks: Codable {
    let al: String?
    let ap: String?
    let bw: String?
    let kt: String?
    let mu: String?
    let amz: String?
    let ebj: String?
    let mal: String?
    let raw: String?
    let engtl: String?
    let cdj: String?
    let nu: String?
}

// MARK: - MangaDexMangaListTag
struct MangaDexMangaListTag: Codable {
    let id: String?
    let type: String?
    let attributes: MangaDexMangaListTagAttributes?
}

// MARK: - MangaDexMangaListTagAttributes
struct MangaDexMangaListTagAttributes: Codable {
    let name: MangaDexMangaListName?
    let group: String?
    let version: Int?
}

// MARK: - MangaDexMangaListName
struct MangaDexMangaListName: Codable {
    let en: String?
}

// MARK: - MangaDexMangaListTitle
struct MangaDexMangaListTitle: Codable {
    let en: String?
    let zh: String?
}

// MARK: - MangaDexMangaListRelationship
struct MangaDexMangaListRelationship: Codable {
    let id: String?
    let type: String?
    let attributes: MangaDexMangaListRelationshipAttributes?
    let related: String?
}

// MARK: - MangaDexMangaListRelationshipAttributes
struct MangaDexMangaListRelationshipAttributes: Codable {
    let name: String?
    let imageURL: String?
    let twitter: String?
    let pixiv: String?
    let melonBook: String?
    let fanBox: String?
    let booth: String?
    let nicoVideo: String?
    let skeb: String?
    let fantia: String?
    let tumblr: String?
    let youtube: String?
    let website: String?
    let createdAt: String?
    let updatedAt: String?
    let version: Int?
    let attributesDescription: String?
    let volume: String?
    let fileName: String?
    let weibo: String?
    let naver: String?
}
