import XCTest
@testable import semantique
@testable import LogicKit

class semantiqueTests: XCTestCase {

    // func testExercises1() throws {
    //     do {
    //         for expression in expressions {
    //             let module = try parse(what: expression)
    //             print(module.debugDescription)
    //         }
    //     } catch let e {
    //         print(e)
    //         throw e
    //     }
    // }
    //
    // func testHomework1() throws {
    //   do {
    //       for expression in expressions {
    //           print("Before: ", expression)
    //           let module = try parse(what: expression)
    //           let _      = propagate_constants(module: module)
    //           print("After:  ", module)
    //       }
    //   } catch let e {
    //       print(e)
    //       throw e
    //   }
    // }

    func testLogic() throws {
      // Declare all the literals:
      let zero    = Term.lit("zero")
      let succ    = Term.lit("succ")
      let empty   = Term.lit("empty")
      let add     = Term.lit("add")
      let cons    = Term.lit("cons")
      let node    = Term.lit("node")
      let sumlist = Term.lit("sumlist")
      let sumleft = Term.lit("sumleft")
      // Declaring the literals instead of using strings avoids typos in the terms.
      // Declare the variables:
      let x    : Term = .var("x")
      let y    : Term = .var("y")
      let z    : Term = .var("z")
      let l    : Term = .var("l")
      let r    : Term = .var("r")
      let n    : Term = .var("n")

      let kb: KnowledgeBase = [
          add[zero, y, y],
          add[x, succ[y], z] => add[succ[x], y, z],
          sumlist[empty, zero],
          (sumlist[l, y] && add[x, y, z]) => sumlist[cons[x, l], z],
          sumleft[empty, zero],
          (sumleft[l, y] && add[n, y, z]) => sumleft[node[n, l, r], z],
      ]
      for question in [
          add[succ[succ[zero]], succ[succ[zero]], x],
          sumlist[cons[succ[zero], empty], x],
          sumleft[node[succ[zero], empty, empty], x],
      ] {
          let answers = kb.ask(question)
          print("Question:", question)
          for answer in answers {
              print("  * ", answer ["x"] ?? "<unknown>")
          }
      }
    }

}
