import SwiftUI

struct MyStuffView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                profileHeader

                statsStrip

                downloadsSection

                myListSection

                historySection

                menuList

                Color.clear.frame(height: 100)
            }
            .padding(.top, 8)
        }
        .background(Color.black)
        .scrollIndicators(.hidden)
    }

    private var profileHeader: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(
                    LinearGradient(colors: [.orange, .pink, Color.brand],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .frame(width: 56, height: 56)
                .overlay(
                    Text("H")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Hafeez")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Text("Member since 2024")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            Text("Edit")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color("greyBg")))
        }
        .padding(.horizontal, 16)
    }

    private var statsStrip: some View {
        HStack(spacing: 8) {
            StatTile(value: "48h", label: "This month", icon: "clock")
            StatTile(value: "23", label: "My List", icon: "bookmark.fill")
            StatTile(value: "4", label: "Downloads", icon: "arrow.down.circle.fill")
        }
        .padding(.horizontal, 16)
    }

    private var downloadsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Downloads")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("Manage")
                    .font(.caption)
                    .foregroundStyle(Color.brand)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(MyStuffMockData.downloads) { item in
                        DownloadCard(item: item)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var myListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("My List")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.caption)
                    Text("Sort")
                        .font(.caption)
                }
                .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal, 16)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                ],
                spacing: 10
            ) {
                ForEach(MyStuffMockData.myList) { item in
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(item.posterPath)")) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFill()
                        default:
                            Color("greyBg")
                        }
                    }
                    .aspectRatio(2/3, contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recently watched")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("Clear")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal, 16)

            VStack(spacing: 0) {
                ForEach(Array(MyStuffMockData.history.enumerated()), id: \.element.id) { index, item in
                    HistoryRow(item: item)
                    if index < MyStuffMockData.history.count - 1 {
                        Divider()
                            .overlay(Color.white.opacity(0.08))
                            .padding(.leading, 76)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var menuList: some View {
        VStack(spacing: 0) {
            MenuRow(icon: "person.crop.circle", title: "Account", trailing: "hafeez@livenav.com")
            Divider().overlay(Color.white.opacity(0.08)).padding(.leading, 52)
            MenuRow(icon: "bell", title: "Notifications", trailing: nil)
            Divider().overlay(Color.white.opacity(0.08)).padding(.leading, 52)
            MenuRow(icon: "arrow.down.to.line", title: "Download settings", trailing: nil)
            Divider().overlay(Color.white.opacity(0.08)).padding(.leading, 52)
            MenuRow(icon: "play.rectangle", title: "Playback quality", trailing: "Auto")
            Divider().overlay(Color.white.opacity(0.08)).padding(.leading, 52)
            MenuRow(icon: "questionmark.circle", title: "Help center", trailing: nil)
            Divider().overlay(Color.white.opacity(0.08)).padding(.leading, 52)
            MenuRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign out", trailing: nil, tint: Color.brand)
        }
        .background(Color("greyBg"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 16)
    }
}

private struct StatTile: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Color.brand)
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.55))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color("greyBg"))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct DownloadCard: View {
    let item: DownloadedItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(item.posterPath)")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        Color("greyBg")
                    }
                }
                .frame(width: 140, height: 210)
                .clipped()

                LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .center, endPoint: .bottom)
                    .frame(height: 80)
                    .frame(maxHeight: .infinity, alignment: .bottom)

                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption2)
                        .foregroundStyle(.green)
                    Text(item.size)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .padding(8)
            }
            .frame(width: 140, height: 210)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(item.expires)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .frame(width: 140, alignment: .leading)
    }
}

private struct HistoryRow: View {
    let item: HistoryItem

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
            .frame(width: 60, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(item.watchedAt)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            Image(systemName: "ellipsis")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding(.vertical, 10)
    }
}

private struct MenuRow: View {
    let icon: String
    let title: String
    let trailing: String?
    var tint: Color = .white

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(tint)
                .frame(width: 24)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(tint)

            Spacer()

            if let trailing {
                Text(trailing)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }

            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
    }
}

struct DownloadedItem: Identifiable {
    let id = UUID()
    let title: String
    let size: String
    let expires: String
    let posterPath: String
}

struct MyListItem: Identifiable {
    let id = UUID()
    let posterPath: String
}

struct HistoryItem: Identifiable {
    let id = UUID()
    let title: String
    let watchedAt: String
    let posterPath: String
}

private enum MyStuffMockData {
    static let downloads: [DownloadedItem] = [
        DownloadedItem(title: "Silo · S2 E4", size: "412 MB", expires: "Expires in 3 days",
                       posterPath: "/gMYZZvnkVNTqSVnVCphWbPXwWwb.jpg"),
        DownloadedItem(title: "The Odyssey", size: "1.8 GB", expires: "Expires in 6 days",
                       posterPath: "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg"),
        DownloadedItem(title: "Project Hail Mary", size: "1.4 GB", expires: "Expires in 12 days",
                       posterPath: "/yihdXomYb5kTeSivtFndMy5iDmf.jpg"),
        DownloadedItem(title: "FROM · S1 E7", size: "388 MB", expires: "Expires in 2 days",
                       posterPath: "/pRtJagIxpfODzzb0T0NAvZSzErC.jpg"),
    ]

    static let myList: [MyListItem] = [
        MyListItem(posterPath: "/7V0Ebks0GgpKvQ7QbLAIdX5dos4.jpg"),
        MyListItem(posterPath: "/bRwnj8WEKBCvmfeUNOukJPwB43K.jpg"),
        MyListItem(posterPath: "/1XS1oqL89opfnbLl8WnZY1O1uJx.jpg"),
        MyListItem(posterPath: "/sfQtVlIHljToOwYjhe21KPGzZWK.jpg"),
        MyListItem(posterPath: "/259wnijEJoJLPuZuscxDTqwnypw.jpg"),
        MyListItem(posterPath: "/rhGx6E3qRNMgj3i5su2oukNHwIQ.jpg"),
        MyListItem(posterPath: "/fCAURTUx3YfsJ8k9I0UamjSILiR.jpg"),
        MyListItem(posterPath: "/zP19YO60jwEsfKd5Qf1UvA5uJu8.jpg"),
        MyListItem(posterPath: "/2sOEJzhPzjTkZSlPbGxOJ7xgIyS.jpg"),
    ]

    static let history: [HistoryItem] = [
        HistoryItem(title: "Silo — S2 E4", watchedAt: "Today at 8:42 PM",
                    posterPath: "/gMYZZvnkVNTqSVnVCphWbPXwWwb.jpg"),
        HistoryItem(title: "Obsession", watchedAt: "Yesterday",
                    posterPath: "/bRwnj8WEKBCvmfeUNOukJPwB43K.jpg"),
        HistoryItem(title: "House of the Dragon — S2 E7", watchedAt: "Yesterday",
                    posterPath: "/7V0Ebks0GgpKvQ7QbLAIdX5dos4.jpg"),
        HistoryItem(title: "The Odyssey", watchedAt: "2 days ago",
                    posterPath: "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg"),
        HistoryItem(title: "Rick and Morty — S8 E3", watchedAt: "3 days ago",
                    posterPath: "/owhkU6KRqdXoUQpjV8uyZGPtX58.jpg"),
        HistoryItem(title: "Project Hail Mary", watchedAt: "4 days ago",
                    posterPath: "/yihdXomYb5kTeSivtFndMy5iDmf.jpg"),
    ]
}

#Preview {
    MyStuffView()
        .preferredColorScheme(.dark)
}
