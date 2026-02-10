//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Macedo on 30/01/26.
//

import SwiftUI

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreDescription = ""
    @State private var score = 0
    @State private var round = 1

    // Challenge from Views and modifiers
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .clipShape(RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous)
                )
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .alert(scoreTitle, isPresented: $showingScore) {
                            Button("Continue") {
                                askQuestion()
                                round += 1
                            }
                        } message: {
                            Text(scoreDescription)
                        }
                    }
                    
                    Text("Round \(round) of 8")
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func flagTapped(_ number: Int) {
        let isCorrect = number == correctAnswer
        
        if isCorrect {
            scoreTitle = "Correct"
            scoreDescription = "That's right! Keep going!"
            score += 1
        } else {
            scoreTitle = "Wrong"
            scoreDescription = "Wrong! That’s the flag of \(countries[number])"
        }
        
        if round == 8 {
            scoreTitle = "Game Over"
            scoreDescription = "You got \(score) out of 8 flags correctly."
            showingScore = true
            round = 1
            score = 0
            return
        }
        
        showingScore = true
    }
}
