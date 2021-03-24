//
//  MascotScene.swift
//  Jaque WatchKit Extension
//
//  Created by Filipe Lopes on 17/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//


import SpriteKit
import Combine
import WatchKit

/**
 Cena que irá apresentar o mascote. (SKScene)
 */
class MascotScene: SKScene {
    
    //Iniciando o controlador do mascote
    var sprite = SKSpriteNode(texture: SKTexture(imageNamed: "coracaoRed"))
    ///Usada para dar feedback de toque para o usuário
    var haptics = WKInterfaceDevice()
    let mascotController = MascotController(mascot: Mascot(sprite: SKSpriteNode(imageNamed: "triste")))
    var buttonArea : CGRect!
    var button : SKShapeNode!
    override func sceneDidLoad() {
        //Inicializando o mascote na cena
        self.mascotController.setupOnScene(scene: self)
        sprite.position = CGPoint(x: self.size.width / 1.2, y: self.size.height / 1.5)
        sprite.size = CGSize(width: 30, height: 20)
        sprite.zPosition = 50
        sprite.alpha = 0
        self.addChild(sprite)
    }
    
    /**
     Funcao que anima o sprite de coração na tela
     - Parameters:
        - sucess: Valor booleano que indica se o usuário aceitou a atividade ou não
     */
    func animateSprite(sucess: Bool) {
        if sucess{
            self.sprite.texture = SKTexture(imageNamed: "coracaoRed")
            self.sprite.run(.sequence([.moveTo(y: self.size.height / 4, duration: 0),.fadeIn(withDuration: 0),.moveTo(y: self.size.height / 1.5, duration: 0.5),.fadeOut(withDuration: 0.5)]))
            self.haptics.play(WKHapticType.success)
        }else{
            self.sprite.texture = SKTexture(imageNamed: "coracaoGray")
            self.sprite.run(.sequence([.moveTo(y: self.size.height / 1.5, duration: 0),.fadeIn(withDuration: 0),.moveTo(y: self.size.height / 4, duration: 0.5),.fadeOut(withDuration: 0.5)]))
            self.haptics.play(WKHapticType.failure)
        }
    }
    
    func changeMascotStat(){
        self.mascotController.changeMascotStatebyUD()
    }
    
}

/**
 Delegate para receber o toque da Interface para essa cena
 */
extension MascotScene: TapToSceneDelegate {
    //Função que passará um tap em qualquer lugar da cena
    func tap(_ sender: Any, _ source : WKInterfaceController) {
//            self.mascotController.handleAchievements(scene: self)
        source.presentController(withName: "Achievements", context: self.mascotController)
        
        if (source as! MascotInterfaceControlle).buttonFlag == 1 {
            
            //self.mascotController.mascotAnimations.performAchievementsAnimationDown(scene: self, source: source as! MascotInterfaceControlle)
        } else {
            
            //self.mascotController.mascotAnimations.performAchievementsAnimationUp(scene: self, source: source as! MascotInterfaceControlle)
        }
        
    }
}
