//
//  ComplicationController.swift
//  Jaque WatchKit Extension
//
//  Created by Lelio Jorge Junior on 25/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import ClockKit
import WatchKit
/**
 
 Classe ComplicationController, responsável configurar a complication.
 
 
 # ComplicationController
 ## Exemplo de instância de ComplicationController
 + Abaixo:
 1. Essa classe não tem init.
 ---
 let complicationController = ComplicationController()
 ---
 
 
 */
class ComplicationController: NSObject, CLKComplicationDataSource {
    
    /// Imagens a serem apresentadas pelas complications.
    private let mascotImages40 = ["Morto_84","Triste_84","Normal_84","Feliz_84"]
    /// Imagens a serem apresentadas pelas complications.
    private let mascotImages44 = ["Morto_84","Triste_84","Normal_84","Feliz_84"]
    
    // MARK: - Complition Configure
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(createTemplateComplition())
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        handler(createTimelineEntry(date: Date()))
    }
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward])
        
    }
    
    // MARK: - Templete Configure
    
    /**
     Este método cria um template graph circular, esse template apresenta uum imagem que se refere ao estado do mascot.
     - parameter Void: Void
     - Returns: CLKComplicationTemplate?
     - Author: Lélio Jorge Júnior
     */
    private func createTemplateComplition() -> CLKComplicationTemplate?{
        guard let image = currentResolution() else { return nil }
        let template = CLKComplicationTemplateGraphicCircularImage()
        template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
        return template
    }
    
    /**
     Este método cria um Entry que tem o template da complition a data que ela va ser apresentada.
     - parameter Void: Void
     - Returns: CLKComplicationTimelineEntry?
     - Author: Lélio Jorge Júnior
     */
    private func createTimelineEntry(date: Date) -> CLKComplicationTimelineEntry? {
        guard let template = createTemplateComplition() else { return nil }
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
    
    /**
     Este método retorna uma imagem do estado do personagem.
     - parameter [String]: mascotImages
     - Returns: UIImage?
     - Author: Lélio Jorge Júnior
     */
    private func state(mascotImages: [String]) -> UIImage?{
        let state = stateMascot()
        return UIImage(named: mascotImages[state == 0 ? state : ((state-1)/3)+1])
    }
    
    /**
     Este método retorna a vida do mascot.
     - parameter Void: Void
     - Returns: Int
     - Author: Lélio Jorge Júnior
     */
    private func stateMascot() -> Int{
        let mascot = "mascotState"
        return UserDefaults.standard.integer(forKey: mascot)
    }
    
    
    /**
     Este método retorna a imagem de acordo com o a resolução que o usuário estiver rodando o app.
     - parameter Void: Void
     - Returns: UIImage?
     - Author: Lélio Jorge Júnior
     */
    private func currentResolution() -> UIImage? {
        let watch40mmRect = CGRect(x: 0, y: 0, width: 162, height: 197)
        let watch44mmRect = CGRect(x: 0, y: 0, width: 184, height: 224)
        let currentBounds = WKInterfaceDevice.current().screenBounds
        
        switch currentBounds {
        case watch40mmRect:
            return state(mascotImages: self.mascotImages40)
        case watch44mmRect:
            return state(mascotImages: self.mascotImages44)
        default:
            return state(mascotImages: self.mascotImages40)
        }
    }
    
    /**
     Este método atualiza o complication, ele atualiza a time line do da complication, essa função é chamada no momento que o app entra em background e quando o usuário negar a notification.
     - parameter Void: Void
     - Author: Lélio Jorge Júnior
     */
    static func updateComplication(){
        let server = CLKComplicationServer.sharedInstance()
        for complication in server.activeComplications ?? [] {
            server.reloadTimeline(for: complication)
        }
    }
}
