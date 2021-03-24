//
//  OnboardingView.swift
//  Jaque WatchKit Extension
//
//  Created by Filipe Lopes on 28/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit
import SpriteKit
import UserNotifications
import HealthKit

/**
 Classe que apresenta a informação do Onboarding na tela
 ## Exemplo de instância de OnboardingView
 Primeiro *exemplo*:
 + Abaixo:
 1. Essa classe não tem init.
 ---
 let onboardingView = OnboardingView()
 ---
 */

class OnboardingView: WKInterfaceController{
    
    ///Label que armazena a frase do tutorial
    @IBOutlet weak var onboardingPhase: WKInterfaceLabel!
    ///Cena que aparece o mascorte animado
    @IBOutlet weak var onboardingScene: WKInterfaceSKScene!
    ///View Model do onboarding
    private let onboardigViewModel = OnboardingViewModel()
    ///Notification center to ask the permission
    var notification: UNUserNotificationCenter!
    
    private var context: Context!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let view = onboardigViewModel.getView()
        
        self.onboardingPhase.setText(view.onboardingPhrase)
        
        let scene = OnbardingScene(size: CGSize(width: 400, height: 175))
        
        self.onboardingScene.presentScene(scene)
        
        notification = UNUserNotificationCenter.current()
        notification.setNotificationCategories([LocalNotification.registerMascotCategory(), LocalNotification.registerExerciseCategory()])
        
        if let context = context as? Context{
            self.context = context
        }
    }
    override func willDisappear() {
        
        if context.page == Pages.four.rawValue{
            getNotificationAuthorization()
            askAutorizationHealth()
        }
    }
    ///Ask authorization the user to send notifications
       func getNotificationAuthorization() {
           notification.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
               // Enable or disable features based on authorization.
               if (granted){
                   LocalNotification.scheduleDefaultNotification(hour: 14, minute: 0,date: nil, notificationType: NotificationType.exercise)
                   LocalNotification.scheduleDefaultNotification(hour: 16, minute: 0,date: nil, notificationType: NotificationType.exercise)
                   LocalNotification.scheduleDefaultNotification(hour: 18, minute: 0,date: nil, notificationType: NotificationType.exercise)
               }
           }
       }
    
    private func askAutorizationHealth(){
        if HKHealthStore.isHealthDataAvailable() {
          let healthStore = HKHealthStore()
            let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)
            let flightsClimbed = HKObjectType.quantityType(forIdentifier: .flightsClimbed)
            let standTime = HKObjectType.quantityType(forIdentifier: .appleStandTime)
          let allTypes = Set([stepCount, flightsClimbed, standTime
            ])
            healthStore.requestAuthorization(toShare: nil, read: allTypes as? Set<HKObjectType>) { (result, error) in
            if let error = error {
                print(error)
              return
            } else {
                }
          }
        }
    }
}



enum Pages: Int{
    case one = 1
    case two
    case three
    case four
    case five
    case six
}
