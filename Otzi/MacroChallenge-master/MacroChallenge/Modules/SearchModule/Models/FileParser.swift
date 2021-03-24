//
//  FileParser.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 23/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation

class FileParser {
    
    
    static func parseFileWithPath(_ path: String, ofType: String) -> [String]{
        var array : [String] = []
        if  let path = Bundle.main.path(forResource: path, ofType: ofType){
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let dataEncoded = String(data: data, encoding: .utf8)
                
                if  let dataArr = dataEncoded?.components(separatedBy: "\n"){
                    for line in dataArr{
                        array.append(line)
                    }
                }
                
            }
            catch let jsonErr {
                print("\n Error read CSV file: \n ", jsonErr)
            }
        }
        
        return array
        
    }
    
    
    
    
    
}
