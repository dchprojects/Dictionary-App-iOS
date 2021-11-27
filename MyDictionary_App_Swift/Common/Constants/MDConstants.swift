//
//  MDConstants.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 16.05.2021.
//

import UIKit

struct MDConstants {
    
    struct StaticText {
        static let emptyString: String = ""
        static let defaultTableName: String = "Localizable"
        static let appName: String = "MyDictionary_App_Swift"
        static let dot = "."
        static let momdExtension: String = "momd"
        static let omoExtension: String = "omo"
        static let momExtension: String = "mom"
        static let jsonExtension: String = "json"
        static let sqliteExtension: String = "sqlite"
        static let spaceString: String = " "
        static let forwardSlash: String = "/"
        static let colon: String = ":"
    }
    
    struct Environment {
        static let current: MDEnvironment = .production
    }
    
    struct AppDependencies {
        
        static var dependencies: MDAppDependenciesProtocol {
            return (UIApplication.shared.delegate as! MDAppDelegate).dependencies
        }
        
    }
    
    struct Screen {
        static let size: CGSize = UIScreen.main.bounds.size
        static let width: CGFloat = size.width
        static let height: CGFloat = size.height
    }
    
    struct StatusBar {
        static let size: CGSize = UIApplication.shared.statusBarFrame.size
        static let height: CGFloat = size.height
    }
    
    struct NavigationBar {
        
        fileprivate static var largeHeight: CGFloat? = nil
        fileprivate static var smallHeight: CGFloat? = nil
        
        static func height(fromNavigationController navigationController: UINavigationController?,
                           prefersLargeTitles: Bool) -> CGFloat {
            if (navigationController == nil) {
                return .zero
            } else {
                if (prefersLargeTitles) {
                    if (largeHeight == nil) {
                        navigationController!.navigationBar.prefersLargeTitles = true
                        self.largeHeight = navigationController!.navigationBar.bounds.height
                        return self.largeHeight!
                    } else {
                        return self.largeHeight!
                    }
                } else {
                    if (smallHeight == nil) {
                        navigationController!.navigationBar.prefersLargeTitles = false
                        self.smallHeight = navigationController!.navigationBar.bounds.height
                        return self.smallHeight!
                    } else {
                        return self.smallHeight!
                    }
                }
            }
        }
        
        static func heightPlusStatusBarHeight(fromNavigationController navigationController: UINavigationController?,
                                              prefersLargeTitles: Bool) -> CGFloat {
            return height(fromNavigationController: navigationController, prefersLargeTitles: prefersLargeTitles) + StatusBar.height
        }
        
    }
    
    struct Rect {
        
        static let defaultInset: UIEdgeInsets = .init(top: .zero,
                                                      left: 16,
                                                      bottom: .zero,
                                                      right: 28)
        
        static let passwordInset: UIEdgeInsets = .init(top: .zero,
                                                       left: 16,
                                                       bottom: .zero,
                                                       right: 38)
        
        static func searchInset(searchIconImageViewLeftOffset: CGFloat) -> UIEdgeInsets {
            return .init(top: Rect.defaultInset.top,
                         left: MDConstants.Rect.defaultInset.left + searchIconImageViewLeftOffset + 6,
                         bottom: Rect.defaultInset.bottom,
                         right: Rect.defaultInset.right)
        }
        
    }
    
    struct Text {
        
        static func textIsEmpty(_ text: String?) -> Bool {
            if (text == nil || text!.isEmpty || text!.trimmingCharacters(in: .whitespaces).isEmpty) {
                return true
            } else {
                return false
            }
        }
        
        struct MaxCountCharacters {
            static let nicknameTextField: Int = 255
            static let passwordTextField: Int = 255
            static let wordTextField: Int = 255
            static let wordDescriptionTextView: Int = 500
        }
        
        struct Counter {
            
            static func result(text: String?,
                               rangeLength: Int,
                               string: String,
                               maxCountCharacters: Int) -> (count: Int, success: Bool) {
                
                let count: Int = computeCount(text: text,
                                              rangeLength: rangeLength,
                                              string: string)
                
                return (count, (count <= maxCountCharacters))
                
            }
            
            static func text(currentCount: Int, maxCount: Int) -> String {
                return String(currentCount) + MDConstants.StaticText.forwardSlash + String(maxCount)
            }
            
