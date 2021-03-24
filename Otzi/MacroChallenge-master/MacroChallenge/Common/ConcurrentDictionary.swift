//
//  ThreadSafeArray.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 16/11/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation


final class ConcurrentDictionary<KeyType:Hashable,ValueType> : NSObject, ExpressibleByDictionaryLiteral {
   
    
    
    /* internal dictionary */
    private var internalDictionary : [KeyType:ValueType]
    
    /* fila para modificações usando uma barreira e permita operações de leitura simultâneas */
    private let queue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)
    
    
    var count : Int {
        var count = 0
        self.queue.sync() { () -> Void in
            count = self.internalDictionary.count
        }
        return count
    }
    
    lazy var keys: Dictionary<KeyType,ValueType>.Keys = {
        return internalDictionary.keys
    }()
    
    
    //get ou set com segurança uma cópia do valor do dicionário interno
    var dictionary : [KeyType:ValueType] {
        get {
            var dictionaryCopy : [KeyType:ValueType]?
            self.queue.sync() { () -> Void in
                dictionaryCopy = self.dictionary
            }
            return dictionaryCopy!
        }
        
        set {
            let dictionaryCopy = newValue // create a local copy on the current thread
            self.queue.async() { () -> Void in
                self.internalDictionary = dictionaryCopy
            }
        }
    }
    
    /* initialize an empty dictionary */
    override convenience init() {
        self.init( dictionary: [KeyType:ValueType]() )
    }
    
    /* permite que um dicionário simultâneo seja inicializado usando um dicionário literal da forma: [chave1: valor1, chave2: valor2, ...] */
    convenience required init(dictionaryLiteral elements: (KeyType, ValueType)...) {
        var dictionary = Dictionary<KeyType,ValueType>()
        
        for (key,value) in elements {
            dictionary[key] = value
        }
        
        self.init(dictionary: dictionary)
    }
    
    /* inicializar um dicionário simultâneo de uma cópia de um dicionário padrão */
    init( dictionary: [KeyType:ValueType] ) {
        self.internalDictionary = dictionary
    }
    
    /* fornecer acessores por subscript */
    subscript(key: KeyType) -> ValueType? {
        get {
            var value : ValueType?
            self.queue.sync() { () -> Void in
                value = self.internalDictionary[key]
            }
            return value
        }
        
        set {
            setValue(value: newValue, forKey: key)
        }
    }
    
    /* atribue o valor à chave especificada*/
    func setValue(value: ValueType?, forKey key: KeyType) {
        // need to synchronize writes for consistent modifications
        self.queue.async(flags:.barrier) {
            self.internalDictionary[key] = value
        }
    }
    
    /* remove o valor associado à chave especificada e retorna seu valor se houver*/
    func removeValue(forKey: KeyType) -> ValueType? {
        var oldValue : ValueType? = nil
        
        self.queue.async(flags:.barrier) {
            oldValue = self.internalDictionary.removeValue(forKey: forKey)
        }
        
        return oldValue
    }
    
    
    func enumerated() -> EnumeratedSequence<[KeyType : ValueType]> {
        return self.internalDictionary.enumerated()
    }
}

