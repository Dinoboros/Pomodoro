//
//  CustomizablePickerSection.swift
//  Pomodoro
//
//  Created by Méryl VALIER on 14/06/2025.
//

import SwiftUI

struct CustomizablePickerSection<T: Hashable>: View {
    let title: String
    let footerText: String
    let customFooterText: String
    let customButtonText: String
    let presetOptions: [(String, T)]
    
    @Binding var selectedValue: T
    @State private var isCustomMode = false
    @State private var customValue = ""
    @FocusState private var isCustomFocused: Bool
    
    let onCustomValueChange: (String) -> T?
    
    var body: some View {
        Section {
            if !isCustomMode {
                presetPicker
                customModeButton
            } else {
                customInput
                backToPresetsButton
            }
        } header: {
            Text(title)
        } footer: {
            Text(isCustomMode ? customFooterText : footerText)
        }
    }
    
    private var presetPicker: some View {
        Picker(title, selection: $selectedValue) {
            ForEach(presetOptions, id: \.1) { option in
                Text(option.0).tag(option.1)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var customModeButton: some View {
        Button(action: {
            isCustomMode = true
            customValue = "\(selectedValue)"
            isCustomFocused = true
        }) {
            HStack {
                Image(systemName: "plus")
                Text(customButtonText)
            }
            .foregroundColor(.blue)
        }
    }
    
    private var customInput: some View {
        HStack {
            Text("\(customButtonText):")
                .textCase(.none)
            Spacer()
            TextField(getPlaceholder(), text: $customValue)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .focused($isCustomFocused)
                .frame(width: 80)
                .onChange(of: customValue) { _, newValue in
                    if let value = onCustomValueChange(newValue) {
                        selectedValue = value
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Done") {
                            isCustomFocused = false
                        }
                    }
                }
        }
    }
    
    private var backToPresetsButton: some View {
        Button(action: {
            isCustomMode = false
            isCustomFocused = false
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back to presets")
            }
            .foregroundColor(.blue)
        }
    }
    
    private func getPlaceholder() -> String {
        if customButtonText.contains("cycle") {
            return "Cycles"
        } else {
            return "Minutes"
        }
    }
}

#Preview {
    Form {
        CustomizablePickerSection(
            title: "Select a timer (in minutes)",
            footerText: "The timer is the duration of the work session.",
            customFooterText: "Enter your custom work session duration.",
            customButtonText: "Custom timer",
            presetOptions: [
                ("5", 5),
                ("10", 10),
                ("20", 20),
                ("30", 30)
            ],
            selectedValue: .constant(10),
            onCustomValueChange: { value in
                Int(value).flatMap { $0 > 0 ? $0 : nil }
            }
        )
    }
} 