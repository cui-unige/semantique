import XCTest
@testable import semantique
@testable import LogicKit

class semantiqueTests: XCTestCase {

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

    func testHomework2() throws {
      do {
          for expression in expressions {
              print(expression)
              let module = try parse(what: expression)
              let kb     = type_correctness(module: module)
          }
      } catch let e {
          print(e)
          throw e
      }
    }

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

    func testConcat() throws {
      // Declare all the literals:
      let empty  : Term = .lit("empty")
      let cons   : Term = .lit("cons")
      let concat : Term = .lit("concat")
      // Declare the variables:
      let x  : Term = .var("x")
      let l  : Term = .var("l")
      let l1 : Term = .var("l1")
      let l2 : Term = .var("l2")
      let l3 : Term = .var("l3")

      let kb: KnowledgeBase = [
        concat[empty, l, l],
        concat[l1, l2, l3] =>
          concat[cons[x,l1], l2, cons[x, l3]],
      ]
      for question in [
        concat[empty, empty, x],
      ] {
          let answers = kb.ask(question)
          print("Question:", question)
          for answer in answers {
              print("  * ", answer [x] ?? "<unknown>")
          }
      }
    }

    func testTyping() throws {
      // Declare all the literals:
      let isInteger = Term.lit("is-integer")
      // let isBoolean = Term.lit("is-boolean")
      let isString  = Term.lit("is-string")
      let typeOf    = Term.lit("type-of")
      let add       = Term.lit("add")
      let zero      = Term.lit(0)
      let one       = Term.lit(1)
      let a         = Term.lit("s:a")
      let x         = Term.lit("v:x")
      let y         = Term.lit("v:y")
      let z         = Term.lit("v:z")
      let c         = Term.lit("v:c")
      // Declare the variables:
      let t : Term = .var("t")
      let u : Term = .var("u")
      let v : Term = .var("v")
      let w : Term = .var("w")
      // let x : Term = .var("x")
      // let y : Term = .var("y")

      let kb: KnowledgeBase = [
        typeOf[zero, isInteger],
        typeOf[zero, t] => typeOf[x, t],

        typeOf[one, isInteger],
        typeOf[y, isInteger],
        typeOf[one, t] => typeOf[y, t],

        typeOf[add[x, y, z], t] => typeOf[z, t],

        // (typeOf[u, t] && typeOf[v, t]) => typeOf[add[u, v, w], t],
        typeOf[u, t] => typeOf[add[u, v, w], t],
        typeOf[v, t] => typeOf[add[u, v, w], t],

        typeOf[a, isString],
        typeOf[add[a, z, c], t] => typeOf[c, t],
      ]
      for question in [
          typeOf[c, t],
      ] {
          let answers = kb.ask(question)
          print("Question:", question)
          for answer in answers {
              print("  * ", answer [t] ?? "<unknown>")
          }
      }
    }

    static var allTests = [
        ("testHomework2", testHomework2),
     ]

}
