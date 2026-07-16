//
//  ContentView.swift
//  LiveNavigation
//
//  Created by Afeez Yunus on 15/07/2026.
//

import SwiftUI

struct NavItem: Identifiable {
    let id = UUID()
    let icon: NavIcon
    var title: String
}

struct ContentView: View {
    /// Toggle between the full app (with Home/Search/etc. screens) and a
    /// bare shell that only shows the nav bar over black.
    var showScreens: Bool = true

    @State private var items: [NavItem] = [
        NavItem(icon: .home, title: "Home"),
        NavItem(icon: .search, title: "Search"),
        NavItem(icon: .scenes, title: "Scenes"),
        NavItem(icon: .live, title: "Live Tv"),
        NavItem(icon: .stuff, title: "My Stuff"),
    ]
    @State private var selectedIndex = 0

    init(showScreens: Bool = true) {
        self.showScreens = showScreens
        // Give AsyncImage a real cache so posters aren't re-downloaded.
        URLCache.shared = URLCache(memoryCapacity: 50_000_000, diskCapacity: 500_000_000)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if showScreens {
                ZStack {
                    screen(for: .home) { HomeView() }
                    screen(for: .search) { SearchView() }
                    screen(for: .scenes) { ScenesView() }
                    screen(for: .live) { LiveTVView() }
                    screen(for: .stuff) { MyStuffView() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Color.black.ignoresSafeArea()
            }

            HStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    NavBarIcon(
                        icon: item.icon,
                        title: item.title,
                        isSelected: selectedIndex == index
                    )
                    .onTapGesture {
                        selectedIndex = index
                    }
                }
            }
          //  .padding(.top, 8)
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay(Color.black.opacity(0.4))
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .preferredColorScheme(.dark)
        .sensoryFeedback(.selection, trigger: selectedIndex)
    }

    @ViewBuilder
    private func screen<V: View>(for icon: NavIcon, @ViewBuilder content: () -> V) -> some View {
        let isActive = items[selectedIndex].icon == icon
        content()
            .opacity(isActive ? 1 : 0)
            .allowsHitTesting(isActive)
            .animation(.easeInOut(duration: 0.25), value: selectedIndex)
    }
}

#Preview("Empty (nav only)") {
    ContentView(showScreens: false)
}

#Preview("Full (with screens)") {
    ContentView(showScreens: true)
}
