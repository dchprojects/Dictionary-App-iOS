//
//  Sync.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 31.08.2021.
//

import Foundation

protocol SyncProtocol {
    func start(withSyncItem item: Sync.SyncItem, completionHandler: @escaping(([SyncResult]) -> Void))
}

final class Sync: SyncProtocol {
    
    public struct SyncItem {
        let accessToken: String
        let userId: Int64
    }
    
    fileprivate let apiLanguage: MDAPILanguageProtocol
    fileprivate let languageStorage: MDLanguageStorageProtocol
    fileprivate let apiCourse: MDAPICourseProtocol
    fileprivate let courseStorage: MDCourseStorageProtocol
    fileprivate let apiWord: MDAPIWordProtocol
    fileprivate let wordStorage: MDWordStorageProtocol
    
    init(apiLanguage: MDAPILanguageProtocol,
         languageStorage: MDLanguageStorageProtocol,
         apiCourse: MDAPICourseProtocol,
         courseStorage: MDCourseStorageProtocol,
         apiWord: MDAPIWordProtocol,
         wordStorage: MDWordStorageProtocol) {
        
        self.apiLanguage = apiLanguage
        self.languageStorage = languageStorage
        self.apiCourse = apiCourse
        self.courseStorage = courseStorage
        self.apiWord = apiWord
        self.wordStorage = wordStorage
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension Sync {
    
    func start(withSyncItem item: SyncItem, completionHandler: @escaping(([SyncResult]) -> Void)) {
        
        // Initialize Sync Results
        var syncResults: [SyncResult] = []
        
        // Initialize Dispatch Group
        let dispatchGroup: DispatchGroup = .init()
        
        // Dispatch Group Enter
        dispatchGroup.enter()
        // Get And Save Langauges
        apiGetAndSaveLanguages(withSyncItem: item) { result in
            // Append Sync Result
            syncResults.append(.init(syncType: .language,
                                     result: result))
            // Dispatch Group Leave
            dispatchGroup.leave()
        }
        
        // Notify And Pass Final Result
        dispatchGroup.notify(queue: .main) {
            completionHandler(syncResults)
        }
        
    }
    
}

// MARK: - API
extension Sync {
    
    // Language
    func apiGetAndSaveLanguages(withSyncItem item: SyncItem, completionHandler: @escaping(SyncResultWithCompletion)) {
        
        var countResult: Int = .zero
        
        apiLanguage.getLanguages(accessToken: item.accessToken) { [weak self] languagesResult in
            
            switch languagesResult {
            
            case .success(let languages):
                
                self?.languageStorage.createLanguages(storageType: .all,
                                                      languageEntities: languages) { createLanguagesResults in
                    
                    createLanguagesResults.forEach { createLanguagesResult in
                        
                        switch createLanguagesResult.result {
                        
                        case .success:
                            
                            countResult += 1
                            
                            if (countResult == createLanguagesResults.count) {
                                completionHandler(.success(()))
                                break
                            }
                            
                        case .failure(let error):
                            completionHandler(.failure(error))
                            break
                        }
                        
                    }
                    
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
            
        }
        
    }
    
    // Course
    func apiGetAndSaveCourses(withSyncItem item: SyncItem, completionHandler: @escaping(SyncResultWithCompletion)) {
        
        var countResult: Int = .zero
        
        apiCourse.getCourses(accessToken: item.accessToken, byUserId: item.userId) { [weak self] coursesResult in
            
            switch coursesResult {
            
            case .success(let courses):
                
                self?.courseStorage.createCourses(storageType: .all, courseEntities: courses) { createCoursesResults in
                    
                    createCoursesResults.forEach { createCoursesResult in
                        
                        switch createCoursesResult.result {
                        
                        case .success:
                            
                            countResult += 1
                            
                            if (countResult == createCoursesResults.count) {
                                completionHandler(.success(()))
                                break
                            }
                            
                        case .failure(let error):
                            completionHandler(.failure(error))
                            break
                        }
                        
                    }
                    
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
            
        }
        
    }
    
    // Word
    func apiGetAndSaveWords(withSyncItem item: SyncItem, completionHandler: @escaping(SyncResultWithCompletion)) {
        
        var countResult: Int = .zero
        
        apiWord.getWords(accessToken: item.accessToken, byUserId: item.userId) { [weak self] wordsResult in
            
            switch wordsResult {
            
            case .success(let words):
                
                self?.wordStorage.createWords(words, storageType: .all) { createWordsResults in
                    
                    createWordsResults.forEach { createWordsResult in
                        
                        switch createWordsResult.result {
                        
                        case .success:
                            
                            countResult += 1
                            
                            if (countResult == createWordsResults.count) {
                                completionHandler(.success(()))
                                break
                            }
                            
                        case .failure(let error):
                            completionHandler(.failure(error))
                            break
                        }
                        
                    }
                    
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
            
        }
        
    }
    
}

final class MemorySync {
    
}

enum SyncType {
    case language
}

struct SyncResult {
    let syncType: SyncType
    let result: SyncResultWithoutCompletion
}

typealias SyncResultWithoutCompletion = (Result<Void, Error>)
typealias SyncResultWithCompletion = ((SyncResultWithoutCompletion) -> Void)
