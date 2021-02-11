@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    
    func testVersion() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "version") { res in
            print(res.body.string)
        }
    }
}
