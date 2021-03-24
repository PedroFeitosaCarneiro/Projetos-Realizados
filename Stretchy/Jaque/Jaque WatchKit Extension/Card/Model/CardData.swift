//
//  CardData.swift
//  Jaque WatchKit Extension
//
//  Created by Lelio Jorge Junior on 18/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation

/**
 
 Classe de Dados, reponsavel por ter os dados dos cards.
 
 
 # CardData
 ## Exemplo de instância de CardData
 Primeiro *exemplo*:
 + Abaixo:
    1. Não existe init para essa classe.
 ---
     let cardData = CardData()
 ---
 
 */
class CardData{
    /// Nome das atividades que irão para a tela dos cads como Titles.
    let activities = [NSLocalizedString("walk", comment: ""),NSLocalizedString("neckStretch", comment: ""),NSLocalizedString("handStretch", comment: ""),NSLocalizedString("armStretch", comment: "")]
    /// Chaves das imgens de cada atividade nas repectivas sequencia do self.activities.
    let keyImages = ["caminhar","alongamentoPescoco","alongamentoPulso","alongamentoBraco"]
    /// Quatidades de frames.
    let numberOfFrames = [14,26,21,26]
    /// Tempo de Animation.
    let timeOfAnimation = [1.5,2,2,2]
}
