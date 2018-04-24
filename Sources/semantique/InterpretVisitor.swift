import AnzenLib
import AnzenAST
import LogicKit

// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/ASTVisitor.swift
struct InterpretVisitor: ASTVisitor {

  // TODO: interpret an Anzen program.
  // Suppose that the typing of the program is correct,
  // as well as the let/var or @cst/@mut information.

  // Remember that the environment of the interpretation is a stack
  // of bindings, where each element of the stack binds local variables
  // to their values, for each scope (block, function, ...).

  // Remember also that Anzen is a programming language based on references.
  // All variables are in fact a pointer to a value.

  // TODO: fill this mapping from PropDecls Literal<T>,
  // that contain the final value associated to each PropDecl
  // after interpretation.
  var variables: [PropDecl: TypedNode] = [:]

}
