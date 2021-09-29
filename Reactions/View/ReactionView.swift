//
//  ReactionView.swift
//  Reactions
//
//   Created by Mohammad Asif on 29/09/21.

import SwiftUI

struct ReactionViewModel  {
    var reacted : Bool
    var reaction : Reactions
    var show = false
    var xAxisToolTip : Int
}

var reactions : [Reactions] = [.like, .celebrate, .haha, .love, .insightful]

struct ReactionView: View {
    @Binding var reactionViewModel : ReactionViewModel
    
    var body: some View {
        ZStack(alignment: .leading, content: {
            ReactionButtonView(reactionViewModel: $reactionViewModel)
                .zIndex(0)
            if reactionViewModel.show {
                ReactionToolTipView(reactionViewModel: $reactionViewModel)
                    .offset(y: -60)
                    .padding(.leading)
                    .zIndex(1)
            }
        })
    }
}

struct ReactionButtonView: View {
    @Binding var reactionViewModel : ReactionViewModel
    @State private var selectedReaction = Reactions.none
    
    var body: some View {
        HStack {
            HStack(alignment: .center, spacing:10) {
                if reactionViewModel.reacted {
                    selectedReaction.values.image
                        .resizable()
                        .frame(width: 20, height: 20)
                } else {
                    Image("Thumbsup")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text(selectedReaction != .none ? selectedReaction.values.selectedName : Reactions.like.values.name)
                    .font(.headline)
                    .foregroundColor(selectedReaction != .none ? selectedReaction.values.color : .gray)
            }
            .padding()
            .frame(height: 32)
            .overlay(
                RoundedRectangle(cornerRadius: CGFloat(4))
                    .stroke(lineWidth: 1)
                    .foregroundColor(.gray.opacity(0.5))
            )
            .onTapGesture(perform: {
                reactionViewModel.reacted.toggle()
                if reactionViewModel.reacted {
                    selectedReaction = .like
                    reactionViewModel.reaction = .none
                } else {
                    selectedReaction = .none
                    reactionViewModel.reaction = .like
                }
            })
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged(onChanged(value:))
                        .onEnded(onEnded(value:)))
            Spacer(minLength: 0)
        }.padding(.horizontal)
        
    }
  
    //MARK:- "Touch down"
    func onChanged(value: DragGesture.Value) {
        withAnimation(.easeIn){ reactionViewModel.show = true }
        withAnimation(Animation.linear(duration: 0.15)) {
            let height = value.translation.height
            // touch up
            let reactionOffsetValue : CGFloat = -40
            if height <= reactionOffsetValue {
                self.setReactionAndToolTipLocationX(location: Int(value.location.x))
            } else {
                reactionViewModel.xAxisToolTip = ReactionsToolTipLocationX.outOfRange
                reactionViewModel.reaction = .none
            }
        }
    }
    
    //MARK:- "Touch up"
    func onEnded(value: DragGesture.Value) {
        withAnimation(.easeOut) { reactionViewModel.show = false }
        if reactionViewModel.reaction != .none {
            selectedReaction = reactionViewModel.reaction
            reactionViewModel.reacted = true
        }
    }
    
    //MARK:- Set updated values to view model
   private func setReactionAndToolTipLocationX(location: Int) {
        switch location {
        case ReactionsRange.like:
            reactionViewModel.xAxisToolTip = ReactionsToolTipLocationX.like
            reactionViewModel.reaction = .like
        case ReactionsRange.celebrate:
            reactionViewModel.xAxisToolTip = ReactionsToolTipLocationX.celebrate
            reactionViewModel.reaction = .celebrate
        case ReactionsRange.haha:
            reactionViewModel.xAxisToolTip = ReactionsToolTipLocationX.haha
            reactionViewModel.reaction = .haha
        case ReactionsRange.love:
            reactionViewModel.xAxisToolTip = ReactionsToolTipLocationX.love
            reactionViewModel.reaction = .love
        case ReactionsRange.insightful:
            reactionViewModel.xAxisToolTip = ReactionsToolTipLocationX.insightful
            reactionViewModel.reaction = .insightful
        case ReactionsRange.leading, ReactionsRange.trailing:
            reactionViewModel.xAxisToolTip = ReactionsToolTipLocationX.outOfRange
            reactionViewModel.reaction = .none
        default:
            reactionViewModel.xAxisToolTip = ReactionsToolTipLocationX.outOfRange
            reactionViewModel.reaction = .none
        }
    }
}

struct ReactionToolTipView: View {
    @Binding var reactionViewModel :  ReactionViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            if reactionViewModel.xAxisToolTip != 0  {
                toolTipView(title: reactionViewModel.reaction.values.name, offsetX: reactionViewModel.xAxisToolTip, offsetY: -50)
            }
            HStack(spacing: 10) {
                ForEach(reactions, id: \.self) { reaction in
                    reaction.values.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:reactionViewModel.reaction.values.name == reaction.values.name ? 48 :  40, height:reactionViewModel.reaction.values.name == reaction.values.name ? 48 :  40)
                        .padding(reactionViewModel.reaction.values.name == reaction.values.name ? -8 :  0)
                }
            }
            .padding(.vertical,10)
            .padding(.horizontal,10)
            .background(Color.white.clipShape(Capsule()))
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: 5)
        }
    }
    
    private func toolTipView(title: String, offsetX: Int, offsetY: Int) -> some View {
        Text(title)
            .font(.subheadline)
            .foregroundColor(.white)
            .fixedSize(horizontal: true, vertical: false)
            .padding(10)
            .frame(height: 22)
            .background(Color.black.opacity(0.8).clipShape(Capsule()))
            .offset(x:CGFloat(offsetX) ,y: CGFloat(offsetY))
    }
    
}

enum Reactions: Int {
    case like = 0
    case celebrate = 1
    case haha = 2
    case love = 3
    case insightful = 4
    case none
    
    var values: (name: String, selectedName: String, image: Image, color: Color) {
        get {
            switch self {
            case .like:
                return ("Like", "Liked", Image("Like"), .purple)
            case .celebrate:
                return ("Celebrate", "Celebrated", Image("Celebrate"), .green)
            case .haha:
                return ("Haha", "Haha",Image("Haha"), .yellow)
            case .love:
                return ("Love", "Loved", Image("Love"), .red)
            case .insightful:
                return ("Insightful", "Insightful", Image("Insightful"), .blue)
            case .none:
                return ("", "", Image("Like"), .clear)
            }
        }
    }
}

enum ReactionsRange  {
    static let like = 11 ..< 60
    static let celebrate = 61 ..< 110
    static let haha = 111 ..< 160
    static let love = 161 ..< 210
    static let insightful = 210 ..< 260
    static let trailing = 261 ..< Int(UIScreen.main.bounds.width)
    static let leading = 0 ..< 11
}

enum ReactionsToolTipLocationX {
    static let like = 10
    static let celebrate = 40
    static let haha = 100
    static let love = 150
    static let insightful = 200
    static let outOfRange = 0
}


