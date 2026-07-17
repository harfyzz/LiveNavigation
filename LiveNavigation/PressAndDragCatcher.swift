import SwiftUI
import UIKit

/// A transparent overlay that hosts a `UILongPressGestureRecognizer`,
/// giving us UIKit-level control over how the gesture cooperates with
/// enclosing scroll views. Unlike SwiftUI's `LongPressGesture`, this
/// yields cleanly to the scroll view during ambiguous slow drags:
/// UIKit's arbitration only lets our recognizer win if the user really
/// held still for `minimumPressDuration`.
struct PressAndDragCatcher: UIViewRepresentable {
    var minimumPressDuration: TimeInterval = 0.35
    var allowableMovement: CGFloat = 10

    var onEngage: () -> Void
    var onDrag: (CGFloat) -> Void
    var onEnd: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true

        let longPress = UILongPressGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handle(_:))
        )
        longPress.minimumPressDuration = minimumPressDuration
        longPress.allowableMovement = allowableMovement
        longPress.delegate = context.coordinator
        // Don't swallow touches from the scroll view during the waiting
        // phase — it still gets to observe the touch and pan if the user
        // starts scrolling.
        longPress.cancelsTouchesInView = false
        longPress.delaysTouchesBegan = false
        longPress.delaysTouchesEnded = false
        view.addGestureRecognizer(longPress)

        context.coordinator.recognizer = longPress
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.onEngage = onEngage
        context.coordinator.onDrag = onDrag
        context.coordinator.onEnd = onEnd
        context.coordinator.recognizer?.minimumPressDuration = minimumPressDuration
        context.coordinator.recognizer?.allowableMovement = allowableMovement
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onEngage: onEngage, onDrag: onDrag, onEnd: onEnd)
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onEngage: () -> Void
        var onDrag: (CGFloat) -> Void
        var onEnd: () -> Void
        weak var recognizer: UILongPressGestureRecognizer?
        private var startX: CGFloat = 0

        init(onEngage: @escaping () -> Void,
             onDrag: @escaping (CGFloat) -> Void,
             onEnd: @escaping () -> Void) {
            self.onEngage = onEngage
            self.onDrag = onDrag
            self.onEnd = onEnd
        }

        @objc func handle(_ recognizer: UILongPressGestureRecognizer) {
            guard let view = recognizer.view else { return }
            let location = recognizer.location(in: view)

            switch recognizer.state {
            case .began:
                startX = location.x
                onEngage()
            case .changed:
                onDrag(location.x - startX)
            case .ended, .cancelled, .failed:
                onEnd()
            default:
                break
            }
        }

        // Default (return false) means gestures are mutually exclusive —
        // whichever meets its conditions first wins. This is exactly what
        // we want vs. a UIScrollView: scroll pan wins on movement, ours
        // wins on stationary hold.
    }
}
