import AnzenLib
import AnzenAST
import LogicKit
import Foundation

// Parse a program:
// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/Parser.swift
func parse(what: String) throws -> ModuleDecl {
    return try AnzenLib.parse(text: what + "\n")
}

// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/ASTVisitor.swift
class PropagateConstantsVisitor : ASTVisitor {
  // TODO
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
func logic_constants(module: ModuleDecl) -> KnowledgeBase {
  var visitor = LogicConstantsVisitor()
  try! visitor.visit(module)
  return visitor.knowledge
}

// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/AST.swift
let expressions = [
  """
  let x = 1
  """,
  """
  let x = 1 + 2 * 3 - 4
  """,
  """
  let x = 1
  let y = x + 2
  """,
  """
  var x = true
  x = x and false
  """,
]
