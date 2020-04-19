//
//  CountryDetailsViewController.swift
//  Covid19
//
//  Created by Abdalfattah Altaeb on 4/18/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit
import CoreData

class CountryDetailsViewController: UIViewController {

var summary: CountrySummary!


@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

@IBOutlet weak var Date: UILabel!
@IBOutlet weak var CountryName: UITextField!
@IBOutlet weak var CountryImage: UIImageView!
@IBOutlet weak var TotalConfirmed: UILabel!
@IBOutlet weak var NewConfirmed: UILabel!
@IBOutlet weak var NewDeaths: UILabel!
@IBOutlet weak var TotalDeaths: UILabel!
@IBOutlet weak var NewRecovered: UILabel!
@IBOutlet weak var TotalRecovered: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        populateViews(summary)
    }

    func populateViews(_ country: CountrySummary) {
        Date.text = country.countryCode
        CountryName.text = country.country
        Date.text = country.date
        CountryImage.image = UIImage(named: country.countryCode?.lowercased() ?? "america")
        if CountryImage.image == nil {
            CountryImage.image = UIImage(named:"america")
        }
        TotalConfirmed.text = country.totalConfirmed
        NewConfirmed.text = country.newConfirmed
        TotalDeaths.text = country.totalDeaths
        NewDeaths.text = country.newDeaths
        TotalRecovered.text = country.totalRecovered
        NewRecovered.text = country.newRecovered
    }

}
