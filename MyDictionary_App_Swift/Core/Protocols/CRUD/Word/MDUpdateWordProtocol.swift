//
//  MDUpdateWordProtocol.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 29.05.2021.
//

import Foundation

protocol MDUpdateWordProtocol {
    
    func updateWord(byWordUUID uuid: UUID,
                    newWordText: String,
                    newWordDescription: String,
                    newUpdatedAt: Date,
                    _ completionHandler: @escaping(MDOperationResultWithCompletion<Void>))
    
}
