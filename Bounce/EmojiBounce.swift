//
//  EmojiBounce.swift
//  DialogueDoc
//
//  Created by mini project on 19/04/24.
//

import SwiftUI
struct EmojiBounce: View {
    @AppStorage("highScore") private var highScore = 0

    var body: some View {
        ZStack {
            RadialGradient(colors: [.yellow, .orange, .red], center: .center, startRadius: 0, endRadius: 300)
                .edgesIgnoringSafeArea(.all)
            BackgroundView()

            VStack {
                Text("Emoji Bounce")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()


                Text("High Score: \(highScore)")
                    .font(.title)
                    .foregroundColor(.white)

                Spacer()

                NavigationLink(destination: GameView()) {
                    Text("Play Now")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

struct BackgroundView: View {
    let emojis = ["😀", "😃", "😄", "😁"]
    @State private var emojiPositions: [CGPoint] = []
    @State private var emojiScales: [CGFloat] = []
    @State private var timer: Timer?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(emojiPositions.indices, id: \.self) { index in
                    Text(emojis[index % emojis.count])
                        .font(.system(size: 80 * emojiScales[index]))
                        .position(emojiPositions[index])
                        .animation(.linear(duration: 0.5), value: emojiPositions[index])
                        .scaleEffect(emojiScales[index])
                }
            }
            .onAppear {
                initializePositions(in: geometry)
                startTimer()
            }
        }
    }

    private func initializePositions(in geometry: GeometryProxy) {
        emojiPositions = (0..<4).map { _ in
            CGPoint(x: CGFloat.random(in: 0..<geometry.size.width), y: CGFloat.random(in: 0..<geometry.size.height))
        }
        emojiScales = Array(repeating: 1.0, count: 4)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation(.linear(duration: 0.5)) {
                updateEmojiPositions()
            }
        }
    }

    private func updateEmojiPositions() {
        emojiPositions = emojiPositions.map { position in
            let newX = position.x + CGFloat.random(in: -40...40)
            let newY = position.y + CGFloat.random(in: -40...40)
            return CGPoint(
                x: newX < 0 ? 0 : (newX > UIScreen.main.bounds.width ? UIScreen.main.bounds.width : newX),
                y: newY < 0 ? 0 : (newY > UIScreen.main.bounds.height ? UIScreen.main.bounds.height : newY)
            )
        }

        emojiScales = emojiScales.map { _ in
            CGFloat.random(in: 0.8...1.2)
        }
    }
}



struct Content_preview: PreviewProvider {
    static var previews: some View {
        EmojiBounce()
    }
}
