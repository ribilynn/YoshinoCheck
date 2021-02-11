import Vapor

final class VersionController {
    
    var truthVersion = ""
    var lastUpdate: Date?
    
    let app: Application
    
    let updateThreshold: TimeInterval = 10 * 60
    
    init(app: Application) {
        self.app = app
        let _ = queryTruthVersion()
    }
    
    private func queryTruthVersion() -> EventLoopFuture<String> {
        app.client.get("https://starlight.kirara.ca/api/v1/info")
            .flatMapThrowing { clientResponse -> String in
                let version = try clientResponse.content.get(String.self, at: "truth_version")
                self.app.logger.trace("The truthVersion changed from \(self.truthVersion) to \(version).")
                self.truthVersion = version
                self.lastUpdate = Date()
                return version
            }
    }
    
    func checkNewest() -> EventLoopFuture<String> {
        if let last = lastUpdate,
           last.timeIntervalSince(last) < updateThreshold {
            app.logger.trace("The truthVersion is still \(self.truthVersion).")
            return app.client.eventLoop.makeSucceededFuture(self.truthVersion)
        } else {
            return self.queryTruthVersion()
        }
    }
}
