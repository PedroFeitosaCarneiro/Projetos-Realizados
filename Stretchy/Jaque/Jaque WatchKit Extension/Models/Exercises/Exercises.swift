//
//  Exercises.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 15/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import WatchKit

/**
 Classe modelo que conforma com o protocolo "Exercisable" para os exercícios de mão.
 */
struct handStretching : Exercisable {
    // Variável responsável por armazenar a imagem/icone da atividade
    var image: WKImage
    // Variável responsável por armazenar a imagem/icone da atividade
    var name: String
}
/**
Classe modelo que conforma com o protocolo "Exercisable" para a caminhada
*/
struct takeAWalk : Exercisable {
    // Variável responsável por armazenar a imagem/icone da atividade
    var image: WKImage
    // Variável responsável por armazenar a imagem/icone da atividade
    var name: String
}
/**
Classe modelo que conforma com o protocolo "Exercisable" para os exercícios de braço.
*/
struct armStretching: Exercisable {
    // Variável responsável por armazenar a imagem/icone da atividade
    var image: WKImage
    // Variável responsável por armazenar a imagem/icone da atividade
    var name: String
}
/**
Classe modelo que conforma com o protocolo "Exercisable" para os exercícios de pescoço.
*/
struct neckStretching: Exercisable{
    // Variável responsável por armazenar a imagem/icone da atividade
    var image: WKImage
    // Variável responsável por armazenar a imagem/icone da atividade
    var name: String
}
