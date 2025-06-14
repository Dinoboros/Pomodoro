//
//  StartScreen.swift
//  Pomodoro
//
//  Created by Méryl VALIER on 14/06/2025.
//

import SwiftUI

struct PomodoroSettings {
    let totalCycles: Int
    let selectedTimer: Int
    let shortBreak: Int
    let longBreak: Int
}

struct StartScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var totalCycles = 3
    @State private var selectedTimer = 20
    @State private var shortBreak = 5
    @State private var longBreak = 10
    
    let onStart: (PomodoroSettings) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    cycleSection
                    timerSection
                    shortBreakSection
                    longBreakSection
                }
                
                Spacer()
                
                startButton
                    .padding(.horizontal)
                    .padding(.bottom, 32)
            }
            .navigationTitle("Session Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var cycleSection: some View {
        CustomizablePickerSection(
            title: "How many cycles do you want to do?",
            footerText: "A cycle is a work session followed by a short break.",
            customFooterText: "Enter your custom number of cycles.",
            customButtonText: "Custom cycle count",
            presetOptions: [
                ("1", 1),
                ("2", 2),
                ("3", 3),
                ("4", 4),
                ("5", 5)
            ],
            selectedValue: $totalCycles,
            onCustomValueChange: { value in
                Int(value).flatMap { $0 > 0 ? $0 : nil }
            }
        )
    }
    
    private var timerSection: some View {
        CustomizablePickerSection(
            title: "Select a timer (in minutes)",
            footerText: "The timer is the duration of the work session.",
            customFooterText: "Enter your custom work session duration.",
            customButtonText: "Custom timer",
            presetOptions: [
                ("5", 5),
                ("10", 10),
                ("20", 20),
                ("30", 30),
                ("40", 40),
                ("60", 60)
            ],
            selectedValue: $selectedTimer,
            onCustomValueChange: { value in
                Int(value).flatMap { $0 > 0 ? $0 : nil }
            }
        )
    }
    
    private var shortBreakSection: some View {
        CustomizablePickerSection(
            title: "Select a short break (in minutes)",
            footerText: "The short break is the duration between work sessions.",
            customFooterText: "Enter your custom short break duration.",
            customButtonText: "Custom short break",
            presetOptions: [
                ("5", 5),
                ("10", 10),
                ("15", 15),
                ("20", 20)
            ],
            selectedValue: $shortBreak,
            onCustomValueChange: { value in
                Int(value).flatMap { $0 > 0 ? $0 : nil }
            }
        )
    }
    
    private var longBreakSection: some View {
        CustomizablePickerSection(
            title: "Select a long break (in minutes)",
            footerText: "The long break is the duration between cycles.",
            customFooterText: "Enter your custom long break duration.",
            customButtonText: "Custom long break",
            presetOptions: [
                ("10", 10),
                ("20", 20),
                ("30", 30),
                ("40", 40),
                ("60", 60)
            ],
            selectedValue: $longBreak,
            onCustomValueChange: { value in
                Int(value).flatMap { $0 > 0 ? $0 : nil }
            }
        )
    }
    
    private var startButton: some View {
        Button(action: {
            let settings = PomodoroSettings(
                totalCycles: totalCycles,
                selectedTimer: selectedTimer,
                shortBreak: shortBreak,
                longBreak: longBreak
            )
            onStart(settings)
            dismiss()
        }) {
            Text("Start Pomodoro")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
}

#Preview {
    StartScreen { _ in }
} 