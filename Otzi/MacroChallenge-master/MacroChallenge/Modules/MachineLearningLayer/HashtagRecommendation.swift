//
//  HashtagRecommendation.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 20/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import CoreML


class HashtagRecommendationML {
    
    
    private var recommendationModel: SuggestionNotaMaximaModel!
//
    
    static let sharedInstance = HashtagRecommendationML()
  
    
   private init() {
        setupModel()
    }
    func setupModel(){
       let configuration = MLModelConfiguration()
        recommendationModel = try? SuggestionNotaMaximaModel(configuration: configuration)
        
        
   }
   
  
    
    func addUserLike(hashtag: HashtagSuggest,rating: Double = 5){
        let userLike = [hashtag.text : rating]
        
        
        let input = SuggestionNotaMaximaModelInput(items: userLike, k: 25, restrict_: [], exclude: [])
        
        
            guard let _ = try? recommendationModel?.prediction(input: input) else {
                debugPrint("Could not get results back!")
                return
            }
    }
    
    
    func getRecommendation(userLikes: [String:Double] = [])->[String]?{
        
        let input = SuggestionNotaMaximaModelInput(items: userLikes, k: 25, restrict_: [], exclude: [])
        
        
    
        guard let unwrappedResults = try? recommendationModel?.prediction(input: input) else {
            debugPrint("Could not get results back!")
            return nil
        }

        
        return unwrappedResults.recommendations
    }
    
}
