//
//  BaseViewModel.swift
//  Assessment
//
//  Created by Shaiful Islam Sujohn on 7/2/22.
//

import Foundation

protocol BaseViewModel {

    func startSyncing()
    func emit(_ change: BaseViewModelChange)
    var changeHandler: ((BaseViewModelChange) -> Void)? {get set}
}

enum BaseViewModelChange {
    case loaderStart
    case loaderEnd
    case updateDataModel
    case error(message: String)
    case success(message: String)
}

extension BaseViewModel {
    
    var requestManager: RequestManager? {
        return RequestManager.manager
    }
}
