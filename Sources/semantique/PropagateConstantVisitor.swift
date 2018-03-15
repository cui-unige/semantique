import AnzenLib
import AnzenAST
import LogicKit

// https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/ASTVisitor.swift
struct PropagateConstantsVisitor : ASTVisitor {
    // This visitor works by traversing the AST.
    // It stores the result of expressions with propagated constants
    // within the `subresult` variable,
    // and the current constant values of variables in the `bindings` dictionnary.

    // The dictionnary of constant bindings:
    var bindings : [String:TypedNode] = [:]
    // The subresult when propagating constants in expressions:
    var subresult : Node?

    mutating func visit(_ node: ModuleDecl) throws {
        // Iterate over statements within the module,
        // and propagate constants in each one using the current bindings:
        for statement in node.statements {
            // Notice that the `bindings` is updated at each visit.
            try self.visit(statement)
        }
    }

    mutating func visit(_ node: PropDecl) throws {
      // Propagate constants in the initial binding:
      if (node.initialBinding != nil) {
          try self.visit(node.initialBinding!.value)
          node.initialBinding = (op: node.initialBinding!.op, value: self.subresult!)
      }
      // Store the initial binding in the `bindings` dictionnary
      // if the result is a literal.
      switch (self.subresult) {
      case (let l as Literal<Bool>):
          bindings[node.name] = l
      case (let l as Literal<Int>):
          bindings[node.name] = l
      case (let l as Literal<String>):
          bindings[node.name] = l
      default: break
      }
      subresult = nil
    }

    mutating func visit(_ node: BinExpr) throws {
        // Propagate constants in the `left` and `right` parts
        // of the binary expression:
        try self.visit(node.left)
        node.left  = self.subresult!
        try self.visit(node.right)
        node.right = self.subresult!
        // If `left` and `right` are literals, compute the result and return it:
        // https://github.com/kyouko-taiga/anzen/blob/master/Sources/AnzenAST/Operator.swift
        switch (node.left, node.op, node.right) {
        case (let l as Literal<Int>, .eq, let r as Literal<Int>):
            self.subresult = Literal<Bool>(value: l.value == r.value, location: node.location)
        case (let l as Literal<Int>, .add, let r as Literal<Int>):
            self.subresult = Literal<Int>(value: l.value + r.value, location: node.location)
        // TODO: add all other operators
        default:
            // If `left` or `right` is not a literal, the binary expression
            // cannot be reduced:
            self.subresult = node
        }
    }

    // Literals are returned directly, as they are already constants
    // that can be propagated or used in expressions.
    // Anzen has only three kinds of literals: booleans, integers and strings.
    mutating func visit(_ node: Literal<Bool>) throws {
        self.subresult = node
    }
    mutating func visit(_ node: Literal<Int>) throws {
        self.subresult = node
    }
    mutating func visit(_ node: Literal<String>) throws {
        self.subresult = node
    }

}
