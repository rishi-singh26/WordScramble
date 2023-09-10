//
//  ContentView.swift
//  WordScramble
//
//  Created by Rishi Singh on 10/09/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List(0..<5) {
            Text("Dynamic row \($0)")
        }
        .listStyle(.sidebar)
    }
    
    func loadFile() {
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileURL) {
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
