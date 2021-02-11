import Vapor

public func configure(_ app: Application) throws {
    
    let versionController = VersionController(app: app)
    
    // Register Routers
    app.get { req in
        return "たべるンゴ🍎"
    }

    app.get("version") { _ -> EventLoopFuture<String> in
        versionController.checkNewest()
    }
}
