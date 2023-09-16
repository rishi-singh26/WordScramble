//
//  ContentView.swift
//  WordScramble
//
//  Created by Rishi Singh on 10/09/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var games: FetchedResults<Game>
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var searchText = ""
    
    var score: Int {
        var score = 0
        for word in usedWords {
            score += word.count
        }
        return score
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Games").font(.headline).foregroundColor(.black)) {
                    ForEach(games) { game in
                        NavigationLink {
                            GameView(game: game)
                        } label: {
                            HStack {
                                Image(systemName: "\(game.wordsCount).circle")
                                Text(game.word ?? "Unknown game word")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Word Scramble")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: startGame) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("New Game")
                                    .fontWeight(.bold)
                            }
                        }
                        Spacer()
                        Text("Games: \(games.count)")
                            .fontWeight(.bold)
                    }
                }
            }
            .searchable(text: $searchText)
            .listStyle(.sidebar)
            .onAppear(perform: getDocumentsDirectory)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                
                let newGame = Game(context: moc)
                newGame.id = UUID()
                newGame.word = allWords.randomElement() ?? "silkworm"
                newGame.wordsCount = 0
                newGame.createdOn = Date.now
                
                try? moc.save()
                return
            }
        }
        fatalError("Could not start.txt from bundle.")
    }
    
    func getDocumentsDirectory() {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
