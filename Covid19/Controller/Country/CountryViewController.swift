//
//  CountriesViewController.swift
//  Covid19
//
//  Created by Abdalfattah Altaeb on 4/18/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit
import CoreData

class CountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var fetchedResultsController: NSFetchedResultsController<CountrySummary>!

    fileprivate func setUpFetchedResultsController() {
        let context = viewContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let request: NSFetchRequest<CountrySummary> = CountrySummary.fetchRequest()
        let sortby = NSSortDescriptor(key: "med10yrEarnings", ascending: false)
        request.sortDescriptors = [sortby]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "summaries")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFetchedResultsController()
        fetchSchoolSummaries()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        if loadingIndicator.isAnimating && rows > 0 {
            loadingIndicator.stopAnimating()
        }
        print(fetchedResultsController.sections?[section].numberOfObjects ?? 0)
        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "summaryTableViewCell") as! SummaryTableViewCell
        let info = fetchedResultsController.object(at: indexPath)
        cell.ImageCountry.image = UIImage(named: info.countryCode?.lowercased() ?? "world")
        if cell.ImageCountry.image == nil {
            cell.ImageCountry.image = UIImage(named:"world")
        }
        cell.TotalConfirmed.text = info.totalConfirmed
        cell.TotalRecovered.text = info.totalRecovered
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schoolSummary = fetchedResultsController.object(at: indexPath)
        let vc = storyboard?.instantiateViewController(identifier: "countryDetailsViewController") as! CountryDetailsViewController
        vc.summary = schoolSummary
        navigationController?.pushViewController(vc, animated: true)
    }

    func fetchSchoolSummaries() {
        let fetchedObjects = fetchedResultsController.fetchedObjects ?? [CountrySummary]()
        if fetchedObjects.isEmpty {
            loadingIndicator.startAnimating()
        }
        DClient.shared.getSchoolSummaries { result in
            switch result {
            case .error(let message):
                self.loadingIndicator.stopAnimating()
                self.showError(message)
            case .success(let response):
                self.insertSchoolSummaries(response.Countries)
            }
        }
    }

    func insertSchoolSummaries(_ models: [SummaryResponseModel]) {
        let context = viewContext()
        models.forEach { model in
            let summary = CountrySummary(context: context)
            summary.country = model.Country
            summary.countryCode = model.CountryCode.lowercased()
            summary.date = model.Date
            summary.newConfirmed = String(model.NewConfirmed)
            summary.totalConfirmed = String(model.TotalConfirmed)
            summary.newDeaths = String(model.NewDeaths)
            summary.totalDeaths = String(model.TotalDeaths)
            summary.newRecovered = String(model.NewRecovered)
            summary.totalRecovered = String(model.TotalRecovered)
            context.insert(summary)
        }
        saveContext()
    }
}

extension CountryViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("Unknown change type")
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller.")
        @unknown default:
            fatalError("Unknown change type")
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension UIViewController {
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    func viewContext() -> NSManagedObjectContext {
        return  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func showError(_ message: String, _ title: String = "Error") {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}
