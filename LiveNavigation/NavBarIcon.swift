import SwiftUI
import RiveRuntime

struct NavBarIcon: View {
    let icon: NavIcon
    let title: String
    let isSelected: Bool

    @State private var riveViewModel: RiveViewModel
    @State private var manager = NavigationRiveManager()

    init(icon: NavIcon, title: String, isSelected: Bool) {
        self.icon = icon
        self.title = title
        self.isSelected = isSelected
        _riveViewModel = State(initialValue: RiveViewModel(
            fileName: "livenav",
            stateMachineName: "State Machine 1",
            artboardName: icon.artboardName
        ))
    }

    private var scale: CGFloat {
        // Selected and still animating in → grown.
        // Selected but Rive has fired `settle` → back to normal size.
        // Not selected → normal size.
        (isSelected && !manager.didSettle) ? 1.55 : 1.0
    }

    /// Match Rive's ease-in-out on the settle-back so the icon transitions
    /// out of the grown state in sync with the artboard's own animation.
    private var scaleAnimation: Animation {
        if isSelected && manager.didSettle {
            return .timingCurve(0.42, 0, 0.58, 1, duration: 0.1)
        }
        return .spring(response: 0.35, dampingFraction: 0.7)
    }

    var body: some View {
        VStack(spacing: 0) {
            riveViewModel.view()
                .frame(width: 44, height: 44)
                .scaleEffect(scale, anchor: .bottom)
                .animation(scaleAnimation, value: scale)
            Text(title)
                .font(.caption2)
                .fontWeight(isSelected ? .semibold : .medium)
                .foregroundStyle(isSelected ? .primary : .secondary)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onAppear {
            riveViewModel.riveModel?.enableAutoBind { instance in
                manager.bindingInstance = instance
                manager.isActive = isSelected
            }
        }
        .onChange(of: isSelected) { _, newValue in
            if newValue {
                manager.resetSettle()
            }
            manager.isActive = newValue
            // Wake the state machine so the write is applied. Rive stops
            // advancing once it goes idle; without this the deselection
            // property change sits pending until the next reselect.
            riveViewModel.play()
        }
    }
}

#Preview("Selected") {
    NavBarIcon(icon: .home, title: "Home", isSelected: true)
        .preferredColorScheme(.dark)
}

#Preview("Unselected") {
    NavBarIcon(icon: .search, title: "Search", isSelected: false)
        .preferredColorScheme(.dark)
}
