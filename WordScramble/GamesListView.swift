//
//  GamesListView.swift
//  WordScramble
//
//  Created by Rishi Singh on 17/09/23.
//

import SwiftUI

struct GamesListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var games: FetchedResults<Game>
    
    init(searchText: String) {
        if searchText.isEmpty {
            _games = FetchRequest<Game>(sortDescriptors: [
                SortDescriptor(\.createdOn, order: .reverse),
                SortDescriptor(\.word)
            ], predicate: nil)
        } else {
            _games = FetchRequest<Game>(sortDescriptors: [
                SortDescriptor(\.word),
                SortDescriptor(\.createdOn)
            ], predicate: NSPredicate(format: "word CONTAINS[c] %@", searchText))
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("Games").font(.headline).foregroundColor(.black)) {
                ForEach(games) { game in
                    NavigationLink {
                        GameView(game: game)
                    } label: {
                        HStack {
                            Image(systemName: "\(game.guessedWords?.count ?? 0).circle")
                            Text(game.word ?? "Unknown game word")
                        }
                    }
                }
                .onDelete(perform: deleteGame)
            }
        }
    }
    
    func deleteGame(at offsets: IndexSet) {
        for offset in offsets {
            let game = games[offset]
            moc.delete(game)
        }
        
        if moc.hasChanges {
            try? moc.save()
        }
    }
}

struct GamesListView_Previews: PreviewProvider {
    static var previews: some View {
        GamesListView(searchText: "")
    }
}
