//
//  DetailedEarthquakeViewController.swift
//  Earthquakes
//
//  Created by Anna-Maria Shkarlinska on 11/10/16.
//  Copyright © 2016 Anna-Maria Shkarlinska. All rights reserved.
//

import UIKit
import MapKit
import PKHUD
import CoreData

class DetailedEarthquakeViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var favouritiesButton: UIButton!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    var earthquake: Quake?
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupMap()
    }
 
    //MARK: seting up views
    func setupView() {
        let imageForNormalState = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
        favouritiesButton.setImage(imageForNormalState, for: .normal)
        let imageForSelectedState = UIImage(named: "star_PNG1595")?.withRenderingMode(.alwaysTemplate)
        favouritiesButton.setImage(imageForSelectedState, for: .selected)
        
        guard let earthquake = earthquake else { return }
        nameLabel.text = earthquake.name
        dateLabel.text = earthquake.date.dateAsString()
        timeLabel.text = earthquake.date.timeAsString()
        depthLabel.text = String(earthquake.depth)
        magnitudeLabel.text = String(earthquake.magnitude)
        
        if Earthquake.isFavourite(quake: earthquake, inContext: context) {
            favouritiesButton.isSelected = true
        } else {
            favouritiesButton.isSelected = false
        }
    }
    
    func setupMap() {
        addPin()
        focusMapView()
    }
    func addPin() {
        let annotation = MKPointAnnotation()
        guard let earthquake = earthquake else { return }
        let centerCoordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
        annotation.coordinate = centerCoordinate
        mapView.addAnnotation(annotation)
    }

    func focusMapView() {
        guard let earthquake = earthquake else { return }
        let mapCenter = CLLocationCoordinate2DMake(earthquake.latitude, earthquake.longitude)
        let span = MKCoordinateSpanMake(5, 5)
        let region = MKCoordinateRegionMake(mapCenter, span)
        mapView.region = region
    }
    
    //MARK: Actions
    @IBAction func favouritiesButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard let earthquake = earthquake else { return }
        if sender.isSelected {
            Earthquake.createEarthquake(from: earthquake, inContext: context)
        } else {
            Earthquake.removeFromFavourites(quake: earthquake, inContext: context)
        }
    }
    
    @IBAction func moreButtonAction(_ sender: AnyObject) {
        guard let earthquake = earthquake, let url = URL.init(string: earthquake.url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func shareBarButtonAction(_ sender: AnyObject) {
        guard let earthquake = earthquake else { return }
        UIPasteboard.general.string = earthquake.url
        HUD.flash(.labeledSuccess(title: "Link was copied to your clipboard", subtitle: nil), delay: 1.5)
    } 
}
