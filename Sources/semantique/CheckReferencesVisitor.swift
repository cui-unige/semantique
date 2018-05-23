import AnzenLib
import AnzenAST

// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/ASTVisitor.swift
struct CheckReferencesVisitor: ASTVisitor {

  // TODO: check that the accesses to references in an Anzen program are correct,
  // using a visitor like `InterpretVisitor`, **not** a logic program.

  // TODO: fill this mapping from PropDecls to `true` if the variable is used
  // correctly in the program, or `false` if it is used incorrectly.
  var variables: [PropDecl: Boolean] = [:]

}
