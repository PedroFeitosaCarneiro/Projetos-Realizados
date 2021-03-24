//
//  Animations.swift
//  Jaque WatchKit Extension
//
//  Created by Filipe Lopes on 20/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation
import SpriteKit

/**
 Classe auxiliar para armazenar as Texturas do mascote e suas animações
 */
class MascotAnimations{
    
    ///Chave para identificar se o mascote está em uma animação que não pode ser cancelada ou sobreposta.
    var isAnimating = false
    
    //Spites
    ///Array de texturas para aimação padrão do mascote
    let defaultTextures = [SKTexture(imageNamed: "Animac_Test_0"), SKTexture(imageNamed: "Animac_Test_1"), SKTexture(imageNamed: "Animac_Test_2"), SKTexture(imageNamed: "Animac_Test_3"), SKTexture(imageNamed: "Animac_Test_4"), SKTexture(imageNamed: "Animac_Test_6"), SKTexture(imageNamed: "Animac_Test_7"), SKTexture(imageNamed: "Animac_Test_6"), SKTexture(imageNamed: "Animac_Test_4"), SKTexture(imageNamed: "Animac_Test_3"), SKTexture(imageNamed: "Animac_Test_2"),  SKTexture(imageNamed: "Animac_Test_1"), SKTexture(imageNamed: "Animac_Test_0")]
    
    ///Array de texturas para aimação de feliz do mascote
    private let happyStateTextures = [
        SKTexture(imageNamed: "status_feliz_01"),
        SKTexture(imageNamed: "status_feliz_02"),
        SKTexture(imageNamed: "status_feliz_03"),
        SKTexture(imageNamed: "status_feliz_04"),
        SKTexture(imageNamed: "status_feliz_05"),
        SKTexture(imageNamed: "status_feliz_06"),
        SKTexture(imageNamed: "status_feliz_07"),
        SKTexture(imageNamed: "status_feliz_08"),
        SKTexture(imageNamed: "status_feliz_09"),
        SKTexture(imageNamed: "status_feliz_10"),
        SKTexture(imageNamed: "status_feliz_11"),
        SKTexture(imageNamed: "status_feliz_12")
    ]
    ///Array de texturas para aimação do estado "Normal" do mascote
    private let normalStateTextures = [
        SKTexture(imageNamed: "status_normal_01"),
        SKTexture(imageNamed: "status_normal_02"),
        SKTexture(imageNamed: "status_normal_03"),
        SKTexture(imageNamed: "status_normal_04"),
        SKTexture(imageNamed: "status_normal_05"),
        SKTexture(imageNamed: "status_normal_06"),
        SKTexture(imageNamed: "status_normal_07"),
        SKTexture(imageNamed: "status_normal_08"),
        SKTexture(imageNamed: "status_normal_09"),
        SKTexture(imageNamed: "status_normal_10"),
        SKTexture(imageNamed: "status_normal_11"),
        SKTexture(imageNamed: "status_normal_12"),
        SKTexture(imageNamed: "status_normal_13"),
        SKTexture(imageNamed: "status_normal_14"),
        SKTexture(imageNamed: "status_normal_15"),
        SKTexture(imageNamed: "status_normal_16"),
        SKTexture(imageNamed: "status_normal_17"),
        SKTexture(imageNamed: "status_normal_18"),
        SKTexture(imageNamed: "status_normal_19"),
    ]
    ///Array de texturas para aimação do estado "Mal" do mascote
    private let badStateTextures = [
        SKTexture(imageNamed: "status_triste_01"),
        SKTexture(imageNamed: "status_triste_02"),
        SKTexture(imageNamed: "status_triste_03"),
        SKTexture(imageNamed: "status_triste_04"),
        SKTexture(imageNamed: "status_triste_05"),
        SKTexture(imageNamed: "status_triste_06"),
        SKTexture(imageNamed: "status_triste_07"),
        SKTexture(imageNamed: "status_triste_08"),
        SKTexture(imageNamed: "status_triste_09"),
        SKTexture(imageNamed: "status_triste_10"),
        SKTexture(imageNamed: "status_triste_11"),
        SKTexture(imageNamed: "status_triste_12"),
        SKTexture(imageNamed: "status_triste_13"),
        SKTexture(imageNamed: "status_triste_14"),
        SKTexture(imageNamed: "status_triste_15"),
        SKTexture(imageNamed: "status_triste_16"),
        SKTexture(imageNamed: "status_triste_17"),
        SKTexture(imageNamed: "status_triste_18"),
        SKTexture(imageNamed: "status_triste_19"),
        SKTexture(imageNamed: "status_triste_20")
    ]
    ///Array de texturas para aimação do estado "Morto" do mascote
    private let deadStateTextures = [
        SKTexture(imageNamed: "status_morto_01"),
        SKTexture(imageNamed: "status_morto_02"),
        SKTexture(imageNamed: "status_morto_03"),
        SKTexture(imageNamed: "status_morto_04"),
    ]
    
