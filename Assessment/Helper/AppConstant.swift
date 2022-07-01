//
//  AppConstant.swift
//  Assessment
//
//  Created by Shaiful Islam Sujohn on 7/2/22.
//

import UIKit

class AppConstant: NSObject {

    enum OfferType: String, Codable {
        case Specials = "Specials"
        case Internet = "Internet"
        case RateCutters = "Rate Cutters"
        case Voice = "Voice"
    }
}
