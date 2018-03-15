import XCTest
@testable import semantique

class semantiqueTests: XCTestCase {

    func testExercises1() throws {
        do {
            for expression in expressions {
                let module = try parse(what: expression)
                print(module.debugDescription)
            }
        } catch let e {
            print(e)
            throw e
        }
    }

    func testHomework1() throws {
      do {
          for expression in expressions {
              print("Before: ", expression)
              let module = try parse(what: expression)
              let _      = propagate_constants(module: module)
              print("After:  ", module)
          }
      } catch let e {
          print(e)
          throw e
      }
    }

    static var allTests = [
        ("Exercises #1", testExercises1),
        ("Homework #1", testHomework1),
    ]
}
