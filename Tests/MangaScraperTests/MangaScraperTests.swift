import XCTest
@testable import MangaScraper

final class MangaScraperTests: XCTestCase {
    func testExample() async throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MangaScraperService.shared.getSource(sourceId: UUID(uuidString: "FFAECF22-DBB3-4B13-B4AF-665DC31CE775")!)?.id, NepNepSource.MangaSee123Source.id)
        XCTAssertEqual(MangaScraperService.shared.getSource(sourceId: UUID(uuidString: "B6127CD7-A9C0-4610-8491-47DFCFD90DBC")!)?.id, NepNepSource.Manga4LifeSource.id)
        
//      https://mangasee123.com/manga/The-Magical-Revolution-of-the-Reincarnated-Princess-and-the-Genius-Young-Lady
//      https://mangasee123.com/read-online/The-Magical-Revolution-of-the-Reincarnated-Princess-and-the-Genius-Young-Lady-chapter-11.1-page-1.html
//      The-Magical-Revolution-of-the-Reincarnated-Princess-and-the-Genius-Young-Lady The-Magical-Revolution-of-the-Reincarnated-Princess-and-the-Genius-Young-Lady-chapter-11.1
        do {
            let c1 = try await NepNepSource.MangaSee123Source.fetchChapterImages(
                mangaId: "The-Magical-Revolution-of-the-Reincarnated-Princess-and-the-Genius-Young-Lady",
                chapterId: "The-Magical-Revolution-of-the-Reincarnated-Princess-and-the-Genius-Young-Lady-chapter-11.1"
            )
            print(c1)
            let c = try await NepNepSource.MangaSee123Source.fetchChapterImages(
                mangaId: "The-Magical-Revolution-of-the-Reincarnated-Princess-and-the-Genius-Young-Lady",
                chapterId: "The-Magical-Revolution-of-the-Reincarnated-Princess-and-the-Genius-Young-Lady-chapter-11.2"
            )
            print(c)
        } catch {
            print(error)
        }
    }
}
