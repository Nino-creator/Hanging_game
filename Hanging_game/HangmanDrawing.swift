//
//  HangmanDrawing.swift
//  Hanging_game
//
//  Created by Nina on 22.04.25.
//
import SwiftUI
import AVFoundation

struct HangmanDrawing: View {
    let incorrectGuesses: Int
    
    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let baseY = size.height - 20
            let headRadius: CGFloat = 20
            
            if incorrectGuesses > 0 {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: centerX - 50, y: baseY - 200))
                    path.addLine(to: CGPoint(x: centerX + 50, y: baseY - 200))
                }, with: .color(.black), lineWidth: 3)
            }
            
            if incorrectGuesses > 1 {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: centerX, y: baseY - 200))
                    path.addLine(to: CGPoint(x: centerX, y: baseY - 150))
                }, with: .color(.black), lineWidth: 3)
            }
            
            if incorrectGuesses > 2 {
                context.stroke(Path(ellipseIn: CGRect(x: centerX - headRadius, y: baseY - 150, width: 40, height: 40)), with: .color(.black), lineWidth: 3)
            }
            
            if incorrectGuesses > 3 {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: centerX, y: baseY - 110))
                    path.addLine(to: CGPoint(x: centerX, y: baseY - 50))
                }, with: .color(.black), lineWidth: 3)
            }
            
            if incorrectGuesses > 4 {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: centerX, y: baseY - 100))
                    path.addLine(to: CGPoint(x: centerX - 30, y: baseY - 80))
                }, with: .color(.black), lineWidth: 3)
            }
            
            if incorrectGuesses > 5 {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: centerX, y: baseY - 100))
                    path.addLine(to: CGPoint(x: centerX + 30, y: baseY - 80))
                }, with: .color(.black), lineWidth: 3)
            }
            
            if incorrectGuesses > 6 {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: centerX, y: baseY - 50))
                    path.addLine(to: CGPoint(x: centerX - 30, y: baseY - 20))
                }, with: .color(.black), lineWidth: 3)
            }
            
            if incorrectGuesses > 7 {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: centerX, y: baseY - 50))
                    path.addLine(to: CGPoint(x: centerX + 30, y: baseY - 20))
                }, with: .color(.black), lineWidth: 3)
            }
            
            if incorrectGuesses > 8 {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: centerX - 20, y: baseY - 190))
                    path.addLine(to: CGPoint(x: centerX - 10, y: baseY - 180))
                }, with: .color(.black), lineWidth: 3)
            }
            
            if incorrectGuesses > 9 {
                context.stroke(Path { path in
                    path.move(to: CGPoint(x: centerX + 20, y: baseY - 190))
                    path.addLine(to: CGPoint(x: centerX + 10, y: baseY - 180))
                }, with: .color(.black), lineWidth: 3)
            }
        }
        .frame(width: 150, height: 250)
    }
}
