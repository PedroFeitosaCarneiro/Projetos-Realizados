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
    var needAppearance: Double = 0
    
    mutating func setAppearance(){        
        if (user.id == UserDefaultLogic().userId){
            self.needAppearance = 1
            print("ITS A MATCH")
        }
    }
    
    init(user: UserStandard,rowNumber: Int,needAppearance: Int){
        
        self.user = user
        self.rowNumber = rowNumber
        setAppearance()
        // VERMELHO BERNS
    }
    
    
    var body: some View {
       
        HStack{
            Spacer()
            Text("\(rowNumber + 1)")
                .font(.system(size: 26))
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .offset(y: -30)
                .frame(width: 20)
            VStack{
                SquaredImage(image: user.image)
                    .aspectRatio(contentMode: .fit)
                    .offset(x:0,y:5.5)
                    .fixedSize()
                Text(user.username)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .offset(x: 0,y:-4)
                    .frame(width: 80,height:30)
                
            }
            Spacer().frame(width: 30.1)
            VStack(alignment: .center,spacing: 0) {
                // Arrumar nomeação de acordo com os assets                
                Image("division_\(user.division)")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .fixedSize()
                    .offset(y:5)
                HStack(spacing: 0){
                    Text(NSLocalizedString("Division", comment: ""))
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .offset(x: 0,y: 10)
                        .fixedSize()
                    
                }
            }
            Spacer().frame(width: 32.9)
            VStack{
                Text("\(user.tasksPerformed)")
                    .font(.system(size: 23))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .frame(width:50)
                    .fixedSize()
                    .offset(y:12)
                Text(NSLocalizedString("Tasks", comment: ""))
                    .font(Font.system(size: 13))
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .frame(width: 45)
                    .offset(x: 0,y: 20)
            }
            Spacer().frame(width: 32.9)
            VStack{
                Text("\(user.level)")
                    .font(.system(size: 23))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .fixedSize()
                    .offset(y:12)
                
                Text(NSLocalizedString("Level", comment: ""))
                    .font(Font.system(size: 13))
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .offset(x: 0,y: 20)
                .fixedSize()
            }
            Spacer().frame(width:12)
        }.frame(width: 350, height: 116, alignment: .center)
            
            //.background(Color.init(red: 79/255, green: 123/255, blue: 168/255))
            
            // FUNDO DO PERSONAGEM SELECIONADO BERNS
            .background(RoundedRectangle(cornerRadius: 0).fill(Color(UIColor(named: "SetRow")!)).opacity(needAppearance).frame(width:UIScreen.main.bounds.width,height: 130)
                .overlay((RoundedRectangle(cornerRadius: 40) // VVVVV  BERNS  FUndo azul da celula
                    .fill(Color(UIColor(named: "RankingRow")!))).frame(width: 350,height:116)))
//            .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.gray, lineWidth: 2).frame(width: 350, height: 116, alignment: .center))
    }
}

struct RankingViewRow_Previews: PreviewProvider {
    static var previews: some View {
        // Change usersTest to users
        RankingViewRow(user: UserList().usersTest[0],rowNumber: 0, needAppearance: 1)
            .previewLayout(.fixed(width: 388, height: 116))
    }
}
