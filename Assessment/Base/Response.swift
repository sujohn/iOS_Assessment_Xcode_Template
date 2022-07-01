//
//  Response.swift
//  Assessment
//
//  Created by Shaiful Islam Sujohn on 7/2/22.
//

import UIKit

struct Response<T>: Codable where T: Codable {
    
    let txnId: String?
    let txnStatus: String?
    let message: String?
}

struct EmptyData: Codable {
    
}
