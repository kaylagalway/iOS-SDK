import UIKit

public struct HTTPResponse {
    public var status: Int
    public var headers: [AnyHashable: Any]
    public var body: Data?
    public var error: Error?

    public var isSuccessful: Bool {
        (200...299).contains(status)
    }

    init(status: Int, headers: [AnyHashable: Any] = [:], body: Data? = nil, error: Error? = nil) {
        self.status = status
        self.headers = headers
        self.body = body
        self.error = error
    }
}
