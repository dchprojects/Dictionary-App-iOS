//
//  MDAPIAccount.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 25.08.2021.
//

import Foundation

protocol MDAPIAccountProtocol {
    
    func deleteAccount(accessToken: String,
                       userId: Int64,
                       completionHandler: @escaping(MDDeleteAccountResultWithCompletion))
    
}

final class MDAPIAccount: MDAPIAccountProtocol {
    
    fileprivate let requestDispatcher: MDRequestDispatcherProtocol
    fileprivate let operationQueueService: OperationQueueServiceProtocol
    
    init(requestDispatcher: MDRequestDispatcherProtocol,
         operationQueueService: OperationQueueServiceProtocol) {
        
        self.requestDispatcher = requestDispatcher
        self.operationQueueService = operationQueueService
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - Endpoint
extension MDAPIAccount {
    
    enum MDAPIAccountEndpoint: MDEndpoint {
        
        case deleteAccount(accessToken: String,
                           userId: Int64)
        
        var path: String {
            switch self {
            case .deleteAccount(_, let userId):
                return "deleteAccount/userId/\(userId)"
            }
        }
        
        var httpMethod: HTTPMethod {
            switch self {
            case .deleteAccount:
                return .delete
            }
        }
        
        var httpHeaders: HTTPHeader {
            switch self {
            case .deleteAccount(let accessToken, _):
                return Constants
                    .HTTPHeaderConstants
                    .authorizationHeaders(accessToken: accessToken)
            }
        }
        
        var httpParameters: HTTPParameters? {
            switch self {
            case .deleteAccount:
                return nil
            }
        }
        
        var requestType: MDRequestType {
            switch self {
            case .deleteAccount:
                return .data
            }
        }
        
        var responseType: MDResponseType {
            switch self {
            case .deleteAccount:
                return .data
            }
        }
        
    }
    
}

extension MDAPIAccount {
    
    func deleteAccount(accessToken: String,
                       userId: Int64,
                       completionHandler: @escaping (MDDeleteAccountResultWithCompletion)) {
        
        let operation: MDAPIOperation = .init(requestDispatcher: self.requestDispatcher,
                                              endpoint: MDAPIAccountEndpoint.deleteAccount(accessToken: accessToken,
                                                                                           userId: userId)) { result in
            
            switch result {
            
            case .data:
                
                completionHandler(.success(()))
                
                break
                
            case .error(let error, _):
                
                debugPrint(#function, Self.self, "error: ", error.localizedDescription)
                
                completionHandler(.failure(error))
                
                break
                
            }
        }
        
        operationQueueService.enqueue(operation)
        
    }
    
}