    ///Array de texturas para o card caminhar
    private let walkingCardTextures = [
        SKTexture(imageNamed: "caminhar_01"),
        SKTexture(imageNamed: "caminhar_02"),
        SKTexture(imageNamed: "caminhar_03"),
        SKTexture(imageNamed: "caminhar_04"),
        SKTexture(imageNamed: "caminhar_05"),
        SKTexture(imageNamed: "caminhar_06"),
        SKTexture(imageNamed: "caminhar_07"),
        SKTexture(imageNamed: "caminhar_08"),
        SKTexture(imageNamed: "caminhar_09"),
        SKTexture(imageNamed: "caminhar_10"),
        SKTexture(imageNamed: "caminhar_11"),
        SKTexture(imageNamed: "caminhar_12"),
        SKTexture(imageNamed: "caminhar_13"),
        SKTexture(imageNamed: "caminhar_14")
    ]
    
    ///Array de texturas para quando o exercício n seja feito
    private let noExerciseCardTextures = [
        SKTexture(imageNamed: "nao_vou_alongar_0"),
        SKTexture(imageNamed: "nao_vou_alongar_4"),
        SKTexture(imageNamed: "nao_vou_alongar_8"),
        SKTexture(imageNamed: "nao_vou_alongar_12"),
        SKTexture(imageNamed: "nao_vou_alongar_16"),
        SKTexture(imageNamed: "nao_vou_alongar_20"),
        SKTexture(imageNamed: "nao_vou_alongar_24"),
        SKTexture(imageNamed: "nao_vou_alongar_28"),
        SKTexture(imageNamed: "nao_vou_alongar_32"),
        SKTexture(imageNamed: "nao_vou_alongar_36")
    ]
    
    ///Array de texturas para o card Alongar ombro
    private let shoulderCardTextures = [
        SKTexture(imageNamed: "alongamento_ombro_01"),
        SKTexture(imageNamed: "alongamento_ombro_02"),
        SKTexture(imageNamed: "alongamento_ombro_03"),
        SKTexture(imageNamed: "alongamento_ombro_04"),
        SKTexture(imageNamed: "alongamento_ombro_05"),
        SKTexture(imageNamed: "alongamento_ombro_06"),
        SKTexture(imageNamed: "alongamento_ombro_07"),
        SKTexture(imageNamed: "alongamento_ombro_08"),
        SKTexture(imageNamed: "alongamento_ombro_09"),
        SKTexture(imageNamed: "alongamento_ombro_10"),
        SKTexture(imageNamed: "alongamento_ombro_11"),
        SKTexture(imageNamed: "alongamento_ombro_12"),
        SKTexture(imageNamed: "alongamento_ombro_13"),
        SKTexture(imageNamed: "alongamento_ombro_14"),
        SKTexture(imageNamed: "alongamento_ombro_15"),
        SKTexture(imageNamed: "alongamento_ombro_16"),
        SKTexture(imageNamed: "alongamento_ombro_17"),
        SKTexture(imageNamed: "alongamento_ombro_18"),
        SKTexture(imageNamed: "alongamento_ombro_19"),
        SKTexture(imageNamed: "alongamento_ombro_20"),
        SKTexture(imageNamed: "alongamento_ombro_21"),
        SKTexture(imageNamed: "alongamento_ombro_22"),
        SKTexture(imageNamed: "alongamento_ombro_23"),
        SKTexture(imageNamed: "alongamento_ombro_24"),
        SKTexture(imageNamed: "alongamento_ombro_25"),
        SKTexture(imageNamed: "alongamento_ombro_26"),
        SKTexture(imageNamed: "alongamento_ombro_27")
    ]
    
