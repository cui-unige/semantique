import XCTest
@testable import semantique

class semantiqueTests: XCTestCase {
    func test1() throws {
        do {
            let module = try parse(what: "Examples/ex1.anzen")
            print(module.debugDescription)
        } catch let e {
            print(e)
            throw e
        }
    }


    static var allTests = [
        ("test1", test1),
    ]
}
