//
//  Protocols.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit


/// Protocolo responsável por representar a view e se conectar com o presenter
protocol SearchViewToPresenter {
    var presenter : SearchPresenterToView? {get set}
}

/// Protocolo responsável por representar o Presenter e se conectar com a view
protocol SearchPresenterToView {
    
    var view : SearchViewToPresenter? {get set}
    var router : SearchRouterToPresenter? {get set}
    
    /// Método responsável por passar os dados da View para o Presenter
    /// - Parameters:
    ///   - value: Valor escolhido na view, referente a tatuagem
    ///   - view: Referencia da ViewController
    func dataSentToPresenter(value: String, from view: UIViewController)
    
    /// Método responsável por chamar o router para passar de View.
    /// - Parameter from: Referência da ViewController
    func callRouterToSearchView(from: UIViewController)
    
    func getRecentTags(completion: @escaping (_: [String]) -> ())
    
    func saveHashtagIntoDataBase(with hashtag: String)
    
    func deleteHashtagFromDataBase(with hashtag: String)
    
    
}

/// Protocolo responsável por representar o presenter e conectar com o interactor
protocol SearchPresenterToInteractor : class {
    var interactor : SearchInteractorToPresenter? {get set}
}

/// Protocolo responsável por representar o interactor e conectar com o presenter
protocol SearchInteractorToPresenter : class {
    var presenter : SearchPresenterToInteractor? {get set}
    
    
    /// Método responsável por formatar a entrada de String para HashtagSuggest
    /// - Parameter hashtag: Nome da hashtag
    func formatHashtagTattoo(hashtag: String) -> HashtagSuggest
    
    func getRecentSearch( completion: @escaping (_:  [String]) -> Void)
    
    
    func saveRecentSearch(with hashtag: String)
    
    func deleteRecentHashtag(with hashtag: String)
    
    
}

/// Protocolo responsável por representar o router
protocol SearchRouterToPresenter : class {
    
    /// Método responsável por criar o módulo Search
    func createSearchModule() -> UIViewController
    
    /// Método responsável por mandar os dados para o FeedView e instanciar o novo Módulo
    /// - Parameters:
    ///   - value: Hashtag Selecionada
    ///   - view: Referência da ViewController
    func pushToView(value: HashtagSuggest, from view: UIViewController)
    
    /// Método responsável por passar de view, para a View principal do SearchView
    /// - Parameters:
    ///   - Reference: A referência do presenter
    ///   - from: A referência da ViewController na qual estava
    func moveToSearchView(with Reference: SearchPresenterToView & SearchPresenterToInteractor, from: UIViewController)
}

/// Protocolo responsável por lidar com os eventos de toques.
protocol HandleTapEvent : class{
    
    /// Método responsável por capturar o toque do usuário
    /// - Parameter value: Valor, referente a célula na qual o usuário tocou
    func userDidTapOn(_ value: String)
}
