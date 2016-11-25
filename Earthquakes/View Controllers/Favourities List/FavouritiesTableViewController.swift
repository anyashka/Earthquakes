//
//  FavouritiesTableViewController.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 12/10/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavouritiesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Earthquake> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Earthquake> = Earthquake.fetchRequest()
        let firstSortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        fetchRequest.sortDescriptors = [firstSortDescriptor]
        fetchRequest.fetchBatchSize = 10
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    //MARK: Life Cycle methods
    override func viewDidLoad() {
        setupTableView()
        fetchFavourities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

//MARK: TableView DataSource methods
extension FavouritiesTableViewController: UITableViewDataSource {
    func setupTableView() {
        let cellNibName = UINib(nibName: EarthquakeTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: EarthquakeTableViewCell.cellIdentifier)
        
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 1 }
        let rows = sections[section]
        return rows.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EarthquakeTableViewCell.cellIdentifier, for: indexPath) as! EarthquakeTableViewCell
        let earthquakeObject = fetchedResultsController.object(at: indexPath)
        guard let name = earthquakeObject.name, let date = earthquakeObject.time as? Date else { return cell }
        
        cell.configure(withName: name, date: date, magnitude: earthquakeObject.magnitude)
        
        return cell
    }
}

//MARK: TableView Delegate methods
extension FavouritiesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard fetchedResultsController.fetchedObjects?.count != 0 else { return }
        let earthquakeObject = fetchedResultsController.object(at: indexPath)
        let earthquake = earthquakeObject.mapToQuake()
        guard let detailedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailedViewController") as? DetailedEarthquakeViewController else { return }
        detailedViewController.earthquake = earthquake
        self.navigationController?.pushViewController(detailedViewController, animated: true)
    }
}

//MARK: API methods
extension FavouritiesTableViewController {
    func fetchFavourities() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
}

//MARK: FetchedResultsController Delegate methods
extension FavouritiesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .update:
            if let indexPathN = indexPath {
                self.tableView.reloadRows(at: [indexPathN], with: .automatic)
                return
            }
        case .insert:
            if let indexPath = newIndexPath {
                self.tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .move:
            guard let indexPath = indexPath else {
                return
            }
            guard let newIndexPath = newIndexPath else {
                return
            }
            if indexPath == newIndexPath {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                return
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
}
