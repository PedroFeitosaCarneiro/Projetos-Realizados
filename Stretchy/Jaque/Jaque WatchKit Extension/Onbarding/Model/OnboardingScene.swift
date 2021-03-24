//
//  OnboardingScene.swift
//  Jaque WatchKit Extension
//
//  Created by Filipe Lopes on 28/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation
import SpriteKit

class OnbardingScene : SKScene{
    override func sceneDidLoad() {
        //super.sceneDidLoad()
        
        let littleJaque = SKSpriteNode(imageNamed: "Onboarding_01")
        
        let animationTextures = [
            SKTexture(imageNamed: "Onboarding_01"),
            SKTexture(imageNamed: "Onboarding_02"),
            SKTexture(imageNamed: "Onboarding_03"),
            SKTexture(imageNamed: "Onboarding_04"),
            SKTexture(imageNamed: "Onboarding_05"),
            SKTexture(imageNamed: "Onboarding_06"),
            SKTexture(imageNamed: "Onboarding_07"),
            SKTexture(imageNamed: "Onboarding_08"),
            SKTexture(imageNamed: "Onboarding_09"),
            SKTexture(imageNamed: "Onboarding_10"),
            SKTexture(imageNamed: "Onboarding_11"),
            SKTexture(imageNamed: "Onboarding_12"),
            SKTexture(imageNamed: "Onboarding_13"),
            SKTexture(imageNamed: "Onboarding_14"),
            SKTexture(imageNamed: "Onboarding_15"),
            SKTexture(imageNamed: "Onboarding_16"),
            SKTexture(imageNamed: "Onboarding_17"),
        ]
        self.backgroundColor = .clear
        self.addChild(littleJaque)
        
        littleJaque.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.63)
        littleJaque.run(SKAction.repeatForever(SKAction.animate(with: animationTextures, timePerFrame: 0.1)))
        
    }
}
