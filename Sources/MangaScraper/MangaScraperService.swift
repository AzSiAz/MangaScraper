import Foundation

public class MangaScraperService {
    public static let shared = MangaScraperService()
    
    public var list: [Source]
    
    public init() {
        self.list = [NepNepSource.MangaSee123Source, NepNepSource.Manga4LifeSource]
    }
    
    public func search() async -> [SourcePaginatedSmallManga] {
        return []
    }
    
    public func getSource(sourceId: UUID) -> Source? {
        return list.first { $0.id == sourceId }
    }
}
