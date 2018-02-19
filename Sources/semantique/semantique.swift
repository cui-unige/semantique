import AnzenLib
import AnzenAST
import Foundation

func parse(what: String) throws -> ModuleDecl {
    let source = try String(contentsOf: URL(fileURLWithPath: what))
    let module = try AnzenLib.parse(text: source)
    return module
}
