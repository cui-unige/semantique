import AnzenLib
import AnzenAST
import Foundation

func parse(what: String) throws -> ModuleDecl {
    return try AnzenLib.parse(text: what + "\n")
}

let example1 = """
let x = 2
"""
