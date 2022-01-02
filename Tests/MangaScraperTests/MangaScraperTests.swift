import XCTest
@testable import MangaScraper

final class MangaScraperTests: XCTestCase {
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MangaScraperService.shared.getSource(sourceId: UUID(uuidString: "FFAECF22-DBB3-4B13-B4AF-665DC31CE775")!)?.id, NepNepSource.MangaSee123Source.id)
        XCTAssertEqual(MangaScraperService.shared.getSource(sourceId: UUID(uuidString: "B6127CD7-A9C0-4610-8491-47DFCFD90DBC")!)?.id, NepNepSource.Manga4LifeSource.id)
        XCTAssertEqual(MangaScraperService.shared.getSource(sourceId: UUID(uuidString: "3599756d-8fa0-4ca2-aafc-096c3d776ae1")!)?.id, MangaDex.shared.id)
//    https://api.mangadex.org/chapter?manga=&ids[]=adf692f8-0959-4fca-b34f-a8514634bff2&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&contentRating[]=pornographic&includes[]=scanlation_group&includes[]=user
        do {
            let d = try await MangaDex.shared.fetchChapterImages(mangaId: "b1461071-bfbb-43e7-a5b6-a7ba5904649f", chapterId: "adf692f8-0959-4fca-b34f-a8514634bff2")
            print(d)
        } catch {
            print(error)
        }
    }
}