    ///Array de texturas para o card alongar pescoço
    private let neckCardTextures = [
        SKTexture(imageNamed: "alongamento_pescoço_01"),
        SKTexture(imageNamed: "alongamento_pescoço_02"),
        SKTexture(imageNamed: "alongamento_pescoço_03"),
        SKTexture(imageNamed: "alongamento_pescoço_04"),
        SKTexture(imageNamed: "alongamento_pescoço_05"),
        SKTexture(imageNamed: "alongamento_pescoço_06"),
        SKTexture(imageNamed: "alongamento_pescoço_07"),
        SKTexture(imageNamed: "alongamento_pescoço_08"),
        SKTexture(imageNamed: "alongamento_pescoço_09"),
        SKTexture(imageNamed: "alongamento_pescoço_10"),
        SKTexture(imageNamed: "alongamento_pescoço_11"),
        SKTexture(imageNamed: "alongamento_pescoço_12"),
        SKTexture(imageNamed: "alongamento_pescoço_13"),
    ]
    
    ///Array de texturas para o card alongar o pulso
    private let wristCardTextures = [
        SKTexture(imageNamed: "alongamento_pulso_01"),
        SKTexture(imageNamed: "alongamento_pulso_02"),
        SKTexture(imageNamed: "alongamento_pulso_03"),
        SKTexture(imageNamed: "alongamento_pulso_04"),
        SKTexture(imageNamed: "alongamento_pulso_05"),
        SKTexture(imageNamed: "alongamento_pulso_06"),
        SKTexture(imageNamed: "alongamento_pulso_07"),
        SKTexture(imageNamed: "alongamento_pulso_08"),
        SKTexture(imageNamed: "alongamento_pulso_09"),
        SKTexture(imageNamed: "alongamento_pulso_10"),
        SKTexture(imageNamed: "alongamento_pulso_11"),
        SKTexture(imageNamed: "alongamento_pulso_12"),
        SKTexture(imageNamed: "alongamento_pulso_13"),
        SKTexture(imageNamed: "alongamento_pulso_14"),
        SKTexture(imageNamed: "alongamento_pulso_15"),
        SKTexture(imageNamed: "alongamento_pulso_16"),
        SKTexture(imageNamed: "alongamento_pulso_17"),
        SKTexture(imageNamed: "alongamento_pulso_18"),
        SKTexture(imageNamed: "alongamento_pulso_19"),
        SKTexture(imageNamed: "alongamento_pulso_20"),
        SKTexture(imageNamed: "alongamento_pulso_21"),
        SKTexture(imageNamed: "alongamento_pulso_22"),
    ]
    
    
    
    //Animações
    /**
     Função que recebe uma spriteNode e a anima com um Zoon in
     - Parameters:
     - sprite: spriteNode que será animada
     - lastSize: O tamanho final da animação.
     */
    func zoomInThenOut(sprite: SKNode, lastSize: CGSize, complition: @escaping (_ value : Bool)->()){
        self.isAnimating = true
        //Animação para dar Zoom In
        let step1 = SKAction.scale(to: 0, duration: 0.01)
        let step2 = SKAction.scale(to: CGSize(width: lastSize.width*1.2, height: lastSize.height*1.2), duration: 0.4)
        let step3 = SKAction.scale(to: CGSize(width: lastSize.width*0.8, height: lastSize.height*0.8), duration: 0.2)
        let step4 = SKAction.scale(to: CGSize(width: lastSize.width*1.1, height: lastSize.height*1.1), duration: 0.15)
        let step5 = SKAction.scale(to: CGSize(width: lastSize.width*1.05, height: lastSize.height*1.05), duration: 0.1)
        let step = SKAction.scale(to: lastSize, duration: 0.1)
        let finalStep = SKAction.scale(to: 0, duration: 0.5)
        let completionStep = SKAction.run {
            complition(true)
        }
        let remove = SKAction.run {
            sprite.removeFromParent()
        }
        
        sprite.run(SKAction.sequence([step1, step2, step3, step4, step, step5, step, SKAction.wait(forDuration: 5), finalStep, remove, completionStep]))
    }
    
    
    /**
     Função que retorna a animação de acordo com o estado do mascote
     - Parameters:
     - state: Estado em que o mascote está para retornar a animação apropriada.
     */
    func getAnimation(state: MascotState)->SKAction{
        //Switch case para verificar qual é o estado
        switch state {
        case .dead:
            return SKAction.repeatForever(SKAction.animate(with: self.deadStateTextures, timePerFrame: 0.1))
        case .bad:
            return SKAction.repeatForever(SKAction.animate(with: self.badStateTextures, timePerFrame: 0.1))
        case .normal:
            return SKAction.repeatForever(SKAction.animate(with: self.normalStateTextures, timePerFrame: 0.1))
        case .happy:
            return SKAction.repeatForever(SKAction.animate(with: self.happyStateTextures, timePerFrame: 0.1))
        }
    }
    
