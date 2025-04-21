//
//  ContentView.swift
//  Hanging_game
//
//  Created by Nina on 17.03.25.
//

import SwiftUI
import AVFoundation

struct HangmanGameView: View {
    @State private var wordsToGuess: [String: [String]] = [
        "en": ["WORLD", "SWIFT", "APPLE", "CODE", "MOBILE", "DEVELOPER"],
        "ka": ["სამყარო", "სწრაფი", "ვაშლი", "კოდი", "მობილური", "დეველოპერი"]
    ]
    @State private var wordToGuess = "WORLD"
    @State private var guessedLetters: [Character] = []
    @State private var incorrectGuesses = 0
    @State private var maxAttempts = 10
    
    @State private var audioPlayer: AVAudioPlayer?
    @AppStorage("SoundFX") private var soundFXOn: Bool = true
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    
    private var localizedTexts: [String: [String: String]] = [
        "en": [
            "title": "Hangman Game",
            "incorrectAttempts": "Incorrect Attempts:",
            "youLost": "You Lost! The word was",
            "youWin": "You Win!",
            "tryNewWord": "Try New Word"
        ],
        "ka": [
            "title": "ჩამოხრჩობა",
            "incorrectAttempts": "შეცდომები:",
            "youLost": "თქვენ დამარცხდით! სიტყვა იყო",
            "youWin": "თქვენ მოიგეთ!",
            "tryNewWord": "სცადეთ ახალი სიტყვა"
        ]
    ]
    
    private var alphabet: [String: String] = [
        "en": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "ka": "აბგდევზთიკლმნოპჟრსტუფქღყშჩცძწჭხჯჰ"
    ]
    
    private var displayedWord: String {
        wordToGuess.map { guessedLetters.contains($0) ? String($0) : "_" }.joined(separator: " ")
    }
    
    private var gameOver: Bool {
        incorrectGuesses >= maxAttempts || !displayedWord.contains("_")
    }
    
    var body: some View {
        VStack {
            // Header: Language Picker
                        HStack {
                            Spacer()
                            Picker("Language", selection: $selectedLanguage) {
                                Text("🇬🇧 English").tag("en")
                                Text("🇬🇪 ქართული").tag("ka")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                        }
                        
            Text(localizedTexts[selectedLanguage]?["title"] ?? "Hangman Game")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(5)
            
            HangmanDrawing(incorrectGuesses: incorrectGuesses)
                .frame(height: 200)
                .padding(5)
            
            Text("\(localizedTexts[selectedLanguage]?["incorrectAttempts"] ?? "Incorrect Attempts:") \(incorrectGuesses)/\(maxAttempts)")
                .font(.headline)
                .foregroundColor(.red)
            
            Text(displayedWord)
                .font(.title)
                .fontWeight(.bold)
                .padding(5)
            
            if gameOver {
                Text(gameOverMessage())
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(5)
                    .onAppear {
                        if incorrectGuesses >= maxAttempts {
                            playSound(name: "game_over", fileExtension: "wav")
                        } else {
                            playSound(name: "game_win", fileExtension: "wav")
                        }
                    }
                
                Button(action: resetGame) {
                    Text(localizedTexts[selectedLanguage]?["tryNewWord"] ?? "Try New Word")
                        .font(.title3)
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 45), spacing: 12)]) {
                    ForEach(alphabet[selectedLanguage]?.map { String($0) } ?? [], id: \..self) { letter in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.2)) {
                                guessLetter(letter)
                            }
                        }) {
                            Text(letter)
                                .font(.system(size: 16, weight: .medium))
                                .padding(5)
                                .frame(width: 50, height: 50)
                                .background(guessedLetters.contains(Character(letter)) ? Color.blue.opacity(0.4) : Color.blue.opacity(0.2))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                        .disabled(guessedLetters.contains(Character(letter)))
                    }
                }
                .padding(5)
            }
        }
        .padding(5)
    }
    
    private func gameOverMessage() -> String {
        if incorrectGuesses >= maxAttempts {
            return "\(localizedTexts[selectedLanguage]?["youLost"] ?? "You Lost!") \(wordToGuess)"
        } else {
            return localizedTexts[selectedLanguage]?["youWin"] ?? "You Win!"
        }
    }
    
    private func resetGame() {
        wordToGuess = wordsToGuess[selectedLanguage]?.randomElement() ?? "WORLD"
        guessedLetters = []
        incorrectGuesses = 0
        playSound(name: "new_game", fileExtension: "wav")
    }
    
    private func guessLetter(_ letter: String) {
        let char = Character(letter)
        guessedLetters.append(char)
        if !wordToGuess.contains(char) {
            incorrectGuesses += 1
            playSound(name: "wrong_answer", fileExtension: "wav")
        } else {
            playSound(name: "correct_answer", fileExtension: "wav")
        }
    }
    
    private func playSound(name: String, fileExtension: String) {
        guard soundFXOn, let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            print("Sound file not found: \(name).\(fileExtension)")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }
}

struct HangmanGameView_Previews: PreviewProvider {
    static var previews: some View {
        HangmanGameView()
    }
}


//struct LetterGridView: View {
//    @Binding var guessedLetters: [Character]
//    @Binding var incorrectGuesses: Int
//    let wordToGuess: String
//    let playSound: (String) -> Void
//    
//    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
//    
//    var body: some View {
//        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
//            ForEach(alphabet.map { String($0) }, id: \..self) { letter in
//                Button(action: {
//                    guessLetter(letter)
//                }) {
//                    Text(letter)
//                        .adaptive(minimum: 45)
//                        .font(.system(size: 12))
//                        .padding()
//                        .background(Color.blue.opacity(0.2))
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//
//                }
//                .disabled(guessedLetters.contains(Character(letter)))
//            }
//        }
//        .padding()
//    }
//    
//    private func guessLetter(_ letter: String) {
//        let char = Character(letter)
//        guessedLetters.append(char)
//        if !wordToGuess.contains(char) {
//            incorrectGuesses += 1
//            playSound("wrong_answer")
//        } else {
//            playSound("correct-answer")
//        }
//    }
//}
