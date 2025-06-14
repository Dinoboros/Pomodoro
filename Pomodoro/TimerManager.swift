//
//  TimerManager.swift
//  Pomodoro
//
//  Created by Méryl VALIER on 14/06/2025.
//

import Foundation

@MainActor
@Observable
class TimerManager {
    private(set) var isRunning = false
    private(set) var isPaused = false
    private(set) var timeRemaining = 0
    
    private var timerTask: Task<Void, Never>?
    private var originalDuration = 0
    
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return "\(minutes):\(String(format: "%02d", seconds))"
    }
    
    var progress: Double {
        guard originalDuration > 0 else { return 0 }
        return Double(originalDuration - timeRemaining) / Double(originalDuration)
    }
    
    func setupTimer(duration: Int) {
        originalDuration = duration * 60
        timeRemaining = originalDuration
        isRunning = false
        isPaused = false
    }
    
    func startTimer() {
        guard timeRemaining > 0 else { return }
        isRunning = true
        isPaused = false
        
        timerTask = Task {
            while timeRemaining > 0 && isRunning && !Task.isCancelled {
                if !isPaused {
                    timeRemaining -= 1
                }
                try? await Task.sleep(for: .seconds(1))
            }
            // Timer finished
            if timeRemaining == 0 {
                await handleTimerCompletion()
            }
        }
    }
    
    func pauseTimer() {
        isPaused = true
    }
    
    func resumeTimer() {
        isPaused = false
    }
    
    func stopTimer() {
        isRunning = false
        isPaused = false
        timerTask?.cancel()
        timerTask = nil
        timeRemaining = 0
        originalDuration = 0
    }
    
    private func handleTimerCompletion() {
        isRunning = false
        isPaused = false
        // Here you can add notification logic, sound, or other completion actions
    }
} 