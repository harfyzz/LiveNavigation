import RiveRuntime
import Observation

enum NavIcon: String, CaseIterable {
    case scenes = "Scenes"
    case search = "Search"
    case live = "Live"
    case stuff = "Stuff"
    case home = "Home"
}

@Observable
@MainActor
class NavigationRiveManager {
    var bindingInstance: RiveDataBindingViewModel.Instance? {
        didSet {
            isActiveProperty = bindingInstance?.booleanProperty(fromPath: "isActive")
            iconsProperty = bindingInstance?.enumProperty(fromPath: "icons")
        }
    }

    private var isActiveProperty: RiveDataBindingViewModel.Instance.BooleanProperty?
    private var iconsProperty: RiveDataBindingViewModel.Instance.EnumProperty?

    var isActive: Bool {
        get { isActiveProperty?.value ?? false }
        set { isActiveProperty?.value = newValue }
    }

    var icon: NavIcon? {
        get {
            guard let rawValue = iconsProperty?.value else { return nil }
            return NavIcon(rawValue: rawValue)
        }
        set { if let newValue { iconsProperty?.value = newValue.rawValue } }
    }
}
