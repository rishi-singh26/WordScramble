//
//  GameView.swift
//  WordScramble
//
//  Created by Rishi Singh on 17/09/23.
//

import SwiftUI

struct GameView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var guessedWords: FetchedResults<GuessedWord>
    
    init(game: Game) {
        self.game = game
        self.rootWord = game.word ?? "silkworm"
        
        _guessedWords = FetchRequest<GuessedWord>(sortDescriptors: [
            SortDescriptor(\.word),
            SortDescriptor(\.createdOn)
        ], predicate: NSPredicate(format: "game.word MATCHES %@", game.word ?? "silkworm"))
    }
    
    let rootWord: String
    let game: Game
    
//    @State private var guessedWords = [String]()
    @State private var newWord = ""
    
    @State private var errorTtile = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var score: Int {
        var score = 0
        for word in guessedWords {
            score += word.word?.count ?? 0
        }
        return score
    }
    
    var body: some View {
        List {
            Section {
                TextField("Enter your word", text: $newWord)
                    .autocapitalization(.none)
            }
            
            Section {
                ForEach(guessedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.word?.count ?? 0).circle")
                        Text(word.word ?? "")
                    }
                }
            }
        }
        .navigationTitle(rootWord)
        .onSubmit(addNewWord)
        .alert(errorTtile, isPresented: $showingError) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Text("Words: \(guessedWords.count)")
                    .fontWeight(.bold)
                Text("Score: \(score)")
                    .fontWeight(.bold)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 2 else { return }
        guard answer != rootWord else { return }
        guard isOriginal(word: answer) else { return wordError(title: "Word used alredy", message: "Be more original") }
        guard isPossible(word: answer) else { return wordError(title: "Word not possible", message: "You can't spell that from '\(rootWord)'") }
        guard isReal(word: answer) else { return wordError(title: "Word not recognised", message: "You can't just make them up, you know!") }
        
        withAnimation {
//            guessedWords.insert(answer, at: 0)
            let newWord = GuessedWord(context: moc)
            newWord.id = UUID()
            newWord.createdOn = Date.now
            newWord.gameId = game.id
            newWord.word = answer
            newWord.game = game
            
            try? moc.save()
        }
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        for guessedWord in guessedWords {
            if guessedWord.word == word {
                return false
            }
        }
        return true
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTtile = title
        errorMessage = message
        showingError = true
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(game: Game())
    }
}
