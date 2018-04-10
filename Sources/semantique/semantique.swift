import AnzenLib
import AnzenAST
import LogicKit

// Parse a program:
// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/Parser.swift
func parse(what: String) throws -> ModuleDecl {
    return try AnzenLib.parse(text: what + "\n")
}

// Evaluate all constant expressions in a module:
func propagate_constants(module: ModuleDecl) -> ModuleDecl {
    var visitor = PropagateConstantsVisitor()
    try! visitor.visit(module)
    return module
}

// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/ASTVisitor.swift
class LogicConstantsVisitor : ASTVisitor {
    var knowledge : KnowledgeBase = []
    // TODO
}

// https://github.com/kyouko-taiga/LogicKit
func type_correctness(module: ModuleDecl) -> KnowledgeBase {
    var visitor = CheckTypesVisitor()
    try! visitor.visit(module)
    return visitor.kb
}

// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/AST.swift
let expressions = [
    """
    let x = 1
    """,
    """
    let x : Int = 1
    """,
    """
    let x = 1 + 2
    """,
    """
    let x = 1 + 2 * 3 - 4
    """,
    """
    let x : Bool = 1 + 2 * 3 - 4
    """,
    """
    let x = 1
    let y : Int = x + 2
    """,
    """
    let x = 1
    let y = -x + 2
    """,
    """
    var x = true
    x = x and false
    """,
    """
    var x = 2
    var y = 2
    if x == y {
      y = x
    } else {
      x = y
    }
    """,
    """
    var x = 2
    fun f(_ a: Int) -> Int {
      return a * x
    }
    let y : Bool = f(x) * x
    """,
]
