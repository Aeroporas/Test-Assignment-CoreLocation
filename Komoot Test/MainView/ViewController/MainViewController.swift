//
//  ViewController.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    private var presenter: MainViewControllerOutput?
    private var currentBarButtonState: BarButtonState = .Start {
        didSet {
            barButton.title = currentBarButtonState.rawValue
        }
    }
    
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBAction func barButtonPressed(_ sender: Any) {
        presenter?.didPressBarButton(buttonState: currentBarButtonState)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainViewControllerPresenter(viewController: self)
        
        // Setup tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        // Location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
}
 
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.tableViewModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = presenter?.tableViewModel else {
            assertionFailure()
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCellWithRegistration(type: CellWithImageTableViewCell.self, indexPath: indexPath)
        cell.setup(with: model[indexPath.row])
        return cell
    }
}

extension MainViewController: MainViewControllerInput {
    //TODO: Diffable datasource
    func shouldReloadTableViewCell(at index: Int) {
        tableView.reloadData()
    }
    
    func updateBarButtonState(trackingIsInProgress: Bool) {
        if trackingIsInProgress {
            currentBarButtonState = .Stop
        } else {
            currentBarButtonState = .Start
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        presenter?.didUpdateLocations(locations)
    }
}

enum BarButtonState: String {
    case Start // tracking is stopped
    case Stop // tracking is in progress
}
