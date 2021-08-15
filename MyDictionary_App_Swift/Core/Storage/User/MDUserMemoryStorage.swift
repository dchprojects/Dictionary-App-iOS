//
//  MDUserMemoryStorage.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 15.08.2021.
//

import Foundation

protocol MDUserMemoryStorageProtocol: MDCRUDUserProtocol {
    
}

final class MDUserMemoryStorage: MDUserMemoryStorageProtocol {
    
    fileprivate let operationQueueService: OperationQueueServiceProtocol
    
    var userEntity: UserEntity?
    
    init(operationQueueService: OperationQueueServiceProtocol,
         userEntity: UserEntity?) {
        
        self.operationQueueService = operationQueueService
        self.userEntity = userEntity
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension MDUserMemoryStorage {
    
    func createUser(_ userEntity: UserEntity, _ completionHandler: @escaping (MDUserResult)) {
        let operation = MDCreateUserMemoryStorageOperation.init(memoryStorage: self,
                                                                userEntity: userEntity) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func readUser(fromUserID userId: Int64, _ completionHandler: @escaping (MDUserResult)) {
        let operation = MDReadUserMemoryStorageOperation.init(memoryStorage: self, userId: userId) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func deleteUser(_ userEntity: UserEntity, _ completionHandler: @escaping (MDUserResult)) {
        let operation = MDDeleteUserMemoryStorageOperation.init(memoryStorage: self) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
}
