import SwiftUI

struct LiveTVView: View {
    @State private var selectedCategory = "All"
    private let categories = ["All", "Sports", "News", "Movies", "Kids", "Reality", "Music"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header

                categoryPills

                FeaturedLiveCard(item: LiveMockData.featured)

                onNowGrid

                upcomingSection

                Color.clear.frame(height: 100)
            }
            .padding(.top, 8)
        }
        .background(Color.black)
        .scrollIndicators(.hidden)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("Live TV")
                .font(.system(size: 28, weight: .heavy))
                .foregroundStyle(.white)

            Spacer()

            Image(systemName: "calendar")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.9))
        }
        .padding(.horizontal, 16)
    }

    private var categoryPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(categories, id: \.self) { cat in
                    let isSelected = cat == selectedCategory
                    Text(cat)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(isSelected ? .black : .white)
                        .padding(.horizontal, 14)
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

    private var onNowGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("On now")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                Spacer()
                Text("\(LiveMockData.onNow.count) channels")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.horizontal, 16)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                spacing: 10
            ) {
                ForEach(LiveMockData.onNow) { channel in
                    ChannelCard(channel: channel)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Coming up next")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(LiveMockData.upcoming) { item in
                        UpcomingCard(item: item)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

private struct FeaturedLiveCard: View {
    let item: LiveChannel

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(item.posterPath)")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color("greyBg")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black.opacity(0.3), location: 0.5),
                    .init(color: .black.opacity(0.95), location: 1),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack {
                HStack {
                    Text("LIVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.brand))

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                            .font(.caption2)
                        Text(item.viewers)
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(.black.opacity(0.55)))
                }

                Spacer()

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.channel.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.7))
                    Text(item.programTitle)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.white.opacity(0.2))
                            .frame(height: 4)
                            .overlay(alignment: .leading) {
                                GeometryReader { geo in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.brand)
                                        .frame(width: geo.size.width * item.progress, height: 4)
                                }
                            }
                    }
                    .padding(.vertical, 4)

                    HStack {
                        Text("\(Int(item.progress * 100))% aired")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.7))
                        Spacer()
                        Text(item.timeRemaining)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.7))
                    }

                    HStack(spacing: 8) {
                        Label("Watch", systemImage: "play.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Capsule().fill(.white))

                        Image(systemName: "bell")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 22)
                            .background(Capsule().fill(.white.opacity(0.15)))
                    }
                    .padding(.top, 6)
                }
            }
            .padding(16)
        }
        .aspectRatio(16/22, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 16)
    }
}

private struct ChannelCard: View {
    let channel: LiveChannel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(channel.posterPath)")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    default:
                        Color("greyBg")
                    }
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .clipped()

                LinearGradient(
                    colors: [.black.opacity(0.5), .clear],
                    startPoint: .top,
                    endPoint: .center
                )
                .frame(height: 100)

                HStack {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.brand)
                            .frame(width: 6, height: 6)
                        Text("LIVE")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(.black.opacity(0.55)))

                    Spacer()

                    Text(channel.viewers)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(.black.opacity(0.55)))
                }
                .padding(8)

                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 1)
                        .fill(.white.opacity(0.25))
                        .frame(height: 2)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(Color.brand)
                                    .frame(width: geo.size.width * channel.progress, height: 2)
                            }
                        }
                }
            }
            .frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(channel.channel)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.55))
                Text(channel.programTitle)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(2)
            }
        }
    }
}

private struct UpcomingCard: View {
    let item: UpcomingProgram

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(item.posterPath)")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Color("greyBg")
                }
            }
            .frame(width: 160, height: 100)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.startsAt)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.brand)
                Text(item.title)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                Text(item.channel)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .frame(width: 160, alignment: .leading)
    }
}

struct LiveChannel: Identifiable {
    let id = UUID()
    let channel: String
    let programTitle: String
    let viewers: String
    let progress: Double
    let timeRemaining: String
    let posterPath: String
}

struct UpcomingProgram: Identifiable {
    let id = UUID()
    let startsAt: String
    let title: String
    let channel: String
    let posterPath: String
}

private enum LiveMockData {
    static let featured = LiveChannel(
        channel: "livenav Sports 1",
        programTitle: "Arsenal vs Man City · Premier League",
        viewers: "218K watching",
        progress: 0.42,
        timeRemaining: "58 min left",
        posterPath: "/hwRdDFIhaEmpRgoki805YvyyjZf.jpg"
    )

    static let onNow: [LiveChannel] = [
        LiveChannel(channel: "livenav News", programTitle: "Evening Briefing", viewers: "84K",
                    progress: 0.65, timeRemaining: "10m",
                    posterPath: "/259wnijEJoJLPuZuscxDTqwnypw.jpg"),
        LiveChannel(channel: "HBO", programTitle: "House of the Dragon marathon", viewers: "312K",
                    progress: 0.22, timeRemaining: "3h 12m",
                    posterPath: "/7V0Ebks0GgpKvQ7QbLAIdX5dos4.jpg"),
        LiveChannel(channel: "Kids TV", programTitle: "Toy Story 5 (movie)", viewers: "56K",
                    progress: 0.55, timeRemaining: "48m",
                    posterPath: "/sfQtVlIHljToOwYjhe21KPGzZWK.jpg"),
        LiveChannel(channel: "Discovery", programTitle: "The Odyssey — behind the scenes", viewers: "41K",
                    progress: 0.71, timeRemaining: "16m",
                    posterPath: "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg"),
        LiveChannel(channel: "SyFy Live", programTitle: "Silo Q&A with cast", viewers: "72K",
                    progress: 0.15, timeRemaining: "1h 22m",
                    posterPath: "/gMYZZvnkVNTqSVnVCphWbPXwWwb.jpg"),
        LiveChannel(channel: "Comedy Central", programTitle: "The Devil Wears Prada 2 marathon", viewers: "128K",
                    progress: 0.83, timeRemaining: "8m",
                    posterPath: "/fCAURTUx3YfsJ8k9I0UamjSILiR.jpg"),
    ]

    static let upcoming: [UpcomingProgram] = [
        UpcomingProgram(startsAt: "8:00 PM", title: "Passenger — premiere", channel: "livenav Originals",
                        posterPath: "/2sOEJzhPzjTkZSlPbGxOJ7xgIyS.jpg"),
        UpcomingProgram(startsAt: "8:30 PM", title: "Deep Water", channel: "Thriller Channel",
                        posterPath: "/kjcuS7xaRyqRjVaVcH4t0qHshuX.jpg"),
        UpcomingProgram(startsAt: "9:00 PM", title: "Mortal Kombat II", channel: "Action Now",
                        posterPath: "/hwRdDFIhaEmpRgoki805YvyyjZf.jpg"),
        UpcomingProgram(startsAt: "9:15 PM", title: "Scary Movie (2026 reboot)", channel: "Comedy Central",
                        posterPath: "/1KlYdWoOrbL5ux357rW9LC155qw.jpg"),
        UpcomingProgram(startsAt: "10:00 PM", title: "Obsession", channel: "livenav Prestige",
                        posterPath: "/bRwnj8WEKBCvmfeUNOukJPwB43K.jpg"),
    ]
}

#Preview {
    LiveTVView()
        .preferredColorScheme(.dark)
}
