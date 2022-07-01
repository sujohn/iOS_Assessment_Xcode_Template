//
//  OfferResponse.swift
//  Assessment
//
//  Created by Shaiful Islam Sujohn on 7/2/22.
//

import UIKit
    
class OfferResponse<T>: Codable where T: Codable {

    var offer_list: [OfferModel]?
}

class OfferModel: Codable {
    
    var offer_type: AppConstant.OfferType
    let offer_detail: [OfferDetailsModel]?
}

class OfferDetailsModel: Codable {

    let offer_id, offer_name, offer_desc: String
    let amount: Int
    let validity: String
}
