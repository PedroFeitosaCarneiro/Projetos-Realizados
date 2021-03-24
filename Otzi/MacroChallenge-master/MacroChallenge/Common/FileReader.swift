//
//  FileReader.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 24/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation


enum FileReaderError: Error{
    case invalidFileName
    case invalidFileURL
    
    var localizedDescription: String{
        switch self {
        case .invalidFileName:
            return "Something went wrong."
        case .invalidFileURL:
        return "Something went wrong."
        }
    }
}

public protocol FileReaderble {
    func loadFileFromBundle(name: String, fileExtension: String) throws -> [String]
    func writeFile(texts: [String], fileName: String, fileExtension: String) throws
    func loadFileFromFileManeger(name: String, fileExtension: String) throws -> [String]
}
class FileReader: FileReaderble{
    
    private let bundle: Bundle
    private let cache = NSCache<NSString, AnyObject>()
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    
    /// Método para leitura de um arquivo de texto
    /// - Parameters:
    ///   - name: nome do arquivo
    ///   - fileExtension: extensão do arquivo
    /// - Throws: FileReaderError
    /// - Returns: [String] - Coleção de String
    func loadFileFromBundle(name: String, fileExtension: String) throws -> [String]{
        
        guard let path = bundle.path(forResource: name, ofType: fileExtension) else{
            throw FileReaderError.invalidFileName
        }
        
        
        if let cache = self.cache.object(forKey:path as NSString) as? [String] {
            return cache
        }
        
        
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let myStrings = data.components(separatedBy: .newlines)
            
            return myStrings
            
        } catch {
            throw FileReaderError.invalidFileURL

        }
        
    }
    
    
    /// método para escrever um file no FileManager
    /// - Parameters:
    ///   - texts: texto que irá escrever
    ///   - fileName: nome do file
    ///   - fileExtension: extensão do file
    func writeFile(texts: [String], fileName: String, fileExtension: String){
        
        let filename = getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension(fileExtension)

        
        
        let array = NSArray(array: texts)
        array.write(to: filename, atomically: true)
        
        
    }
    
    
    
    
    
    /// Método para carregar um file do FileManager
    /// - Parameters:
    ///   - name: nome do file
    ///   - fileExtension: extensão do file
    /// - Returns: um array de string
    func loadFileFromFileManeger(name: String, fileExtension: String) -> [String]{
        let fileURL = getDocumentsDirectory().appendingPathComponent(name).appendingPathExtension(fileExtension)
            let text =  NSArray(contentsOf: fileURL)
        
           return text as! [String]
    }
    
    
    
    /// Método auxiliar para pegar o diretório padrão no FileManager
    /// - Returns: URL do diretório
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
}
