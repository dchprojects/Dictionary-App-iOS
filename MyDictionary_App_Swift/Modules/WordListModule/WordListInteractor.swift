//
//  WordListInteractor.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 16.05.2021.
//

import Foundation

protocol WordListInteractorInputProtocol: MDViewDidLoadProtocol {
    var tableViewDelegate: WordListTableViewDelegateProtocol { get }
    var tableViewDataSource: WordListTableViewDataSourceProtocol { get }
    var searchBarDelegate: MDSearchBarDelegateImplementationProtocol { get }
    func addNewWordButtonClicked()
}

protocol WordListInteractorOutputProtocol: AnyObject,
                                           MDHideKeyboardProtocol,
                                           MDReloadDataProtocol,
                                           MDShowErrorProtocol,
                                           MDShowHideProgressHUD {
    
    func deleteRow(at indexPath: IndexPath)
    func showAddWord(withCourse course: CourseResponse)
    
}

protocol WordListInteractorProtocol: WordListInteractorInputProtocol,
                                     WordListDataManagerOutputProtocol {
    var interactorOutput: WordListInteractorOutputProtocol? { get set }
}

final class WordListInteractor: NSObject,
                                WordListInteractorProtocol {
    
    fileprivate let dataManager: WordListDataManagerInputProtocol
    fileprivate let wordManager: MDWordManagerProtocol
    
    internal var tableViewDelegate: WordListTableViewDelegateProtocol
    internal var tableViewDataSource: WordListTableViewDataSourceProtocol
    internal var searchBarDelegate: MDSearchBarDelegateImplementationProtocol
    
    internal weak var interactorOutput: WordListInteractorOutputProtocol?
    
    init(dataManager: WordListDataManagerInputProtocol,
         tableViewDelegate: WordListTableViewDelegateProtocol,
         tableViewDataSource: WordListTableViewDataSourceProtocol,
         searchBarDelegate: MDSearchBarDelegateImplementationProtocol,
         wordManager: MDWordManagerProtocol) {
        
        self.dataManager = dataManager
        self.tableViewDelegate = tableViewDelegate
        self.tableViewDataSource = tableViewDataSource
        self.searchBarDelegate = searchBarDelegate
        self.wordManager = wordManager
        
        super.init()
        subscribe()
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - WordListDataManagerOutputProtocol
extension WordListInteractor {
    
    func readAndAddWordsToDataProviderResult(_ result: MDOperationResultWithoutCompletion<Void>) {
        checkResultAndExecuteReloadDataOrShowError(result)
    }
    
    func filteredWordsResult(_ result: MDOperationResultWithoutCompletion<Void>) {
        checkResultAndExecuteReloadDataOrShowError(result)
    }
    
    func clearWordFilterResult(_ result: MDOperationResultWithoutCompletion<Void>) {
        checkResultAndExecuteReloadDataOrShowError(result)
    }
    
}

// MARK: - WordListInteractorInputProtocol
extension WordListInteractor {
    
    func viewDidLoad() {
        dataManager.readAndAddWordsToDataProvider()
    }
    
    func addNewWordButtonClicked() {
        interactorOutput?.showAddWord(withCourse: dataManager.dataProvider.course)
    }
    
}

// MARK: - Subscribe
fileprivate extension WordListInteractor {
    
    func subscribe() {
        //
        searchBarCancelButtonAction_Subscribe()
        //
        searchBarSearchButtonAction_Subscribe()
        //
        searchBarTextDidChangeAction_Subscribe()
        //
        searchBarShouldClearAction_Subscribe()
        //
        tableViewDataSourceDeleteButtonAction_Subscribe()
        //
    }
    
    func searchBarCancelButtonAction_Subscribe() {
        
        searchBarDelegate.searchBarCancelButtonAction = { [weak self] in
            self?.interactorOutput?.hideKeyboard()
        }
        
    }
    
    func searchBarSearchButtonAction_Subscribe() {
        
        searchBarDelegate.searchBarSearchButtonAction = { [weak self] in
            self?.interactorOutput?.hideKeyboard()
        }
        
    }
    
    func searchBarTextDidChangeAction_Subscribe() {
        
        searchBarDelegate.searchBarTextDidChangeAction = { [weak self] (searchText) in
            self?.dataManager.filterWords(searchText)
        }
        
    }
    
    func searchBarShouldClearAction_Subscribe() {
        
        searchBarDelegate.searchBarShouldClearAction = { [weak self] in
            self?.dataManager.clearWordFilter()
        }
        
    }
    
    func tableViewDataSourceDeleteButtonAction_Subscribe() {
        
        tableViewDataSource.deleteButtonAction = { [unowned self] (indexPath) in
            
            // Show Progress HUD
            interactorOutput?.showProgressHUD()
            //
            let word = dataManager.dataProvider.wordListCellModel(atIndexPath: indexPath)!.wordResponse
            // Delete Word From API And Storage
            wordManager.deleteWordFromApiAndAllStorage(byUserId: word.userId,
                                                       byCourseId: word.courseId,
                                                       byWordId: word.wordId) { [unowned self] deleteWordResult in
                
                switch deleteWordResult {
                    
                case .success:
                    // Hide Progress HUD
                    interactorOutput?.hideProgressHUD()
                    //
                    dataManager.deleteWord(atIndexPath: indexPath)
                    //
                    interactorOutput?.deleteRow(at: indexPath)
                    //
                    break
                    //
                    
                case .failure(let error):
                    // Hide Progress HUD
                    interactorOutput?.hideProgressHUD()
                    //
                    interactorOutput?.showError(error)
                    //
                    break
                    //
                }
                
            }
            
            
        }
        
    }
    
}

// MARK: - Private Methods
fileprivate extension WordListInteractor {
    
    func checkResultAndExecuteReloadDataOrShowError(_ result: MDOperationResultWithoutCompletion<Void>) {
        
        switch result {
            
        case .success:
            
            //
            interactorOutput?.reloadData()
            //
            break
            //
            
        case .failure(let error):
            
            //
            interactorOutput?.showError(error)
            //
            break
            //
            
        }
        
    }
    
}
