//
//  RankingView.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//
import UIKit
import SwiftUI

struct RankingView: View, SendCloudRecordsDelegate {
    
    // Variables instances
    var addNavItem: (() -> Void)?
    
    private var getRow = true
    @State var canClick = true
    @State var showingPopupA = false
        
    var manager: UserManager?
    var coreWorker: CoreDataWorker?
    @ObservedObject var UsersList = UserList()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    //Assignment
    let backgroundColor = Color.init(red: 250/255, green: 250/255, blue: 250/255)
    
    init(){        
        manager = UserManager()
        coreWorker = CoreDataWorker()
        User().updateUserCK {}
        // coreWorker?.fetchUserID()
        let _ = RankingOperator(view: self)
        UINavigationController().navigationController?.setToolbarHidden(true, animated: false)
        // Nav bar appearance
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.init(red: 79/255, green: 123/255, blue: 168/255,alpha: 1)]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.init(red: 79/255, green: 123/255, blue: 168/255,alpha:1)]
        UINavigationBar.appearance().backgroundColor = UIColor(named: "BackgroundWhite")
        
        // Table view appearance
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor(named: "BackgroundWhite")
        UITableViewCell.appearance().backgroundColor = UIColor(named: "BackgroundWhite")
    }
    
    
    
    var body: some View {
        VStack{
        NavigationView{
            VStack{                
                // Change usersTest = users
                List(UsersList.users){ value in
                    Button(action: {self.showingPopupA.toggle() }){
                        RankingViewRow(user: value,rowNumber: self.UsersList.users.firstIndex(where: {$0.id == value.id})!,needAppearance: 0).frame(width: 380, height: 116).background(Color(UIColor(named: "BackgroundWhite")!))
                        // PRETO                                                BERNS                ˆˆˆˆ
                    }.sheet(isPresented: self.$showingPopupA){ RankingUserDetail(user: value,row: self.UsersList.users.firstIndex(where: {$0.id == value.id})!) }
                    
                }.navigationBarTitle("Aloo")
                .navigationBarHidden(true)
                    
         
            }
        }
            
        }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.8)
        .offset(x: 0, y: 20)
        .environment(\.defaultMinListRowHeight, 140)
            // VERDE BERNS
            .background(Color(UIColor(named: "BackgroundWhite")!))
    }
    
    func operateValues(users: [String], level: [Int],tasks: [Int],id: [String], pictures: [Image], backgroundPhotos: [Image],divisions: [Int]) {
        guard let manager = manager else {return}
        let usersFormatted = manager.transformDataIntoUserStandard(users: users, level: level,tasks: tasks,id: id,pictures: pictures, backgroundPhotos: backgroundPhotos, divisions: divisions)
        let usersManaged = manager.execOrderAndValueSwitch(users: usersFormatted)
        
        addToUserList(users: usersManaged)
    }
    
    func addToUserList(users: [UserStandard]){
        for user in users{
            UsersList.usersTop.append(user)
        }
        // Assignment for first appear
        UsersList.users = UsersList.usersTop
    }
    
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
    }
}
