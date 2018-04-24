import AnzenLib
import AnzenAST
import LogicKit

// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/ASTVisitor.swift
struct CheckTypesVisitor: ASTVisitor {

  // TODO: check that the types of an Anzen program are correct.
  // Arithmetic operations should be between integers,
  // Boolean expressions should be between Boolean values,
  // and function should be called with the correct parameter types,
  // and the correct return type.

  let isInteger = Term.lit("is-integer")
  let isBoolean = Term.lit("is-boolean")
  let isString  = Term.lit("is-string")
  let typeOf    = Term.lit("type-of")

  // Example: typeOf[x, isInteger]

  // TODO: fill this knowledge base using the AST:
  var kb: KnowledgeBase = []

  // TODO: fill this mapping from PropDecls to the logic variable
  // that represents the declared variable.
  var variables: [PropDecl: Term] = [:]

}
