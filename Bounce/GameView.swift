//  GameView.swift
//  DialogueDoc
//
//  Created by mini project on 18/04/24.
//

import SwiftUI

struct GameView: View {
    @AppStorage("highScore") private var highScore = 0
    @State private var emojiPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: 50)
    @State private var paddlePosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50)
    @State private var emojiVelocity = CGPoint(x: 5, y: 5)
    @State private var score = 0
    @State private var isGameOver = false
    @State private var showGameOverAlert = false
    @State private var emojiTimer: Timer?

    var body: some View {
        ZStack {
            Color.yellow

            Text("\(score)")
                .font(.system(size: 100, weight: .bold, design: .monospaced))
                .foregroundColor(.orange)
                .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)

            VStack {
//                Text("High Score: \(highScore)")
//                    .font(.title2)
//                    .foregroundColor(.black)

                Spacer()

                Text("🙂")
                    .font(.system(size: 50))
                    .position(emojiPosition)
                    .animation(.linear(duration: 0.2), value: emojiPosition)

                Spacer()
            }

            Rectangle()
                .fill(Color.black)
                .cornerRadius(20.0)
                .frame(width: 100, height: 30)
                .position(x: paddlePosition.x, y: UIScreen.main.bounds.height - 40)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            paddlePosition.x = value.location.x
                        }
                        .onEnded { _ in
                            paddlePosition.x = max(75, min(paddlePosition.x, UIScreen.main.bounds.width - 75))
                        }
                )

            .onAppear {
                emojiAnimation()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showGameOverAlert) {
            Alert(title: Text("Game Over"),
                  message: Text("Your final score is \(score)"),
                  dismissButton: .default(Text("Play Again")) {
                    resetGame()
                  })
        }
    }

    func emojiAnimation() {
        self.emojiTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            updateEmojiPosition()
        }
    }

    func updateEmojiPosition() {
        emojiPosition.x += emojiVelocity.x
        emojiPosition.y += emojiVelocity.y

        // Check for collisions with screen edges
        if emojiPosition.x < 25 || emojiPosition.x > UIScreen.main.bounds.width - 25 {
            emojiVelocity.x *= -1
        }

        if emojiPosition.y < 25 {
            emojiVelocity.y *= -1
        }

        // Check for collision with paddle
        if emojiPosition.y >= UIScreen.main.bounds.height - 70 &&
           emojiPosition.y <= UIScreen.main.bounds.height &&
           emojiPosition.x > paddlePosition.x - 100 &&
           emojiPosition.x < paddlePosition.x + 100 {
            emojiVelocity.y *= -1 // Reverse the vertical velocity
            score += 1 // Award points only if it touches the paddle
            emojiPosition.y = UIScreen.main.bounds.height - 130 - 25 // Adjust the emoji's position to be just above the paddle
            updateHighScore()
        } else if emojiPosition.y > UIScreen.main.bounds.height {
            showGameOverAlert = true
            emojiTimer?.invalidate() // Stop the timer when the game is over
        }
    }
    func resetGame() {
        emojiPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: 50)
        paddlePosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 50)
        emojiVelocity = CGPoint(x: 5, y: 5)
        score = 0
        isGameOver = false
        showGameOverAlert = false
        emojiAnimation() // Restart emoji animation
    }

    func updateHighScore() {
        if score > highScore {
            highScore = score
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}




