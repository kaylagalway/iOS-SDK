import Foundation
#if canImport(PaymentsCore)
import PaymentsCore
#endif

enum CardClientError {

    static let domain = "CardClientErrorDomain"

    enum Code: Int {
        /// 0. An unknown error occured.
        case unknown

        /// 1. An error occured encoding an HTTP request body.
        case encodingError
    }

    static let encodingError = PayPalSDKError(
        code: Code.encodingError.rawValue,
        domain: domain,
        errorDescription: "An error occured encoding HTTP request body data. Contact developer.paypal.com/support."
    )
}
