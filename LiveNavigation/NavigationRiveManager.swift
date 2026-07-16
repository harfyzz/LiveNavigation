import RiveRuntime
import Observation

/// One icon per artboard. Each artboard has its own view model (HomeVm,
/// SearchVm, …) and its own `isActive` + `settle` properties.
enum NavIcon: String, CaseIterable {
    case home
    case search
    case scenes
    case live
    case stuff

    var artboardName: String {
        switch self {
        case .home:   return "Home"
        case .search: return "Search"
        case .scenes: return "Scenes"
        case .live:   return "Live Tv"
        case .stuff:  return "My Stuff"
        }
    }
}

@Observable
@MainActor
class NavigationRiveManager {
    var bindingInstance: RiveDataBindingViewModel.Instance? {
        didSet {
            isActiveProperty = bindingInstance?.booleanProperty(fromPath: "isActive")
            settleProperty = bindingInstance?.triggerProperty(fromPath: "settle")
            attachSettleListener()
        }
    }

    private var isActiveProperty: RiveDataBindingViewModel.Instance.BooleanProperty?
    private var settleProperty: RiveDataBindingViewModel.Instance.TriggerProperty?

    /// Flips true when the Rive "settle" trigger fires (~1–2s after
    /// activation). Observers can react to revert visual state.
    var didSettle: Bool = false

    private func attachSettleListener() {
        settleProperty?.addListener { [weak self] in
            Task { @MainActor in
                self?.didSettle = true
            }
        }
    }

    /// Call before activating so didSettle observers can start fresh.
    func resetSettle() {
        didSettle = false
    }

    var isActive: Bool {
        get { isActiveProperty?.value ?? false }
        set { isActiveProperty?.value = newValue }
    }
}
