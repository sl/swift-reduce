// Please forgive this horrible hack. Credit for this idea goes to:
// https://forums.swift.org/t/getting-keypaths-to-members-automatically-using-mirror/21207

public protocol KeyPathListable {
  var allKeyPaths: [PartialKeyPath<Self>] { get }
}

extension KeyPathListable {
  private subscript(checkedMirrorDescendant key: String) -> Any {
    return Mirror(reflecting: self).descendant(key)!
  }

  public var allKeyPaths: [PartialKeyPath<Self>] {
    var keyPaths = [PartialKeyPath<Self>]()
    let mirror = Mirror(reflecting: self)
    for case (let key?, _) in mirror.children {
      keyPaths.append(\Self.[checkedMirrorDescendant: key] as PartialKeyPath<Self>)
    }
    return keyPaths
  }
}
