import SwiftUI

extension Color {
    static let brand = Color(red: 229/255, green: 9/255, blue: 20/255)
}

struct HomeView: View {
    @State private var selectedCategory = "All"
    private let categories = ["All", "Movies", "Shows", "Anime", "Docs"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                categoryChips

                HeroCard(feature: MockData.hero)

                RowSection(title: "Continue Watching") {
                    ForEach(MockData.continueWatching) { item in
                        ContinueCard(item: item)
                    }
                }

                RowSection(title: "Trending Now") {
                    ForEach(MockData.trending) { item in
                        PosterCard(item: item)
                    }
                }

                TopTenSection(items: MockData.topTen)

                RowSection(title: "Because you liked House of the Dragon") {
                    ForEach(MockData.recommended) { item in
                        PosterCard(item: item)
                    }
                }

                EditorialCard(item: MockData.editorial)

                RowSection(title: "New this week") {
                    ForEach(MockData.newReleases) { item in
                        PosterCard(item: item)
                    }
                }

                Color.clear.frame(height: 100)
            }
            .padding(.top, 8)
        }
        .background(Color.black)
        .scrollIndicators(.hidden)
    }

    private var header: some View {
        HStack {
          /*  Text("livenav")
                .font(.system(size: 26, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.brand, Color(red: 1, green: 0.4, blue: 0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                ) */
            Spacer()
            HStack(spacing: 18) {
                Image(systemName: "airplayvideo")
                Image(systemName: "arrow.down.to.line")
                Image(systemName: "magnifyingglass")
            }
            .font(.headline)
            .foregroundStyle(.white.opacity(0.9))
        }
        .padding(.horizontal, 16)
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(categories, id: \.self) { cat in
                    let isSelected = cat == selectedCategory
                    Text(cat)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(isSelected ? .black : .white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(isSelected ? Color.white.opacity(0.9) : Color("greyBg"))
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedCategory = cat
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct RowSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    content()
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

private struct HeroCard: View {
    let feature: FeatureItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            TMDBImage(path: feature.posterPath, width: 780)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .black.opacity(0.15), location: 0.35),
                    .init(color: .black.opacity(0.55), location: 0.65),
                    .init(color: .black.opacity(0.95), location: 1.0),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 8) {
                /*
                Text(feature.badge.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color.brand)) */
                Spacer()

                HStack(spacing: 8) {
                    Label("Play", systemImage: "play.fill")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(.white))

                    Label("Info", systemImage: "info.circle")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
        }
        .aspectRatio(16/22, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 16)
    }
}

private struct PosterCard: View {
    let item: MediaItem
    private let width: CGFloat = 130

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            TMDBImage(path: item.posterPath, width: 342)
                .frame(width: width, height: width * 1.5)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(item.title)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .lineLimit(1)

            Text(item.subtitle)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.5))
                .lineLimit(1)
        }
        .frame(width: width, alignment: .leading)
    }
}

private struct ContinueCard: View {
    let item: ContinueItem
    private let cardWidth: CGFloat = 140

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                TMDBImage(path: item.posterPath, width: 342)
                    .frame(width: cardWidth, height: cardWidth * 1.5)

                Circle()
                    .fill(.black.opacity(0.55))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "play.fill")
                            .foregroundStyle(.white)
                    )

                VStack {
                    Spacer()
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 44)
                    .overlay(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.white.opacity(0.25))
                            .frame(height: 3)
                            .overlay(alignment: .leading) {
                                GeometryReader { geo in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.brand)
                                        .frame(width: geo.size.width * item.progress, height: 3)
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.bottom, 8)
                    }
                }
            }
            .frame(width: cardWidth, height: cardWidth * 1.5)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(item.title)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .lineLimit(1)

            Text(item.subtitle)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.5))
                .lineLimit(1)
        }
        .frame(width: cardWidth, alignment: .leading)
    }
}

private struct TopTenSection: View {
    let items: [MediaItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Top 10 Today")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Text("🔥")
                Spacer()
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        HStack(spacing: -20) {
                            Text("\(index + 1)")
                                .font(.system(size: 96, weight: .black))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white.opacity(0.9), .white.opacity(0.2)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 60)

                            TMDBImage(path: item.posterPath, width: 342)
                                .frame(width: 100, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

private struct EditorialCard: View {
    let item: EditorialItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.eyebrow.uppercased())
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(Color.brand)
                .padding(.bottom, 8)

            Text(item.headline)
                .font(.system(size: 24, weight: .heavy))
                .foregroundStyle(.white)
                .padding(.bottom, 12)

            Text(item.byline)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color(red: 0.15, green: 0.05, blue: 0.35), Color(red: 0.55, green: 0.1, blue: 0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 16)
    }
}

struct TMDBImage: View {
    let path: String
    let width: Int

