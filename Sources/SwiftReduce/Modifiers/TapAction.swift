import SwiftUI

extension View {
  public func tapAction(_ action: Action) -> some View {
    return self.tapAction(action.action)
  }
}