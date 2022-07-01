//
//  BaseResponseModel.swift
//  Assessment
//
//  Created by Shaiful Islam Sujohn on 7/2/22.
//

import UIKit

class BaseResponseModel: Codable {
    
    let txnId: String?
    let txnStatus: String?
    let message: String?
}
