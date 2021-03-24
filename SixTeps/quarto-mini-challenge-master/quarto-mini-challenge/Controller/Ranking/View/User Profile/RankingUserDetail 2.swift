//
//  RankingUserDetail.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import SwiftUI

struct RankingUserDetail: View{
    var user: UserStandard
    var body: some View{
        ZStack{
                SquaredImage(image: user.image)
                    .offset(y: -130)
                    .padding(.bottom, -130)
                
                VStack(alignment: .leading){
                    Text(user.username)
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .foregroundColor(.black)
                }                
        }
        .background(SwiftUI.Color.yellow.edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RankingUserDetail(user: UserList().users[0])
    }
}
