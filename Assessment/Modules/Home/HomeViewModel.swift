//
//  HomeViewModel.swift
//  Assessment
//
//  Created by Shaiful Islam Sujohn on 7/2/22.
//

import UIKit

class HomeViewModel: BaseViewModel {
    
    var offers = [OfferModel]()
    
    func startSyncing() {
        self.fetchOffers()
    }
    
    func emit(_ change: BaseViewModelChange) {
        changeHandler?(change)
    }
    
    var changeHandler: ((BaseViewModelChange) -> Void)?

}

//MARK: -API
extension HomeViewModel {
    
    fileprivate func fetchOffers() {
        
        emit(.loaderStart)
        
        requestManager?.requestService(.offer, ofType: OfferResponse<BaseResponseModel>.self, method: .GET, params: [ : ], completion: { [weak self] result in
            
            self?.emit(.loaderEnd)
            
            switch result {
                case .success(let response):
                self?.offers = response.offer_list ?? []
                    self?.emit(.updateDataModel)
                    break
                    
                case .failure(let error):
                    self?.emit(.error(message: "Something went wrong!"))
                    break
            }
        })
    }
}
