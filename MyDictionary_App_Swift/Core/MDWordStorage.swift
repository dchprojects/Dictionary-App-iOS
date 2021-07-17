//
//  MDWordStorage.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 21.05.2021.
//

import Foundation

protocol MDWordStorageProtocol {
    func wordsCount(storageType: MDWordStorageType, _ completionHandler: @escaping (MDWordsCountResult))
    func createWord(_ wordModel: WordModel, storageType: MDWordStorageType, _ completionHandler: @escaping(MDCreateWordResult))
    func readWord(fromID id: Int64, storageType: MDWordStorageType, _ completionHandler: @escaping(MDReadWordResult))
    func updateWord(byID id: Int64, word: String, wordDescription: String, storageType: MDWordStorageType, _ completionHandler: @escaping(MDUpdateWordResult))
    func deleteWord(_ word: WordModel, storageType: MDWordStorageType, _ completionHandler: @escaping(MDDeleteWordResult))
}

final class MDWordStorage: MDWordStorageProtocol {
    
    fileprivate let memoryStorage: MDWordMemoryStorageProtocol
    fileprivate let coreDataStorage: MDWordCoreDataStorageProtocol
    
    init(memoryStorage: MDWordMemoryStorageProtocol,
         coreDataStorage: MDWordCoreDataStorageProtocol) {
        
        self.memoryStorage = memoryStorage
        self.coreDataStorage = coreDataStorage
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - Count
extension MDWordStorage {
    
    func wordsCount(storageType: MDWordStorageType, _ completionHandler: @escaping (MDWordsCountResult)) {
        switch storageType {
        case .none:
            break
        case .memory:
            memoryStorage.wordsCount(completionHandler)
        case .coreData:
            coreDataStorage.wordsCount(completionHandler)
        }
    }
    
}

// MARK: - CRUD
extension MDWordStorage {
    
    func createWord(_ wordModel: WordModel, storageType: MDWordStorageType, _ completionHandler: @escaping(MDCreateWordResult)) {
        switch storageType {
        case .none:
            break
        case .memory:
            memoryStorage.createWord(wordModel, completionHandler)
        case .coreData:
            coreDataStorage.createWord(wordModel, completionHandler)
        }
    }
    
    func readWord(fromID id: Int64, storageType: MDWordStorageType, _ completionHandler: @escaping(MDReadWordResult)) {
        switch storageType {
        case .none:
            break
        case .memory:
            memoryStorage.readWord(fromID: id, completionHandler)
        case .coreData:
            coreDataStorage.readWord(fromID: id, completionHandler)
        }
    }
    
    func updateWord(byID id: Int64, word: String, wordDescription: String, storageType: MDWordStorageType, _ completionHandler: @escaping(MDUpdateWordResult)) {
        switch storageType {
        case .none:
            break
        case .memory:
            memoryStorage.updateWord(byID: id, word: word, wordDescription: wordDescription, completionHandler)
        case .coreData:
            coreDataStorage.updateWord(byID: id, word: word, wordDescription: wordDescription, completionHandler)
        }
    }
    
    func deleteWord(_ word: WordModel, storageType: MDWordStorageType, _ completionHandler: @escaping(MDDeleteWordResult)) {
        switch storageType {
        case .none:
            break
        case .memory:
            memoryStorage.deleteWord(word, completionHandler)
        case .coreData:
            coreDataStorage.deleteWord(word, completionHandler)
        }
    }
    
}