//
//  CloudManager.swift
//  quarto-mini-challenge
//
//  Created by Bernardo Nunes on 28/04/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//
import Foundation
import CloudKit

/// Classe com métodos genêricos CRUD para CloudKit
class CloudManager {
    
    static let shared = CloudManager()
    private let database = CKContainer(identifier: "iCloud.com.panterimar.quarto-mini-challenge").publicCloudDatabase
    
    private init() {}
    
    /// Método que cria CKModifyRecordsOperation a partir de container padrao
    /// - Parameters:
    ///   - savePolicy: savepolicy da operacao
    ///   - perRecordCompletion: completion que será executado após cada record
    ///   - finalCompletion: completion final após final da operação
    private func setOP(savePolicy: CKModifyRecordsOperation.RecordSavePolicy, perRecordCompletion: @escaping ((CKRecord, Error?) -> Void), finalCompletion: @escaping (() -> Void)) -> CKModifyRecordsOperation {
        let operation = CKModifyRecordsOperation()
        operation.savePolicy = savePolicy
        
        operation.perRecordCompletionBlock = {(record, error) in
            perRecordCompletion(record, error)
        }
        
        operation.completionBlock = {
            finalCompletion()
        }
        
        return operation
    }
    
    /// Método que cria records para salvar
    /// - Parameters:
    ///   - records: Array de ckrecords para serem salvos
    ///   - perRecordCompletion: completion que será executado após cada record
    ///   - finalCompletion: completion final após final da operação
    func createRecords(records: [CKRecord], perRecordCompletion: @escaping ((CKRecord, Error?) -> Void), finalCompletion: @escaping (() -> Void)){
        let saveOp = setOP(savePolicy: .allKeys, perRecordCompletion: perRecordCompletion, finalCompletion: finalCompletion)
        saveOp.recordsToSave = records

        database.add(saveOp)
    }
    
    /// Método que faz update nos records
    /// - Parameters:
    ///   - records: Array de ckrecords para serem alterados
    ///   - perRecordCompletion: completion que será executado após cada record
    ///   - finalCompletion: completion final após final da operação
    func updateRecords(records: [CKRecord], perRecordCompletion: @escaping ((CKRecord, Error?) -> Void), finalCompletion: @escaping (() -> Void)){
        let updateOp = setOP(savePolicy: .changedKeys, perRecordCompletion: perRecordCompletion, finalCompletion: finalCompletion)
        updateOp.recordsToSave = records
        
        database.add(updateOp)
    }
    
    /// Método que deleta records do cloudkit
    /// - Parameters:
    ///   - recordIDs: array de record ids para serem deletados
    ///   - perRecordCompletion: completion que será executado após cada record
    ///   - finalCompletion: completion final após final da operação
    func deleteRecords(recordIDs: [CKRecord.ID], perRecordCompletion: @escaping ((CKRecord, Error?) -> Void), finalCompletion: @escaping (() -> Void)){
        let deleteOp = setOP(savePolicy: .changedKeys, perRecordCompletion: perRecordCompletion, finalCompletion: finalCompletion)
        deleteOp.recordIDsToDelete = recordIDs
        
        database.add(deleteOp)
    }
    
    /// Método que faz query para consultar records
    /// - Parameters:
    ///   - recorType: string com nome da tabela a ser consultada
    ///   - predicate: predicate da consulta
    ///   - perRecordCompletion: completion que será executado após cada record
    ///   - finalCompletion: completion final após final da operação
    ///   - desiredKeys: Array de strings contendo o nome das chaves desejadas na pesquisa (caso queira todas as chaves passe o array como nil
    func readRecords(recorType: String, predicate: NSPredicate, desiredKeys: [String]?, perRecordCompletion: @escaping ((_ record : CKRecord) -> Void), finalCompletion: @escaping (() -> Void)){
        
        let query = CKQuery(recordType: recorType, predicate: predicate)
        let queryOp = CKQueryOperation(query: query)
        
        if let keys = desiredKeys, keys.count>0{
            queryOp.desiredKeys = keys
        }
        
        queryOp.queryCompletionBlock = { (_, error) in
            print(error ?? "Sem erro")
        }
        
        queryOp.recordFetchedBlock = { (record) in
            perRecordCompletion(record)
        }

        queryOp.completionBlock = {
            finalCompletion()
        }
        
        database.add(queryOp)
    }
    
    /// Método que faz fetch de record direto pelo record id
    /// - Parameters:
    ///   - recordIDs: array de record ids para serem buscadas
    ///   - finalCompletion: completion para tratar os resultados da busca
    ///   - desiredKeys: Array de strings contendo o nome das chaves desejadas na pesquisa (caso queira todas as chaves passe o array como nil
    func fetchRecords(recordIDs: [CKRecord.ID], desiredKeys: [String]?, finalCompletion: @escaping (([CKRecord.ID : CKRecord]?, Error?) -> Void)) {
        
        let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
        
        if let keys = desiredKeys, keys.count > 0 {
            operation.desiredKeys = keys
        }
        
        operation.fetchRecordsCompletionBlock = { (records, error) in
            finalCompletion(records, error)
        }
        
        database.add(operation)
    }
    
    //MARK: - MÉTODOS PARA AUXILIAR DESENVOLVIMENTO
    
    /// Método para auxiliar para deletar todos os records de uma tabela
    /// - Parameter type: Nome da tabela para ser esvaziada
    func deleteALLRecords(type: String) {
        let predicate = NSPredicate(value: true)
        var recordIDs = [CKRecord.ID]()
        
        self.readRecords(recorType: type, predicate: predicate, desiredKeys: ["recordID"], perRecordCompletion: { (record) in
            recordIDs.append(record.recordID)
        
        }, finalCompletion: {
            print(recordIDs.count)
            let deleteOp = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: recordIDs)
            deleteOp.database = self.database
            deleteOp.savePolicy = .allKeys
            deleteOp.modifyRecordsCompletionBlock = { (recordsss, deleted, error) in
                print("===> \(String(describing: deleted?.count))")
                
                if let error = error {
                    print(error)
                    return
                }
                
            }
            
            OperationQueue().addOperation(deleteOp)
        })
    }
}