    /**
     Função que retorna a animação de acordo com o exercício do mascote
     - Parameters:
     - activity: Atividade que o usuário irá fazer
     */
    func getAnimationCard(activity: Activitie)->SKAction{
        
        switch activity {
        case .walking:
            return SKAction.repeatForever(SKAction.animate(with: self.walkingCardTextures, timePerFrame: 0.1))
        case .stretchingNeck:
            return SKAction.repeatForever(SKAction.animate(with: self.neckCardTextures, timePerFrame: 0.1))
        case .stretchingHand:
            return SKAction.repeatForever(SKAction.animate(with: self.wristCardTextures, timePerFrame: 0.15))
        case .stretchingArm:
            return SKAction.repeatForever(SKAction.animate(with: self.shoulderCardTextures, timePerFrame: 0.2))
        default:
            return SKAction.repeatForever(SKAction.animate(with: self.noExerciseCardTextures, timePerFrame: 0.1))
        }
    }
    
    /**
     Função que retorna a animação quando o usuário não quer fazer aividade
     */
    func getAnimationNoExercise()->SKAction{
        return SKAction.repeatForever(SKAction.animate(with: self.noExerciseCardTextures, timePerFrame: 0.1))
    }
    
    
    
        /*
        //CHANGE -> Mascot Animations
        func performAchievementsAnimationUp(scene: SKScene, source: MascotInterfaceControlle){
            let bgAchievements = SKSpriteNode(imageNamed: "bg_Achievements")
//            let bgAchievements = SKSpriteNode(imageNamed: "newBg")
            bgAchievements.name = "bg"
            bgAchievements.size = .init(width: 1, height: 1)
            bgAchievements.position = .init(x: scene.size.width/2, y: scene.size.height/2.5)
            
            let text = SKLabelNode(text: "Você andou 3800\n passos")
            text.fontName = "SF Compact Text Medium"
            text.name = "text"
            text.fontColor = .black
            text.horizontalAlignmentMode = .center
            text.position = bgAchievements.position
            text.numberOfLines = 0
            text.zPosition = 3
            text.fontSize = 11.57
            text.alpha = 0
            
            
    //        adjustLabelFontSizeToFitRect(labelNode: text, rect: scene.frame)
            
            scene.addChild(text)
            
            scene.isUserInteractionEnabled = false
            scene.addChild(bgAchievements)
            source.actvtyButton.setBackgroundImage(UIImage(named: "exit"))
            
            let aAnimate = SKAction.fadeAlpha(to: 1, duration: 0.8)
            let animateY = SKAction.scaleY(to: 130, duration: 0.4)
            let animateX = SKAction.scaleX(to: 120, duration: 0.4)
            bgAchievements.run(animateX)
            bgAchievements.run(animateY)
//            source.actvtyButton.setAlpha(0)
            text.run(aAnimate)
            source.buttonFlag = 1
            
        }
        func performAchievementsAnimationDown(scene: SKScene, source: MascotInterfaceControlle){
            let bg = scene.childNode(withName: "bg")
            let text = scene.childNode(withName: "text")
            let animate = SKAction.scale(to: 0, duration: 0.4)
            let aanimate = SKAction.fadeAlpha(to: 0, duration: 0.2)
            
            text?.run(aanimate,completion: {
                text?.removeFromParent()
            })
            bg?.run(animate, completion: {
                bg?.removeFromParent()
                scene.isUserInteractionEnabled = true
//                source.actvtyButton.setAlpha(1)
                source.actvtyButton.setBackgroundImage(UIImage(named: "heartButton"))
                source.buttonFlag = 0
            })
        }
        func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {

            // Determine the font scaling factor that should let the label text fit in the given rectangle.
            let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)/1.2

            // Change the fontSize.
            labelNode.fontSize *= scalingFactor/1.2

            // Optionally move the SKLabelNode to the center of the rectangle.
            labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
        }
        //CHANGE -> Mascot Animations
        */
    
    
    
    
}
