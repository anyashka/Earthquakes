//
//  EarthquakeViewController.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 10/10/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class EarthquakeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var earthquakes = [Quake]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        return refreshController
    }()
    
    //MARK: Life Cycle methods
    override func viewDidLoad() {
        setUpTableView()
        fetchEarthquakes()
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: View setup
    func refreshControlValueChanged(sender: UIRefreshControl) {
        earthquakes.removeAll(keepingCapacity: false)
        fetchEarthquakes()
        self.refreshControl.endRefreshing()
    }
}

//MARK: Table View Data Source methods
extension EarthquakeViewController: UITableViewDataSource {
    func setUpTableView() {
        let cellNothingFoundNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(cellNothingFoundNib, forCellReuseIdentifier: "NothingFoundCell")
        let cellNibName = UINib(nibName: EarthquakeTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(cellNibName, forCellReuseIdentifier: EarthquakeTableViewCell.cellIdentifier)
        
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (earthquakes.count > 0) ? earthquakes.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if earthquakes.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingFoundCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: EarthquakeTableViewCell.cellIdentifier, for: indexPath) as! EarthquakeTableViewCell
            let earthquake = earthquakes[indexPath.row]
            cell.configure(withName: earthquake.name, date: earthquake.date, magnitude: earthquake.magnitude)
            return cell
        }
    }
}

//MARK: Table View Delegate Methods
extension EarthquakeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let earthquake = earthquakes[indexPath.row]
        guard let detailedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailedViewController") as? DetailedEarthquakeViewController else { return }
        detailedViewController.earthquake = earthquake
       self.navigationController?.pushViewController(detailedViewController, animated: true)
    }
}

//MARK: API methods
extension EarthquakeViewController {
    func fetchEarthquakes() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        APIClient.getListOfEarthquakes{ (data) in
            let json = JSON(data)
            guard let earthquakeArray = json["features"].array else { return }
            for earthquakeJSON in earthquakeArray {
                guard let earthquake = Quake.parse(earthquakeJSON: earthquakeJSON) else { return }
                self.earthquakes.append(earthquake)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
