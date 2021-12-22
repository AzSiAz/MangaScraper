import Foundation

public class MangaScraperService {
    public static let shared = MangaScraperService()
    
    public var list: [Source] = [NepNepSource.MangaSee123Source, NepNepSource.Manga4LifeSource]
    
    public func search(query: String, page: Int = 1, sourceIds: [UUID]) async -> [UUID: SourcePaginatedSmallManga] {
        var result = [UUID: SourcePaginatedSmallManga]()

        for id in sourceIds {
            do {
                guard let source = getSource(sourceId: id) else { continue }
                result[id] =  try await source.fetchSearchManga(query: query, page: 1)
            } catch (let err) {
                print(err)
                result[id] = SourcePaginatedSmallManga(mangas: [], hasNextPage: false)
            }
        }

        return result
    }
    
    public func getSource(sourceId: UUID) -> Source? {
        return list.first { $0.id == sourceId }
    }
}
