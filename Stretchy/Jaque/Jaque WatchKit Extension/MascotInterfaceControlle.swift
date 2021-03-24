//
//  MascotInterfaceControlle.swift
//  Jaque WatchKit Extension
//
//  Created by Filipe Lopes on 17/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import SpriteKit
import WatchKit
import UserNotifications

struct Context{
    var page: Int
    var mascot: WKInterfaceController
}
/**
 Classe para interligar os elemetos do StoryBoard para o Código. Extende de WKInterfaceController
 Ela vai controlar os elementos visuais da Inteface do Mascote.
 */
class MascotInterfaceControlle: WKInterfaceController {

    
    //CHANGE MascotInterfaceController
    //0 - activity
    //1 - exit
    var buttonFlag = 0;
    @IBOutlet weak var actvtyButton: WKInterfaceButton!
    //CHANGE MascotInterfaceController
    
    
    
    
    
    
    
    
    ///SpriteKit Scene do mascote, local onde ele vai aparecer.
    @IBOutlet weak var mascotScene: WKInterfaceSKScene!
    var delegate: TapToSceneDelegate? = nil
    
    //Creating the scene, setting the delegate for gestures and presenting the scene
    let scene = MascotScene(size: CGSize(width: 136, height: 152))

    ///Usada para dar feedback de toque para o usuário
    var haptics = WKInterfaceDevice()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if UserDefaults.standard.bool(forKey: "onboarding") == false{
            UserDefaults.standard.set(9, forKey: "mascotState")
        }
        
        self.setTitle("Broto")
        self.delegate = scene as TapToSceneDelegate
        scene.backgroundColor = .clear
        self.mascotScene.presentScene(scene)
        
        /// Adiciona um observer e quando notificado a presenta a tela dos Cards.
        NotificationCenter.default.addObserver(self, selector: #selector(pushNotificationHandler(_:)) , name: NSNotification.Name(rawValue: "cardNotification"), object: nil)
        
        if UserDefaults.standard.bool(forKey: "onboarding") == false{
            var contexts = [Context]()
            for i in 0...5{
                let context = Context(page: i+1, mascot: self)
                contexts.append(context)
            }
            self.presentController(withNames: ["Onboarding","Onboarding","Onboarding","Onboarding","Onboarding","finalOnboarding"], contexts: contexts as [AnyObject])
        }
        
         
        if let contextActivie = context{
            self.chosenCard(contextActivie as! Activitie)
        }
    }
    
    override func didAppear() {
        self.scene.changeMascotStat()
        self.animateLife()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
       
    }
    
