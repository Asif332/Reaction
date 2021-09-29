//
//  ContentView.swift
//  Reactions
//
//   Created by Mohammad Asif on 29/09/21.
//

import SwiftUI

struct ContentView: View {
    
    // View Model Data
    @State var reactionViewModel = ReactionViewModel(reacted: false, reaction: .like, xAxisToolTip: 0)
    
    var body: some View {
        NavigationView {
            ReactionView(reactionViewModel: $reactionViewModel)
            .navigationBarTitle("Reaction", displayMode: .large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
