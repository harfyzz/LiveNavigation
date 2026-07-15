import SwiftUI

struct ScenesView: View {
    @State private var selectedMood = "For you"
    private let moods = ["For you", "Iconic", "Emotional", "Funny", "Action", "Twists"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                moodPills

                LazyVStack(spacing: 16) {
                    ForEach(ScenesMockData.scenes) { scene in
                        SceneCard(scene: scene)
                    }
                }
                .padding(.horizontal, 16)

                Color.clear.frame(height: 100)
            }
            .padding(.top, 8)
        }
        .background(Color.black)
        .scrollIndicators(.hidden)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Scenes")
                .font(.system(size: 28, weight: .heavy))
                .foregroundStyle(.white)
            Text("Bite-sized moments from your queue")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.55))
        }
        .padding(.horizontal, 16)
    }

    private var moodPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(moods, id: \.self) { mood in
                    let isSelected = mood == selectedMood
                    Text(mood)
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
                                selectedMood = mood
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct SceneCard: View {
    let scene: SceneClip
    @State private var liked = false

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(scene.posterPath)")) { phase in
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
                    .init(color: .clear, location: 0.0),
                    .init(color: .black.opacity(0.2), location: 0.4),
                    .init(color: .black.opacity(0.9), location: 1.0),
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack {
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "play.fill")
                            .font(.caption2)
                        Text(scene.duration)
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(.black.opacity(0.55)))

                    Spacer()

                    Text(scene.mood.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.brand))
                }
                .padding(14)

                Spacer()

                Circle()
                    .fill(.white.opacity(0.15))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Image(systemName: "play.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                    )
                    .background(Circle().fill(.ultraThinMaterial))

                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text(scene.source)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.65))
                    Text(scene.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    HStack(spacing: 14) {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { liked.toggle() }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: liked ? "heart.fill" : "heart")
                                    .foregroundStyle(liked ? Color.brand : .white)
                                Text(formatCount(scene.likes + (liked ? 1 : 0)))
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                        }

                        HStack(spacing: 6) {
                            Image(systemName: "bubble.left")
                            Text(formatCount(scene.comments))
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)

                        HStack(spacing: 6) {
                            Image(systemName: "arrowshape.turn.up.right")
                            Text("Share")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)

                        Spacer()

                        HStack(spacing: 4) {
                            ForEach(scene.reactions, id: \.self) { emoji in
                                Text(emoji)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(.black.opacity(0.4)))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            }
        }
        .frame(height: 460)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func formatCount(_ n: Int) -> String {
        if n >= 1000 { return String(format: "%.1fK", Double(n) / 1000) }
        return "\(n)"
    }
}

struct SceneClip: Identifiable {
    let id = UUID()
    let title: String
    let source: String
    let mood: String
    let duration: String
    let likes: Int
    let comments: Int
    let reactions: [String]
    let posterPath: String
}

private enum ScenesMockData {
    static let scenes: [SceneClip] = [
        SceneClip(title: "The war council table cracks in half",
                  source: "House of the Dragon · S1 E9",
                  mood: "Iconic", duration: "0:48",
                  likes: 12400, comments: 892, reactions: ["🔥", "😱", "👑"],
                  posterPath: "/7V0Ebks0GgpKvQ7QbLAIdX5dos4.jpg"),
        SceneClip(title: "Juliette breaks the seal on the door",
                  source: "Silo · S2 E4",
                  mood: "Twist", duration: "1:12",
                  likes: 8710, comments: 431, reactions: ["🤯", "👀"],
                  posterPath: "/gMYZZvnkVNTqSVnVCphWbPXwWwb.jpg"),
        SceneClip(title: "The Cyclops eats his second sailor",
                  source: "The Odyssey",
                  mood: "Action", duration: "0:36",
                  likes: 15200, comments: 1120, reactions: ["🔥", "👁️", "⚔️"],
                  posterPath: "/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg"),
        SceneClip(title: "Boo Radley steps out of the shadows",
                  source: "FROM · S1 E7",
                  mood: "Emotional", duration: "1:04",
                  likes: 6420, comments: 289, reactions: ["🥺", "💔"],
                  posterPath: "/pRtJagIxpfODzzb0T0NAvZSzErC.jpg"),
        SceneClip(title: "Woody hands over the sheriff badge",
                  source: "Toy Story 5",
                  mood: "Emotional", duration: "0:52",
                  likes: 22100, comments: 1834, reactions: ["😭", "🤠", "❤️"],
                  posterPath: "/sfQtVlIHljToOwYjhe21KPGzZWK.jpg"),
        SceneClip(title: "Miranda's three-word verdict",
                  source: "The Devil Wears Prada 2",
                  mood: "Iconic", duration: "0:22",
                  likes: 18300, comments: 1240, reactions: ["💅", "🔥"],
                  posterPath: "/fCAURTUx3YfsJ8k9I0UamjSILiR.jpg"),
    ]
}

#Preview {
    ScenesView()
        .preferredColorScheme(.dark)
}