    /**
        Responsavel por chamar as controllers do Card
     - parameter notification:NSNotification
     - Author: Lélio Jorge Júnior
     */
    @objc func pushNotificationHandler(_ notification : NSNotification) {
        let cards = CardsViewModel()
        let arrayCards = cards.formattedCard()
        let identifierCards = "cards"
        WKInterfaceController.reloadRootControllers(withNamesAndContexts: [
            (identifierCards,arrayCards[0] as AnyObject),
            (identifierCards,arrayCards[1] as AnyObject),
            (identifierCards,arrayCards[2] as AnyObject),
            (identifierCards,arrayCards[3] as AnyObject)
        ])
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func tapOnScene(_ sender: Any) {
        //send a message to Scene that the scene have been touched
        self.delegate?.tap(sender, self)
        self.haptics.play(WKHapticType.click)
    }
    
    
    @IBAction func activityButton() {
        if buttonFlag == 0{
            UserDefaults.standard.set(true, forKey: "isPurposeful")
            let cards = CardsViewModel()
            let arrayCards = cards.formattedCard()
            let identifierCards = "cards"
            WKInterfaceController.reloadRootControllers(withNamesAndContexts: [
                (identifierCards,arrayCards[0] as AnyObject),
                (identifierCards,arrayCards[1] as AnyObject),
                (identifierCards,arrayCards[2] as AnyObject),
                (identifierCards,arrayCards[3] as AnyObject)
            ])
        } else {
            delegate?.tap(0, self)
        }
    }

}

/**
 Protocolo para passar os toques na tela para outra classe
 */
protocol TapToSceneDelegate {
    func tap(_ sender: Any, _ source : WKInterfaceController)}

extension MascotInterfaceControlle: CardProtocol{    
    func chosenCard(_ activitie: Activitie) {
        
        /// mudar o estado do mascote aqui. <<<<<<<<<
        switch activitie {
        case .stretchingHand:
            let handStretch = UserDefaults.standard.integer(forKey: "handStretch")
            UserDefaults.standard.set( handStretch + 1, forKey: "handStretch")
            let state = UserDefaults.standard.integer(forKey: "mascotState")
            UserDefaults.standard.set( state < 9 ? state + 1 : 9, forKey: "mascotState")
            self.scene.animateSprite(sucess: true)
        case .stretchingNeck:
            let neckStretch = UserDefaults.standard.integer(forKey: "neckStretch")
            UserDefaults.standard.set(neckStretch + 1, forKey: "neckStretch")
            let state = UserDefaults.standard.integer(forKey: "mascotState")
            UserDefaults.standard.set( state < 9 ? state + 1 : 9, forKey: "mascotState")
            self.scene.animateSprite(sucess: true)
        case .stretchingArm:
            let armStretch = UserDefaults.standard.integer(forKey: "armStretch")
            UserDefaults.standard.set( armStretch + 1 , forKey: "armStretch")
            let state = UserDefaults.standard.integer(forKey: "mascotState")
            UserDefaults.standard.set( state < 9 ? state + 1 : 9, forKey: "mascotState")
            self.scene.animateSprite(sucess: true)
        case .walking:
            let state = UserDefaults.standard.integer(forKey: "mascotState")
            UserDefaults.standard.set( state < 9 ? state + 1 : 9, forKey: "mascotState")
            self.scene.animateSprite(sucess: true)
            break
        case .noActivitie:
            if UserDefaults.standard.bool(forKey: "isPurposeful") {
                UserDefaults.standard.set(false, forKey: "isPurposeful")
                self.haptics.play(WKHapticType.failure)
                break
            }
            let state = UserDefaults.standard.integer(forKey: "mascotState")
            UserDefaults.standard.set( state > 0 ? state - 1 : 9, forKey: "mascotState")
            self.scene.animateSprite(sucess: false)
            break
        }
        self.scene.changeMascotStat()
        self.animateLife()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if UserDefaults.standard.integer(forKey: "mascotState") == 0{
                        let indentifierRestart = "restart"
                        WKInterfaceController.reloadRootControllers(withNamesAndContexts: [(name: indentifierRestart, context: self as AnyObject)])
//                WKExtension.shared().visibleInterfaceController?.presentController(withName: "restart", context: self)
            }
        }
        
    }
}

// - MARK: Animações de vida do mascote
extension MascotInterfaceControlle{
    
    func animateLife() {
        ///Estado do mascote
        let state = UserDefaults.standard.integer(forKey: "mascotState")
        
        ///Texturas que serão animadas
        var allTextures = [UIImage]()
        switch state {
        case 9...10:
        for i in 1...5{
             allTextures.append(UIImage(named: "button_heart_0\(i)")!)
        }
        case 8:
        for i in 6...9{
             allTextures.append(UIImage(named: "button_heart_0\(i)")!)
        }
        case 7:
        for i in 10...15{
             allTextures.append(UIImage(named: "button_heart_\(i)")!)
        }
        case 6:
        for i in 16...20{
             allTextures.append(UIImage(named: "button_heart_\(i)")!)
        }
        case 5:
        for i in 21...25{
             allTextures.append(UIImage(named: "button_heart_\(i)")!)
        }
        case 4:
        for i in 26...30{
             allTextures.append(UIImage(named: "button_heart_\(i)")!)
        }
        case 3:
        for i in 31...35{
             allTextures.append(UIImage(named: "button_heart_\(i)")!)
        }
        case 2:
        for i in 36...40{
             allTextures.append(UIImage(named: "button_heart_\(i)")!)
        }
        case 1:
        for i in 41...45{
             allTextures.append(UIImage(named: "button_heart_\(i)")!)
        }
        default:
            break
        }
        
         ///Texturas que serao animadas
        var animation = allTextures
        
        for item in allTextures.reversed(){
            animation.append(item)
        }
        
        actvtyButton.setBackgroundImage(UIImage.animatedImage(with: animation, duration: 1.5))
        
    }
    
}
