import XCTest
import PaymentsCore
@testable import PayPalDataCollector

class PayPalDataCollector_Tests: XCTestCase {

    private let sandboxConfig = CoreConfig(clientID: "", environment: .sandbox)
    private let productionConfig = CoreConfig(clientID: "", environment: .production)

    private var deviceInspector = MockDeviceInspector()
    private var magnesSDK = MockMagnesSDK()

    func testCollectDeviceData_setsMagnesEnvironmentToSANDBOX() {
        let sut = PayPalDataCollector(config: sandboxConfig, magnesSDK: magnesSDK, deviceInspector: deviceInspector)
        _ = sut.collectDeviceData()

        XCTAssertEqual(.SANDBOX, magnesSDK.capturedSetupParams?.env)
    }

    func testCollectDeviceData_setsMagnesEnvironmentToLIVE() {
        let sut = PayPalDataCollector(config: productionConfig, magnesSDK: magnesSDK, deviceInspector: deviceInspector)
        _ = sut.collectDeviceData()

        XCTAssertEqual(.LIVE, magnesSDK.capturedSetupParams?.env)
    }

    func testCollectDeviceData_setsMagnesAppGUIDToTheCurrentDeviceID() {
        deviceInspector.stubPayPalDeviceIdentifierWithValue("sample_device_identifier")

        let sut = PayPalDataCollector(config: sandboxConfig, magnesSDK: magnesSDK, deviceInspector: deviceInspector)
        _ = sut.collectDeviceData()

        XCTAssertEqual("sample_device_identifier", magnesSDK.capturedSetupParams?.appGuid)
    }

    func testCollectDeviceData_disablesMagnesRemoteConfiguration() {
        let sut = PayPalDataCollector(config: sandboxConfig, magnesSDK: magnesSDK, deviceInspector: deviceInspector)
        _ = sut.collectDeviceData()

        XCTAssertEqual(false, magnesSDK.capturedSetupParams?.isRemoteConfigDisabled)
    }

    func testCollectDeviceData_disablesMagnesBeacon() {
        let sut = PayPalDataCollector(config: sandboxConfig, magnesSDK: magnesSDK, deviceInspector: deviceInspector)
        _ = sut.collectDeviceData()

        XCTAssertEqual(false, magnesSDK.capturedSetupParams?.isBeaconDisabled)
    }

    func testCollectDeviceData_setsMagnesSourceToPAYPAL() {
        let sut = PayPalDataCollector(config: sandboxConfig, magnesSDK: magnesSDK, deviceInspector: deviceInspector)
        _ = sut.collectDeviceData()

        XCTAssertEqual(.PAYPAL, magnesSDK.capturedSetupParams?.source)
    }

    func testCollectDeviceData_forwardsJSONWithMagnesClientMetadataIDAsACorrelationID() {
        let args = CollectDeviceDataArgs(payPalClientMetadataId: "", additionalData: ["sample": "data"])
        let magnesResult = MockMagnesSDKResult(paypalClientMetaDataId: "new_client_metadata_id")
        magnesSDK.stubCollectDeviceData(forArgs: args, withValue: magnesResult)

        let sut = PayPalDataCollector(config: sandboxConfig, magnesSDK: magnesSDK, deviceInspector: deviceInspector)
        let result = sut.collectDeviceData(additionalData: ["sample": "data"])

        let expected = """
            {"correlation_id":"new_client_metadata_id"}
        """.trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertEqual(expected, result)
    }
}
