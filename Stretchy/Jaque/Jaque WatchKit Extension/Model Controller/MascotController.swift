//
//  MascotController.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 15/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit
import SpriteKit
/**
 Classe que irá controlar o mascote.
 */
class MascotController {
    
    ///Mascote que será controlado
    private let mascot : Mascot
    
    ///Classe auxiliar para armazenar as Texturas do mascote e suas animações
    private let mascotAnimatios = MascotAnimations()
    
    ///Controlador de conquistas do usuário
    private let achievimentsController = AchievementsController()
    
    ///Classe auxiliar que armazena as texturas e animações do mascote
    let mascotAnimations = MascotAnimations()
    
    //Construtor do Mascote controller
    init(mascot: Mascot) {
        self.mascot = mascot
    }
    
    /**
     Cria as primeiras configuações do mascote em cena
    - Parameters:
     - scene: a cena em que o mascote será inserido
     */
    func setupOnScene(scene: SKScene){
        //colocando o mascote na cena
        scene.addChild(self.mascot.spriteNode)
        // Colocando o mascote no meio da cena
        self.mascot.spriteNode.xScale = 1.15
        self.mascot.spriteNode.yScale = 1.15
//        self.mascot.spriteNode.position = CGPoint(x: scene.size.width/1.77, y: scene.size.height/2.1)
        self.mascot.spriteNode.position = .init(x: scene.size.width/2, y: scene.size.height/2.2)
        
        //Colocando o mascote em loop com a animação
//        self.mascot.spriteNode.run(SKAction.repeatForever(SKAction.animate(with: self.mascotAnimatios.defaultTextures, timePerFrame: 0.15)))
        
        self.changeMascotStatebyUD()
    }
    
    /**
     Função que muda o estado do mascote, seu estado é mudado se baseando no fato de o usuário fez ou não o exercício
     */
    func changeMascotStatebyUD(){
        let state = UserDefaults.standard.integer(forKey: "mascotState")
        self.mascot.behaviorNumber =  state
        
        switch self.mascot.behaviorNumber {
        case 0:
            self.mascot.behave = .dead
        case 1...3:
            self.mascot.behave = .bad
        case 4...6:
            self.mascot.behave = .normal
        case 7...9:
            self.mascot.behave = .happy
        default:
            self.mascot.behave = .happy
        }
        self.mascot.spriteNode.run(self.mascotAnimatios.getAnimation(state: self.mascot.behave))
    }
    
    /**
   Função cria uma caixa de texto com a curiosidade recebida e coloca na tela de forma animada.
    - Parameters:
    - scene: Cena a qual será inserida a curiosidade
    - curiosity: Texto que será inserido na caixa de texto
    */
    private func sendCuriosity(scene: SKScene, curiosity: String){
        let boxSize = CGSize(width: scene.size.width*0.8, height: scene.size.height*0.8)
        let box = SKSpriteNode(color: .white, size: CGSize(width: 1, height: 1))
        let text = SKLabelNode(text: curiosity)
        
        box.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
        text.position = CGPoint(x: scene.size.width/2, y: scene.size.height*0.35)
        text.fontSize = 60
        text.fontColor = .black
        text.zPosition = 2
        
        text.lineBreakMode = .byWordWrapping
        text.numberOfLines = 0
        text.preferredMaxLayoutWidth = boxSize.width*0.8
        
        //adiciona os dois na tela
        scene.addChild(box)
        scene.addChild(text)
        
        //Chama a animação e depois garante de colocar o estado de animação do mascote como falso
        self.handleAnimations(textNode: text, boxNode: box, finalSize: boxSize){ (value) in
            self.mascotAnimations.isAnimating = false
        }
    }
    
    /**
    Função que executará uma complition para saber quando as animações acabarem.
    - Parameters:
    - scene: Cena em que aparecerá a notificação
    */
    private func handleAnimations(textNode: SKNode, boxNode: SKNode, finalSize: CGSize, complition: @escaping (_ value : Bool)->()){
        //Executa  animação de ZoomIn, espera e ZoomOut
        mascotAnimations.zoomInThenOut(sprite: boxNode, lastSize: finalSize) { (_) in
        }
        mascotAnimations.zoomInThenOut(sprite: textNode, lastSize: finalSize) { (_) in
            complition(true)
        }
    }
    
    /**
     Função que vai chamar alguma conquista para exibir, e só mostrará se não estiver outra animação ocorrendo
     - Parameters:
     - scene: Cena em que aparecerá a notificação
     */
    func handleAchievements(scene: SKScene){
        //Checa se exite alguma conquista
        if let achievement = self.achievimentsController.getAchievement(){
            //Checa se o mascote está em alguma animação
            if self.mascotAnimations.isAnimating == false{
                mascotAnimations.isAnimating = true
                self.sendCuriosity(scene: scene, curiosity: achievement.message)
            }
        }
    }
    
    
    func retrieveAchievements() -> String{
         let achievement = self.achievimentsController.getAchievement()
        return achievement?.message ?? "nil"
    }
    
}

