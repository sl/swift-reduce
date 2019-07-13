import SwiftUI

extension Button where Label == Text {
  public init<S>(_ s: S, action: Action) where S : StringProtocol {
    self.init(s, action: action.action)
  }
}