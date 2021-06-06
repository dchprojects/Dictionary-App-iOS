//
//  SettingsDataManager.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 31.05.2021.

import Foundation

protocol SettingsDataManagerInputProtocol: AppearanceHasBeenUpdatedProtocol {
    var dataProvider: SettingsDataProviderProtocol { get }
}

protocol SettingsDataManagerOutputProtocol: AnyObject {
    func rowsForUpdate(_ rows: [IndexPath : SettingsRowModel])
}

protocol SettingsDataManagerProtocol: SettingsDataManagerInputProtocol {
    var dataManagerOutput: SettingsDataManagerOutputProtocol? { get set }
}

final class SettingsDataManager: SettingsDataManagerProtocol {
    
    internal let dataProvider: SettingsDataProviderProtocol
    internal weak var dataManagerOutput: SettingsDataManagerOutputProtocol?
    
    init(dataProvider: SettingsDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension SettingsDataManager {
    
    func appearanceHasBeenUpdated(_ newValue: AppearanceType) {
        var rowsForUpdate: [IndexPath : SettingsRowModel] = [:]
        dataProvider.rows(atSection: SettingsSectionType.list.rawValue).forEach { row in
            var updatedRow = row
            updatedRow.appearanceType = newValue
            rowsForUpdate.updateValue(updatedRow,
                                      forKey: IndexPath.init(row: row.rowType.rawValue,
                                                             section: SettingsSectionType.list.rawValue))
        }
        dataManagerOutput?.rowsForUpdate(rowsForUpdate)
    }
    
}
