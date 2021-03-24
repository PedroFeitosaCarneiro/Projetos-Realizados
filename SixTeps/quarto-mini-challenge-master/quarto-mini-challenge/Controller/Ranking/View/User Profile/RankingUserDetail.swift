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
    var row: Int
    
    
    init (user: UserStandard,row: Int) {
        self.user = user
        self.row = row + 1
        
    }
    
    
    var body: some View{
        
        ZStack{
            VStack{
                HStack{
                    VStack{
                        BiggerSquaredImage(image: user.image).overlay(RoundedRectangle(cornerRadius:30).stroke(Color.white,lineWidth: 4)
                        ).shadow(color: Color.init(red: 33/255, green: 78/255, blue: 124/255, opacity: 1), radius: 3, x: 0, y: 3)
                        
                        Text(user.username)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width:100)
                        .lineLimit(2)
                        
                            
                    }.offset(x:20,y:-30)
                    Text("#\(row)")
                        .font(.system(size: 46))
                        .fontWeight(.heavy)
                        .offset(x: 85,y:-40)
                        .foregroundColor(.white)
                    .fixedSize()
                    
                }.offset(x: -80, y: -10)
                
                HStack{
                    VStack{
                        Image("division_\(user.division)")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 50.0, height: 50.0)
                            .fixedSize()
                            .offset(y: 20)
                        
                        Text(NSLocalizedString("Division", comment: ""))
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .offset(x: 0,y: 15)
                            .fixedSize()
                    }.offset(x: -30, y: -52)
                    VStack{
                        Text("\(user.tasksPerformed)")
                            .font(.system(size: 36))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .frame(width:75)
                            .fixedSize()
                        
                        Text(NSLocalizedString("Tasks", comment: ""))
                            .font(Font.system(size: 20))
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .lineLimit(nil)
                            .frame(width: 80)
                    }.offset(x: 0, y: -29)
                    
                    VStack{
                        Text("\(user.level)")
                            
                            .font(.system(size: 36))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .fixedSize()
                        
                        
                        Text(NSLocalizedString("Level", comment: ""))
                            .font(Font.system(size: 20))
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .frame(width: 60)
                    }.offset(x: 30, y: -29)
                    
                    
                    
                }
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray).frame(width: 369, height: 200).offset(x: 0, y: 150)).offset(x: 0, y: -5)
                .overlay(RoundedRectangle(cornerRadius: 0).fill(Color.white).frame(width: 368, height: 180).offset(x: 0, y: 135)).offset(x: 0, y: -10)
                
                
                VStack{
//                      StrokeText(text: "Achievements",width: 0.5,color: .gray)
                    Text(NSLocalizedString("Achievements", comment: ""))
                        .font(.system(size: 20))
                        .fontWeight(.heavy)
                        .offset(x: -8)
                        .foregroundColor(Color.init(red: 120/255, green: 120/255, blue: 130/255))
                    HStack{
                        Spacer().frame(width:110)
                        RoundedRectangle(cornerRadius: 20).fill(Color.init(red: 230/255, green: 230/255, blue: 230/255)).frame(width: 90, height: 100).shadow(color: Color(.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 0.5)), radius: 3, x: 0, y: 8).overlay(Image("lockerIphoneX"))
                        RoundedRectangle(cornerRadius: 20).fill(Color.init(red: 230/255, green: 230/255, blue: 230/255)).frame(width: 90, height: 100).shadow(color: Color(.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 0.5)), radius: 3, x: 0, y: 8).overlay(Image("lockerIphoneX"))
                        RoundedRectangle(cornerRadius: 20).fill(Color.init(red: 230/255, green: 230/255, blue: 230/255)).frame(width: 90, height: 100).shadow(color: Color(.init(red: 160/255, green: 160/255, blue: 160/255, alpha: 0.5)), radius: 3, x: 0, y: 8).overlay(Image("lockerIphoneX"))
                    }
                    
                }.frame(width: 369)
                .offset(x: -67, y: 0)
            }
        }.frame(height:540)
        .background(user.backgroundImage).cornerRadius(30)
    
     //   .frame(width: 100, height: 100, alignment: .center)
        
        // .overlay(RoundedRectangle(cornerRadius: 0).fill(Color.white).frame(width: 369, height: 130).offset(x: 0, y: 188))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RankingUserDetail(user: UserList().usersTest[0],row: 1).previewLayout(.fixed(width: 369, height: 501))
    }
}

