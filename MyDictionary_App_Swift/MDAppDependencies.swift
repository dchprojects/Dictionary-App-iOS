//
//  MDAppDependencies.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 07.07.2021.
//

import UIKit
import Firebase
import Reachability

protocol MDAppDependenciesProtocol {
    var rootWindow: UIWindow! { get }
    var reachability: Reachability! { get }
    var operationQueue: OperationQueue! { get }
    var operationQueueService: OperationQueueServiceProtocol! { get }
    var coreDataStack: CoreDataStack! { get }
    var keychainService: KeychainService! { get }
    
    // Storage //
    var wordStorage: MDWordStorageProtocol! { get }
    var userStorage: MDUserStorageProtocol! { get }
    var jwtStorage: MDJWTStorageProtocol! { get }
    // End Storage
    
}

final class MDAppDependencies: NSObject, MDAppDependenciesProtocol {
    
    var rootWindow: UIWindow!
    var reachability: Reachability!
    var operationQueue: OperationQueue!
    var operationQueueService: OperationQueueServiceProtocol!
    var coreDataStack: CoreDataStack!
    var keychainService: KeychainService!
    // Storage //
    var wordStorage: MDWordStorageProtocol!
    var userStorage: MDUserStorageProtocol!
    var jwtStorage: MDJWTStorageProtocol!
    // End Storage //
    
    init(rootWindow: UIWindow!) {
        self.rootWindow = rootWindow
        super.init()
        configureDependencies()
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension MDAppDependencies {
    
    func configureDependencies() {
        
        guard let reachability = try? Reachability.init() else { fatalError("Impossible initialize Reachability Service") }
        self.reachability = reachability
        //
        let operationQueue: OperationQueue = .init()
        self.operationQueue = operationQueue
        //
        let operationQueueService: OperationQueueServiceProtocol = OperationQueueService.init(operationQueue: operationQueue)
        self.operationQueueService = operationQueueService
        //
        let coreDataStack: CoreDataStack = .init()
        self.coreDataStack = coreDataStack
        //
        let keychainService: KeychainService = .init()
        self.keychainService = keychainService
        //
        // Storage //
        // Word //
        let wordMemoryStorage: MDWordMemoryStorageProtocol = MDWordMemoryStorage.init(operationQueueService: operationQueueService,
                                                                                      arrayWords: [])
        
        let wordCoreDataStorage: MDWordCoreDataStorageProtocol = MDWordCoreDataStorage.init(operationQueueService: operationQueueService,
                                                                                            managedObjectContext: coreDataStack.privateContext,
                                                                                            coreDataStack: coreDataStack)
        
        let wordStorage: MDWordStorageProtocol = MDWordStorage.init(memoryStorage: wordMemoryStorage,
                                                                    coreDataStorage: wordCoreDataStorage)
        
        self.wordStorage = wordStorage
        // End Word //
        
        // User //
        let userMemoryStorage: MDUserMemoryStorageProtocol = MDUserMemoryStorage.init(operationQueueService: operationQueueService,
                                                                                      userEntity: nil)
        
        let userCoreDataStorage: MDUserCoreDataStorageProtocol = MDUserCoreDataStorage.init(operationQueueService: operationQueueService,
                                                                                            managedObjectContext: coreDataStack.privateContext,
                                                                                            coreDataStack: coreDataStack)
        
        let userStorage: MDUserStorageProtocol = MDUserStorage.init(memoryStorage: userMemoryStorage,
                                                                    coreDataStorage: userCoreDataStorage)
        
        self.userStorage = userStorage
        // End User //
        
        // JWT //
        let jwtMemoryStorage: MDJWTMemoryStorageProtocol = MDJWTMemoryStorage.init(operationQueueService: operationQueueService,
                                                                                   jwtResponse: nil)
        
        let jwtCoreDataStorage: MDJWTCoreDataStorageProtocol = MDJWTCoreDataStorage.init(operationQueueService: operationQueueService,
                                                                                         managedObjectContext: coreDataStack.privateContext,
                                                                                         coreDataStack: coreDataStack)
        
        let jwtStorage: MDJWTStorageProtocol = MDJWTStorage.init(memoryStorage: jwtMemoryStorage,
                                                                 coreDataStorage: jwtCoreDataStorage)
        
        self.jwtStorage = jwtStorage
        // End JWT //
        // End Storage //        
        
        // Configure FirebaseApp
        FirebaseApp.configure()
        
    }
    
}