    private var url: URL? {
        URL(string: "https://image.tmdb.org/t/p/w\(width)\(path)")
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            default:
                LinearGradient(
                    colors: [Color(white: 0.12), Color(white: 0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}

struct MediaItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let posterPath: String
}

struct ContinueItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let progress: Double
    let posterPath: String
}

struct FeatureItem {
    let title: String
    let tagline: String
    let badge: String
    let posterPath: String
}

struct EditorialItem {
    let eyebrow: String
    let headline: String
    let byline: String
}

private enum MockData {
    static let hero = FeatureItem(
        title: "House of the Dragon",
        tagline: "Fire, blood, and the Targaryen civil war.",
        badge: "Now Streaming",
        posterPath: "/7V0Ebks0GgpKvQ7QbLAIdX5dos4.jpg"
    )

    static let continueWatching: [ContinueItem] = [
        ContinueItem(title: "Silo", subtitle: "S2 E4 · 22 min left", progress: 0.35,
                     posterPath: "/gMYZZvnkVNTqSVnVCphWbPXwWwb.jpg"),
        ContinueItem(title: "The Odyssey", subtitle: "1h 24m left", progress: 0.42,
                     posterPath: "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg"),
        ContinueItem(title: "FROM", subtitle: "S1 E7 · 8 min left", progress: 0.78,
                     posterPath: "/pRtJagIxpfODzzb0T0NAvZSzErC.jpg"),
        ContinueItem(title: "Project Hail Mary", subtitle: "48 min left", progress: 0.65,
                     posterPath: "/yihdXomYb5kTeSivtFndMy5iDmf.jpg"),
    ]

    static let trending: [MediaItem] = [
        MediaItem(title: "Obsession", subtitle: "Drama · 2026", posterPath: "/bRwnj8WEKBCvmfeUNOukJPwB43K.jpg"),
        MediaItem(title: "Toy Story 5", subtitle: "Animation · 2026", posterPath: "/sfQtVlIHljToOwYjhe21KPGzZWK.jpg"),
        MediaItem(title: "Disclosure Day", subtitle: "Thriller · 2026", posterPath: "/259wnijEJoJLPuZuscxDTqwnypw.jpg"),
        MediaItem(title: "Moana", subtitle: "Family · 2026", posterPath: "/zKVgiv5qHCvCLT4A2ymJi5QeXDH.jpg"),
        MediaItem(title: "Backrooms", subtitle: "Horror · 2026", posterPath: "/rhGx6E3qRNMgj3i5su2oukNHwIQ.jpg"),
        MediaItem(title: "The Furious", subtitle: "Action · 2026", posterPath: "/zP19YO60jwEsfKd5Qf1UvA5uJu8.jpg"),
    ]

    static let topTen: [MediaItem] = [
        MediaItem(title: "House of the Dragon", subtitle: "", posterPath: "/7V0Ebks0GgpKvQ7QbLAIdX5dos4.jpg"),
        MediaItem(title: "Obsession", subtitle: "", posterPath: "/bRwnj8WEKBCvmfeUNOukJPwB43K.jpg"),
        MediaItem(title: "Silo", subtitle: "", posterPath: "/gMYZZvnkVNTqSVnVCphWbPXwWwb.jpg"),
        MediaItem(title: "The Odyssey", subtitle: "", posterPath: "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg"),
        MediaItem(title: "Toy Story 5", subtitle: "", posterPath: "/sfQtVlIHljToOwYjhe21KPGzZWK.jpg"),
    ]

    static let recommended: [MediaItem] = [
        MediaItem(title: "Game of Thrones", subtitle: "Drama · 2011", posterPath: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg"),
        MediaItem(title: "FROM", subtitle: "Mystery · 2022", posterPath: "/pRtJagIxpfODzzb0T0NAvZSzErC.jpg"),
        MediaItem(title: "Supernatural", subtitle: "Fantasy · 2005", posterPath: "/8iixmfGx5EIFPdpNvB2JvI3VIqX.jpg"),
        MediaItem(title: "The Rookie", subtitle: "Crime · 2018", posterPath: "/70kTz0OmjjZe7zHvIDrq2iKW7PJ.jpg"),
        MediaItem(title: "Rick and Morty", subtitle: "Animation · 2013", posterPath: "/owhkU6KRqdXoUQpjV8uyZGPtX58.jpg"),
    ]

    static let editorial = EditorialItem(
        eyebrow: "Curator's pick",
        headline: "Five slow-burn thrillers that pay off in the final act.",
        byline: "By the Livenav editors · 5 min read"
    )

    static let newReleases: [MediaItem] = [
        MediaItem(title: "Scary Movie", subtitle: "Comedy · New", posterPath: "/1KlYdWoOrbL5ux357rW9LC155qw.jpg"),
        MediaItem(title: "The Devil Wears Prada 2", subtitle: "Comedy · New", posterPath: "/fCAURTUx3YfsJ8k9I0UamjSILiR.jpg"),
        MediaItem(title: "Passenger", subtitle: "Sci-Fi · New", posterPath: "/2sOEJzhPzjTkZSlPbGxOJ7xgIyS.jpg"),
        MediaItem(title: "Deep Water", subtitle: "Thriller · New", posterPath: "/kjcuS7xaRyqRjVaVcH4t0qHshuX.jpg"),
        MediaItem(title: "Mortal Kombat II", subtitle: "Action · New", posterPath: "/hwRdDFIhaEmpRgoki805YvyyjZf.jpg"),
        MediaItem(title: "Avatar Aang", subtitle: "Fantasy · New", posterPath: "/3sgnSfNT27Bx5O5ukr7B26mhEQq.jpg"),
    ]
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
