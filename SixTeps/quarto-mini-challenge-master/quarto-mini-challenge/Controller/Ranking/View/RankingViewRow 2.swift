//
//  RankingViewRow.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import SwiftUI

struct RankingViewRow: View {
    var user: UserStandard
    var rowNumber: Int
    
    var body: some View {
        HStack{
            Text("\(rowNumber + 1)")
                .font(.custom("SFProText-Heavy", size: 26))
                .foregroundColor(.white)
                .offset(y: -30)
            VStack{
                SquaredImage(image: user.image)
                
                Text(user.username)
                    .font(.custom("SFProText-Regular", size: 13))
                    .foregroundColor(.white)
                    .offset(y:-3)
                    
            }
            Spacer().frame(width: 20.1)
            
            VStack(alignment: .center,spacing: 0) {
                Image("platina")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                HStack(spacing: 0){
                    Text("Division")
                        .font(.custom("SFProText-Regular", size: 13))
                        .foregroundColor(.white)
                        .frame(width: 50)
                        .offset(y: 10)
                }
            }
            
            Spacer().frame(width: 32.9)
            
            VStack{
                Text("\(user.tasksPerformed)")
                    .font(.custom("SFProText-Heavy", size: 26))
                    .foregroundColor(.white)
                Text("Tasks")
                    .foregroundColor(.white)
                    .font(.custom("SFProText-Regular", size: 13))
                    .foregroundColor(.white)
                    .frame(width: 35)
                    .offset(y: 20)
            }
            
            Spacer().frame(width: 32.9)
            VStack{
                Text("\(user.level)")
                    .font(.custom("SFProText-Heavy", size: 26))
                    .foregroundColor(.white)
                Text("Level")
                    .font(.custom("SFProText-Regular", size: 13))
                    .foregroundColor(.white)
                    .offset(y: 20)
            }
            
            
            
        }.frame(width: 350, height: 116, alignment: .center)
            //.background(Color.init(red: 79/255, green: 123/255, blue: 168/255))
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.gray, lineWidth: 0).frame(width: 388, height: 116, alignment: .center)
        ).background(RoundedRectangle(cornerRadius: 40).fill(Color.init(red: 79/255, green: 123/255, blue: 168/255)))
    }
    
    
}

struct RankingViewRow_Previews: PreviewProvider {
    static var previews: some View {
        // Change usersTest to users
        RankingViewRow(user: UserList().usersTest[1],rowNumber: 0)
            .previewLayout(.fixed(width: 388, height: 116))
    }
}
