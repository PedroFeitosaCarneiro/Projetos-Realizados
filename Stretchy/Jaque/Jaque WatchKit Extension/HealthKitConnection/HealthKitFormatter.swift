//
//  HealthKit-Queries.swift
//  Jaque WatchKit Extension
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 16/06/20.
//  Copyright © 2020 Lelio Jorge Junior. All rights reserved.
//

import Foundation
import HealthKit

/**
 
 Classe responsável pela conexão com o HealthKit e formatação de dados.
 
 #HealthKitFormatter
 */
class HealthKitFormatter {
    
    /// Referência privada com a HealthStore
    private let healthStore = HKHealthStore()
    
    
    /**
     Função de coleta de dados da quantidade de passos.
     - parameters:
        - completion : Método async responsável por passar outras duas variáveis.
        - result : Dados coletados do HealthKit formatados para valores primitivos
        - type : Tipo específico dos tipos de atividades.
     */
    public func stepCountQuery(completion: @escaping (_ result : Double, _ type : AchievementsType) -> ()){
        
        let stepSample = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: Date.yesterday, end: Date.tomorrow, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepSample, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, stats, error) in
            if let stats = stats, let sum = stats.sumQuantity()?.doubleValue(for: .count()) {
                completion(sum,.walk)
            } else {
                print(error ?? "Erro")
            }
        }
        
        healthStore.execute(query)
        
    }
    
    /**
     Função de coleta de dados da quantidade de escadarias subidas.
     - parameters:
        - completion : Método async responsável por passar outras duas variáveis.
        - result : Dados coletados do HealthKit formatados para valores primitivos
        - type : Tipo específico dos tipos de atividades.
     */
    public func  flightsClimbedQuery(completion: @escaping (_ result : Double, _ type : AchievementsType) -> ()){
        
        let flightsSample = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        let predicate = HKQuery.predicateForSamples(withStart: Date.yesterday, end: Date.tomorrow, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: flightsSample, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, stats, error) in
            
            if let stats = stats, let sum = stats.sumQuantity()?.doubleValue(for: .count()){
                completion(sum*3, .flights)
            } else {
                print(error ?? "error")
            }
            
        }
        
        healthStore.execute(query)
        
        
    }
    
    /**
     Função de coleta de dados da quantidade de tempo que ficou em pé.
     - parameters:
        - completion : Método async responsável por passar outras duas variáveis.
        - result : Dados coletados do HealthKit formatados para valores primitivos
        - type : Tipo específico dos tipos de atividades.
     */
    public func  standTimeQuery(completion: @escaping (_ result : Double, _ type : AchievementsType) -> ()){
        
        let standSample = HKQuantityType.quantityType(forIdentifier: .appleStandTime)!
        let predicate = HKQuery.predicateForSamples(withStart: Date.yesterday, end: Date.tomorrow, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: standSample, quantitySamplePredicate: predicate, options: .duration) { (_, stats, error) in
            if let stats = stats, let standTime = stats.duration()?.doubleValue(for: .minute()){
                completion(standTime,.stand)
            } else {
                print(error ?? "error")
            }
        }
        
        healthStore.execute(query)
       }

}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
