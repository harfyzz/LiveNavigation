import SwiftUI

struct SearchView: View {
    @State private var query = ""
    @FocusState private var searchFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                searchField

                if query.isEmpty {
                    recentSearches
                    topSearches
                    categoriesGrid
                } else {
                    searchResults
                }

                Color.clear.frame(height: 100)
            }
            .padding(.top, 8)
        }
        .background(Color.black)
        .scrollIndicators(.hidden)
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.6))
            TextField("", text: $query, prompt: Text("Movies, shows, actors").foregroundStyle(.white.opacity(0.4)))
                .foregroundStyle(.white)
                .tint(.brand)
                .focused($searchFocused)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            if !query.isEmpty {
                Button { query = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Capsule().fill(Color("greyBg")))
        .padding(.horizontal, 16)
    }

    private var recentSearches: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("Clear")
                    .font(.caption)
                    .foregroundStyle(Color.brand)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SearchMockData.recent, id: \.self) { term in
                        HStack(spacing: 6) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.caption)
                            Text(term)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(.white.opacity(0.85))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color("greyBg")))
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var topSearches: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top searches")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                ForEach(Array(SearchMockData.topSearches.enumerated()), id: \.element.id) { index, item in
                    SearchResultRow(item: item)
                    if index < SearchMockData.topSearches.count - 1 {
                        Divider()
                            .overlay(Color.white.opacity(0.08))
                            .padding(.leading, 80)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var categoriesGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Browse by category")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)],
                spacing: 8
            ) {
                ForEach(SearchMockData.categories) { category in
                    CategoryTile(category: category)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var searchResults: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Results for \"\(query)\"")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                ForEach(SearchMockData.topSearches.prefix(6)) { item in
                    SearchResultRow(item: item)
                    Divider()
                        .overlay(Color.white.opacity(0.08))
                        .padding(.leading, 80)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct SearchResultRow: View {
    let item: SearchItem

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(item.posterPath)")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color("greyBg")
                }
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                    .lineLimit(1)
                HStack(spacing: 4) {
                    Image(systemName: "eye")
                        .font(.caption2)
                    Text(item.viewers)
                        .font(.caption2)
                }
                .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(.vertical, 10)
    }
}

private struct CategoryTile: View {
    let category: SearchCategory

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: category.colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            RadialGradient(
                colors: [.white.opacity(0.18), .clear],
                center: .topLeading,
                startRadius: 0,
                endRadius: 120
            )
            HStack {
                Text(category.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: category.icon)
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(14)
        }
        .frame(height: 72)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct SearchItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let viewers: String
    let posterPath: String
}

struct SearchCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let colors: [Color]
}

private enum SearchMockData {
    static let recent = ["House of the Dragon", "Silo", "The Odyssey", "Christopher Nolan", "Sci-Fi 2026"]

    static let topSearches: [SearchItem] = [
        SearchItem(title: "House of the Dragon", subtitle: "Drama · 2022", viewers: "12.4M this week",
                   posterPath: "/7V0Ebks0GgpKvQ7QbLAIdX5dos4.jpg"),
        SearchItem(title: "Obsession", subtitle: "Thriller · 2026", viewers: "9.1M this week",
                   posterPath: "/bRwnj8WEKBCvmfeUNOukJPwB43K.jpg"),
        SearchItem(title: "Silo", subtitle: "Sci-Fi · 2023", viewers: "7.8M this week",
                   posterPath: "/gMYZZvnkVNTqSVnVCphWbPXwWwb.jpg"),
        SearchItem(title: "The Odyssey", subtitle: "Adventure · 2026", viewers: "6.2M this week",
                   posterPath: "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg"),
        SearchItem(title: "Toy Story 5", subtitle: "Animation · 2026", viewers: "5.5M this week",
                   posterPath: "/sfQtVlIHljToOwYjhe21KPGzZWK.jpg"),
        SearchItem(title: "The Devil Wears Prada 2", subtitle: "Comedy · 2026", viewers: "4.9M this week",
                   posterPath: "/fCAURTUx3YfsJ8k9I0UamjSILiR.jpg"),
        SearchItem(title: "Backrooms", subtitle: "Horror · 2026", viewers: "3.7M this week",
                   posterPath: "/rhGx6E3qRNMgj3i5su2oukNHwIQ.jpg"),
        SearchItem(title: "Game of Thrones", subtitle: "Drama · 2011", viewers: "3.1M this week",
                   posterPath: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg"),
    ]

    static let categories: [SearchCategory] = [
        SearchCategory(name: "Action", icon: "flame.fill",
                       colors: [Color(red: 0.85, green: 0.2, blue: 0.15), Color(red: 0.4, green: 0.05, blue: 0.1)]),
        SearchCategory(name: "Drama", icon: "theatermasks.fill",
                       colors: [Color(red: 0.3, green: 0.15, blue: 0.5), Color(red: 0.1, green: 0.05, blue: 0.25)]),
        SearchCategory(name: "Comedy", icon: "face.smiling.inverse",
                       colors: [Color(red: 0.95, green: 0.65, blue: 0.2), Color(red: 0.6, green: 0.25, blue: 0.15)]),
        SearchCategory(name: "Sci-Fi", icon: "sparkles",
                       colors: [Color(red: 0.15, green: 0.5, blue: 0.85), Color(red: 0.05, green: 0.15, blue: 0.4)]),
        SearchCategory(name: "Horror", icon: "moon.fill",
                       colors: [Color(red: 0.15, green: 0.05, blue: 0.1), Color(red: 0.3, green: 0.05, blue: 0.15)]),
        SearchCategory(name: "Romance", icon: "heart.fill",
                       colors: [Color(red: 0.9, green: 0.3, blue: 0.55), Color(red: 0.5, green: 0.1, blue: 0.35)]),
        SearchCategory(name: "Documentary", icon: "camera.fill",
                       colors: [Color(red: 0.4, green: 0.45, blue: 0.5), Color(red: 0.15, green: 0.2, blue: 0.25)]),
        SearchCategory(name: "Animation", icon: "wand.and.stars",
                       colors: [Color(red: 0.4, green: 0.75, blue: 0.6), Color(red: 0.1, green: 0.35, blue: 0.3)]),
        SearchCategory(name: "Thriller", icon: "bolt.fill",
                       colors: [Color(red: 0.75, green: 0.65, blue: 0.15), Color(red: 0.3, green: 0.2, blue: 0.05)]),
        SearchCategory(name: "Family", icon: "person.3.fill",
                       colors: [Color(red: 0.3, green: 0.7, blue: 0.85), Color(red: 0.1, green: 0.3, blue: 0.5)]),
    ]
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark)
}
