//
//  MovieFilterContentView.swift
//  TopMovies
//
//  Created by Maria José Sánchez Cairazco on 10/06/24.
//

import SwiftUI

struct MovieFilterContentView: View {
    @Binding var adult: Bool?
    @Binding var language: String?
    @Binding var minVote: Double?
    @Binding var maxVote: Double?
    
    @Environment(\.presentationMode) var presentationMode
    
    var applyFilters: () -> Void
    var availableLanguages: [String: String]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Adult")) {
                    Toggle(isOn: Binding(
                        get: { self.adult ?? false },
                        set: { self.adult = $0 }
                    )) {
                        Text("Include Adult")
                    }
                }

                Section(header: Text("Language")) {
                    Picker("Original Language", selection: $language) {
                        Text("Any").tag(String?.none)
                        ForEach(availableLanguages.keys.sorted(), id: \.self) { code in
                            Text("\(availableLanguages[code] ?? "")").tag(String?.some(code))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Vote Average")) {
                    VStack {
                        Text("Min Vote: \(minVote ?? 0.0, specifier: "%.1f")")
                        Slider(value: Binding(
                            get: { self.minVote ?? 0.0 },
                            set: { self.minVote = $0 }
                        ), in: 0...10, step: 0.1)
                        Text("Max Vote: \(maxVote ?? 10.0, specifier: "%.1f")")
                        Slider(value: Binding(
                            get: { self.maxVote ?? 10.0 },
                            set: { self.maxVote = $0 }
                        ), in: 0...10, step: 0.1)
                    }
                }

                Button(action: {
                    applyFilters()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Go")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
            }
            .navigationTitle("Filter Movies")
        }
    }
}
