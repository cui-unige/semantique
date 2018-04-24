import AnzenAST

extension PropDecl: Hashable {

  public var hashValue: Int {
    return 0
  }

  public static func == (lhs: PropDecl, rhs: PropDecl) -> Bool {
    return lhs === rhs
  }

}
