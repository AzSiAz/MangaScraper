//
//  File.swift
//  
//
//  Created by Stef on 02/01/2022.
//

import Foundation
import SwiftyJSON


public struct MangaDex: Source {
    public static let shared = MangaDex.init()
    
    public var name: String = "MangaDex"
    public var id: UUID = UUID(uuidString: "3599756d-8fa0-4ca2-aafc-096c3d776ae1")!
    public var versionNumber: Float = 1.0
    public var updatedAt: Date = Date.from(year: 2022, month: 01, day: 02)
    public var lang: SourceLang = .all
    public var icon: String = "https://mangadex.org/favicon.ico"
    public var baseUrl: String = "https://api.mangadex.org"
    public var supportsLatest: Bool = true
    public var headers = [String : String]()
    public var nsfw: Bool = true
    
    public func fetchPopularManga(page: Int) async throws -> SourcePaginatedSmallManga {
        return try await getMangaList(page: page, query: "order[followedCount]=desc")
    }
    
    public func fetchLatestUpdates(page: Int) async throws -> SourcePaginatedSmallManga {
        return try await getMangaList(page: page)
    }
    
    public func fetchSearchManga(query: String, page: Int) async throws -> SourcePaginatedSmallManga {
        return try await getMangaList(page: page, query: "title=\(query)")
    }
    
    public func fetchMangaDetail(id: String) async throws -> SourceManga {
        let html = try await fetchHtml(url: "\(baseUrl)/manga/\(id)?&includes[]=author&includes[]=artist&includes[]=cover_art")
        guard let data = html.data(using: .utf8) else { throw SourceError.parseError(error: "[MangaDex] Error getting data for `MangaDexMangaDetailREST`")}
        
        guard let detail = try JSONDecoder().decode(MangaDexMangaDetailREST.self, from: data).data else { throw SourceError.fetchError }
        
        let title = detail.attributes?.title?.en
        
        let coverFileName = detail.relationships?
            .filter { $0.type == "cover_art" }
            .first?.attributes?.fileName
        
        let genres = detail.attributes?.tags?
            .map({ $0.attributes?.name?.en })
            .compactMap({$0})
        
        let authors = detail.relationships?
            .filter { $0.type == "author" }
            .compactMap { $0.attributes?.name }
        
        let altTitle = detail.attributes?.altTitles?.compactMap { $0.en }
        
        var status: SourceMangaCompletion {
            let status = detail.attributes?.status ?? "ongoing"
            switch status {
            case "completed": return SourceMangaCompletion.complete
            case "ongoing": return SourceMangaCompletion.ongoing
            default: return SourceMangaCompletion.unknown
            }
        }
        
        var type: SourceMangaType {
            switch detail.attributes?.originalLanguage {
            case "ko": return SourceMangaType.manhwa
            case "jp": return SourceMangaType.manga
            case "zh": return SourceMangaType.manhua
            default: return SourceMangaType.unknown
            }
        }
        
        return SourceManga(
            id: detail.id!,
            title: title ?? "No title found",
            cover: getCover(mangaId: id, fileName: coverFileName),
            genres: genres ?? [],
            authors: authors ?? [],
            alternateNames: altTitle ?? [],
            status: status,
            synopsis: detail.attributes?.description?.en ?? "",
            chapters: try await fetChapters(mangaId: detail.id!),
            type: type
        )
    }
    
    public func fetchChapterImages(mangaId: String, chapterId: String) async throws -> [SourceChapterImage] {
        //
        let html = try await fetchHtml(url: "https://api.mangadex.org/at-home/server/\(chapterId)?forcePort443=false")
        guard let data = html.data(using: .utf8) else { throw SourceError.parseError(error: "[MangaDex] Error getting data for `MangaDexMangaDetailREST`")}

        guard let json = try? JSONDecoder().decode(MangaDexChapterImagesREST.self, from: data) else { throw SourceError.parseError(error: "[MangaDex] Error parsing json response") }
        guard let hash = json.chapter?.hash else { throw SourceError.websiteError }
        guard let baseURL = json.baseURL else { throw SourceError.websiteError }

        return try json.chapter?.data?.enumerated().map { (index, c) throws -> SourceChapterImage in
            return SourceChapterImage(index: index, imageUrl: "\(baseURL)/data/\(hash)/\(c)")
        }.compactMap({ $0 }) ?? []
    }
    
