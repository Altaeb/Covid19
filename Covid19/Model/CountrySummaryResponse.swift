//
//  CountrySummaryResponse.swift
//  Covid19
//
//  Created by Abdalfattah Altaeb on 4/19/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import Foundation

struct CountrySummaryResponse : Codable {
    let Countries: [SummaryResponseModel]
}

struct SummaryResponseModel : Codable {
    let Country: String
    let CountryCode: String
    let Date: String
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
    let NewRecovered: Int
    let TotalRecovered: Int

}


//enum CodingKeys : String, CodingKey {
//    case newConfirmed = "NewConfirmed"
//    case totalConfirmed = "TotalConfirmed"
//    case newDeaths = "NewDeaths"
//    case totalDeaths = "TotalDeaths"
//    case newRecovered = "NewRecovered"
//    case totalRecovered = "TotalRecovered"
//}
