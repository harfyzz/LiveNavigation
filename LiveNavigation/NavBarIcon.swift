import SwiftUI
import RiveRuntime

struct NavBarIcon: View {
    let icon: NavIcon
    let title: String
    let isSelected: Bool

    @State private var riveViewModel = RiveViewModel(fileName: "livenav", stateMachineName: "Main")
    @State private var manager = NavigationRiveManager()

    var body: some View {
        VStack(spacing: 0) {
            riveViewModel.view()
                .frame(width: 44, height: 44)
                .scaleEffect(isSelected ? 1.55 : 1.0, anchor: .bottom)
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
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
                manager.icon = icon
                manager.isActive = isSelected
            }
        }
        .onChange(of: isSelected) { _, newValue in
            manager.isActive = newValue
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
