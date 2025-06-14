//
//  TimerButton.swift
//  Pomodoro
//
//  Created by Méryl VALIER on 14/06/2025.
//

import SwiftUI

struct TimerButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .background(backgroundColor)
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: backgroundColor)
    }
}

#Preview {
    TimerButton(
        title: "Start",
        backgroundColor: .green,
        action: {}
    )
} 