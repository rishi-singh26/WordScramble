//
//  ContentView.swift
//  WordScramble
//
//  Created by Rishi Singh on 10/09/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Section("Secton 1") {
                Text("Statci row 1")
                Text("Statci row 2")
            }
            Section("Secton 2") {
                ForEach(0..<5) {
                    Text("Dynamic row \($0)")
                }
            }
            Section("Secton 3") {
                Text("Statci row 3")
                Text("Statci row 4")
            }
        }
        .listStyle(.sidebar)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