            fileprivate static func computeCount(text: String?,
                                                 rangeLength: Int,
                                                 string: String) -> Int {
                
                return (text?.count ?? .zero) + (string.count - rangeLength)
                
            }
            
        }
        
    }
    
    struct Keyboard {
        
        static func hideKeyboard(rootView view: UIView) {
            view.endEditing(true)
        }
        
    }
    
    struct Font {
        static let defaultSize: CGFloat = 17
    }
    
    struct StaticURL {
        static let privacyPolicyURL: URL = .init(string: "https://dchprojects.github.io/MyDictionary-Web/privacy_policy.html")!
        static let termsOfServiceURL: URL = .init(string: "https://dchprojects.github.io/MyDictionary-Web/terms_of_service.html")!
        static let aboutAppURL: URL = .init(string: "https://dchprojects.github.io/MyDictionary-Web/index.html#about")!
    }
    
    struct ShareFeedback {
        static let recipientEmail: String = "dima.chumakovwork@gmail.com"
    }
    
    struct SearchBar {
        /// Value -> 56
        static let defaultHeight: CGFloat = 56
        /// Value -> 16
        static let defaultTopOffset: CGFloat = 16
    }
    
    struct EnglishAlphabet {
        static let uppercasedCharacters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H",
                                                     "I", "J", "K", "L", "M", "N", "O", "P",
                                                     "Q", "R", "S", "T", "U", "V", "W", "X",
                                                     "Y", "Z"]
    }
    
    struct MDBundle {
        static var bundleIdentifier: String {
            guard let bundleIdentifier = Bundle.main.bundleIdentifier else { fatalError("Please Set bundleIdentifier") }
            return bundleIdentifier
        }
    }
    
    struct QueueName {
        
        // Async Operation
        //
        static let asyncOperation: String = bundleIdentifier_Plus_Dot_Plus_QueueName(queueName: String(describing: MDAsyncOperation.self))
        //
        // End Async Operation //
        
        
        // Course
        //
        fileprivate static let courseShortQueueName: String = "Course"
        static let courseCoreDataStorageOperationQueue: String = mdCoreDataStorageOperationQueue(shortQueueName: courseShortQueueName)
        //
        // End Course //
        
        
        // Word
        //
        fileprivate static let wordShortQueueName: String = "Word"
        static let wordCoreDataStorageOperationQueue: String = mdCoreDataStorageOperationQueue(shortQueueName: wordShortQueueName)
        //
        // End Word //
        
        
        // Filter Search Text Service
        //
        fileprivate static let filterSearchTextServiceQueueName: String = "Filter_Search_Text_Service"
        static let filterSearchTextServiceOperationQueue: String = mdOperationQueue(shortQueueName: filterSearchTextServiceQueueName)
        //
        // End Filter Search Text Service //
        
        
        fileprivate static func mdCoreDataStorageOperationQueue(shortQueueName: String) -> String {
            return bundleIdentifier_Plus_Dot_Plus_QueueName(queueName: "MD" + shortQueueName + "CoreDataStorageOperationQueue")
        }
        
        fileprivate static func mdOperationQueue(shortQueueName: String) -> String {
            return bundleIdentifier_Plus_Dot_Plus_QueueName(queueName: "MD" + shortQueueName + "OperationQueue")
        }
        
        //
        fileprivate static func bundleIdentifier_Plus_Dot_Plus_QueueName(queueName: String) -> String {
            return MDBundle.bundleIdentifier + MDConstants.StaticText.dot + queueName
        }
        
    }
    
    struct MDOperationQueue {
        
        static func createOperationQueue(byName name: String) -> OperationQueue {
            let operationQueue: OperationQueue = .init()
            operationQueue.name = name
            return operationQueue
        }
        
    }
    
    struct MDNetworkActivityIndicator {
        
        static func show() {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
        
        static func hide() {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        
    }
    
    struct File {
        
        /// Contains: My_Dictionary_App
        static let subDirectory: String = "My_Dictionary_App"
        
        /// Contains:  StaticText.appName
        static let name: String = StaticText.appName
        
        /// Contains: StaticText.jsonExtension
        static let `extension`: String = StaticText.jsonExtension
        
        /// Contains: File.name + StaticText.dot + File.extension
        static let fullName: String = File.name + StaticText.dot + File.extension
        
    }
    
}
