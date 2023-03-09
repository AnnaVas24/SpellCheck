//
//  ContentView.swift
//  SpellCheck
//
//  Created by Vasichko Anna on 09.03.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var text = ""
    @State private var suggestions: [String]? = []
    
    private let textChecker = UITextChecker()
    
    var body: some View {
        VStack {
            VStack {
                Text("Enter some word:")
                    .font(.title)
                TextField("", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .overlay(RoundedRectangle(cornerRadius: 15) .stroke(Color.blue))
                    .frame(width: 250)
            }
            .padding()
            
            if let suggestions {
                List(suggestions, id: \.self) { suggestion in
                    HStack {
                        Text(suggestion)
                        Spacer()
                    }
                    .onTapGesture {
                        var components = text.components(separatedBy: " ")
                        components.removeLast()
                        components.append(suggestion)
                        text = components.joined(separator: " ")
                    }
                }
            }
     
        }
        .onChange(of: text, perform: { newValue in
            let misspelledRange = textChecker.rangeOfMisspelledWord(
                in: text,
                range: NSRange(0..<text.utf16.count),
                startingAt: 0,
                wrap: false,
                language: "en_US"
            )
            if misspelledRange.location != NSNotFound {
                suggestions = textChecker.guesses(
                    forWordRange: misspelledRange,
                    in: text,
                    language: "en_US"
                )
            }
        }
        )
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