    public func mangaUrl(mangaId: String) -> URL {
        return URL(string: "https://mangadex.org/title/\(mangaId)")!
    }
    
    public func checkUpdates(mangaIds: [String]) async throws {
        throw SourceError.notImplemented
    }
    
    // TODO: MangaDex still can't order manga by latest update, workaround is to fetch last 20 chapter and fetch associated manga (no grouped chapter update), so not for now, let hope it's fixed soon
    private func getMangaList(page: Int, query: String? = nil) async throws -> SourcePaginatedSmallManga {
        let page = page < 1 ? 1 : page
        let offset = (page - 1) * 20;

        let html = try await fetchHtml(url: "\(baseUrl)/manga?limit=20&offset=\(offset)&includes[]=cover_art\((query != nil) ? "&\(query!)" : "")")
        guard let data = html.data(using: .utf8) else { throw SourceError.parseError(error: "[MangaDex] Error getting data for `MangaDexMangaListRest`")}

        let mangaDexMangaList = try JSONDecoder().decode(MangaDexMangaListRest.self, from: data)
        let hasNextPage = mangaDexMangaList.offset ?? 0 < mangaDexMangaList.total ?? 0
        
        let mangas = mangaDexMangaList.data?.map { d -> SourceSmallManga in
            let title = d.attributes?.title?.en
            let fileName = d.relationships?
                .filter { $0.type == "cover_art" }
                .first?.attributes?.fileName
            
            return SourceSmallManga(id: d.id!, title: title ?? "No title Found", thumbnailUrl: getCover(mangaId: d.id!, fileName: fileName))
        }
        
        return SourcePaginatedSmallManga(mangas: mangas ?? [], hasNextPage: hasNextPage)
    }
    
    private func getCover(mangaId: String, fileName: String?) -> String {
        fileName != nil ? "https://uploads.mangadex.org/covers/\(mangaId)/\(fileName!).256.jpg" : "https://i.imgur.com/6TrIues.png"
    }
    
    private func fetChapters(mangaId: String) async throws -> [SourceChapter] {
        var chapters = [SourceChapter]()
        var shouldRepeat = true
        var offset = 0
        
        repeat {
            let oldOffset = offset
            let html = try await fetchHtml(url: getChapterRequestUrl(mangaId: mangaId, offset: oldOffset))
            guard let data = html.data(using: .utf8) else { throw SourceError.parseError(error: "[MangaDex] error getting data for `mangaDexChapterListREST` ") }
            
            let json = try JSONDecoder().decode(MangaDexChapterListREST.self, from: data)

            let limit = json.limit ?? 500
            
            
            chapters += try json.data?.map { d throws -> SourceChapter in
                let volume = d.attributes?.volume != nil ? "Volume \(d.attributes!.volume!) " : ""
                let chapter = d.attributes?.chapter != nil ? d.attributes!.chapter! : "0"
                let chapterTitle = d.attributes?.title != nil ? " - \(d.attributes!.title!)" : ""
                
                let title = "\(volume)Chapter \(chapter)\(chapterTitle)"
                let date = try Date(d.attributes!.publishAt!, strategy: .iso8601)
                
                return SourceChapter(
                    name: title,
                    id: d.id!,
                    dateUpload: date
                )
            }.compactMap({ $0 }) ?? []

            shouldRepeat = (limit + offset) < json.total ?? 0
            offset += limit
        } while shouldRepeat
        
        return chapters
    }
    
    private func getChapterRequestUrl(mangaId: String, offset: Int = 0) -> String {
        "\(baseUrl)/manga/\(mangaId)/feed?includes[]=scanlation_group&includes[]=user&limit=500&offset=\(offset)&translatedLanguage[]=en&order[volume]=desc&order[chapter]=desc"
    }
    
    private func fetchHtml(url: String) async throws -> String {
        guard let url = URL(string: url) else { throw "Not a url: \(url)" }
        print(url.absoluteString)

        var req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        headers.forEach { key, value in
            req.setValue(value, forHTTPHeaderField: key)
        }

        let (data, _) = try await URLSession.shared.data(for: req)
        guard !data.isEmpty else { throw SourceError.websiteError }

        return String(decoding: data, as: UTF8.self)
    }
}
