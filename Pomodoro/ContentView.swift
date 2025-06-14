//
//  ContentView.swift
//  Pomodoro
//
//  Created by Méryl VALIER on 14/06/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showStartScreen = false
    @State private var isTimerActive = false
    @State private var currentSettings: PomodoroSettings?
    @State private var timerManager = TimerManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                if isTimerActive {
                    activeTimerView
                } else {
                    initialStateView
                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $showStartScreen) {
                StartScreen { settings in
                    handleStartPomodoro(with: settings)
                }
                .presentationDetents([.large])
            }
        }
    }
    
    private var activeTimerView: some View {
        VStack(spacing: 40) {
            timerDisplayView
            timerControlsView
        }
    }
    
    private var timerDisplayView: some View {
        VStack(spacing: 16) {
            Text(timerManager.formattedTime)
                .font(.system(size: 64, weight: .light, design: .monospaced))
                .foregroundColor(.primary)
            VStack {
                if let settings = currentSettings {
                    Text("Cycle x of \(settings.totalCycles)")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    Text("Work Session • \(settings.selectedTimer) minutes")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text("Short break: \(settings.shortBreak) minutes")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    Text("Long break: \(settings.longBreak) minutes")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            
            ProgressView(value: timerManager.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(height: 8)
                .padding(.horizontal, 40)
        }
    }
    
    private var timerControlsView: some View {
        HStack(spacing: 40) {
            if !timerManager.isRunning {
                startTimerButton
            } else {
                pauseResumeButton
            }
            
            stopButton
        }
    }
    
    private var startTimerButton: some View {
        TimerButton(
            title: "Start",
            backgroundColor: .green,
            action: {
                timerManager.startTimer()
            }
        )
    }
    
    private var pauseResumeButton: some View {
        TimerButton(
            title: timerManager.isPaused ? "Resume" : "Pause",
            backgroundColor: timerManager.isPaused ? .green : .orange,
            action: {
                if timerManager.isPaused {
                    timerManager.resumeTimer()
                } else {
                    timerManager.pauseTimer()
                }
            }
        )
    }
    
    private var stopButton: some View {
        TimerButton(
            title: "Stop",
            backgroundColor: .red,
            action: {
                timerManager.stopTimer()
                resetToInitialState()
            }
        )
    }
    
    private var initialStateView: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Image(systemName: "timer")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Ready to start a Pomodoro session?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                showStartScreen = true
            }) {
                Text("Start New Session")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
    }
    
    private func handleStartPomodoro(with settings: PomodoroSettings) {
        currentSettings = settings
        timerManager.setupTimer(duration: settings.selectedTimer)
        isTimerActive = true
    }
    
    private func resetToInitialState() {
        isTimerActive = false
        currentSettings = nil
    }
}

#Preview {
    ContentView()
}
