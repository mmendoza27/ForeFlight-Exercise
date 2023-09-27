//
//  LocationsViewController.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/20/23.
//

import OSLog
import UIKit

protocol LocationsViewControllerDelegate: AnyObject {
    func settingsButtonWasTapped()
    func addNewLocationButtonWasTapped()
    func addNewLocationFailed(error: Error)
    func updatingLocationsFailed(error: Error)
    func weatherReportWasTapped(report: WeatherReport)
}

class LocationsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var activityIndicatorView: UIView!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let cacheClient = CacheClient.shared
    private let logger = Logger()
    private var refreshControl = UIRefreshControl()
    private var weatherReports: [WeatherReport] = []
    private var weatherReportService: WeatherReportService
    
    weak var delegate: LocationsViewControllerDelegate?
    
    // MARK: - Initializers
    public init(weatherReportService: WeatherReportService, delegate: LocationsViewControllerDelegate? = nil) {
        self.weatherReportService = weatherReportService
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Locations"
        
        let settingsButton = UIBarButtonItem(image: .settings, style: .plain, target: self, action: #selector(settingsButtonTapped))
        let addButton = UIBarButtonItem(image: .plus, style: .done, target: self, action: #selector(addButtonTapped))
        
        self.navigationItem.leftBarButtonItem = settingsButton
        self.navigationItem.rightBarButtonItem = addButton
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherReports), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        self.activityIndicatorView.layer.cornerRadius = 8.0
        
        self.showActivityIndicator()
        
        Task {
            do {
                let initialLocations = cacheClient.retrieveAirportLocations(for: .requestedAirports)
                let reports = try await weatherReportService.retrieveWeatherReports(for: initialLocations).value
                weatherReports = reports
                
                cacheClient.addAirportLocations(initialLocations, for: .requestedAirports)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                logger.error("\(error.localizedDescription)")
                delegate?.updatingLocationsFailed(error: error)
            }
        }
        
        self.hideActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Actions
    @objc func settingsButtonTapped() {
        logger.info("Settings button was tapped!")
        delegate?.settingsButtonWasTapped()
    }
    
    @objc func addButtonTapped() {
        logger.info("Add button was tapped!")
        delegate?.addNewLocationButtonWasTapped()
    }
    
    @objc func refreshWeatherReports() {
        let identifiers = weatherReports.map(\.forecast.identifier)
        
        Task {
            do {
                let updatedReports = try await weatherReportService.retrieveWeatherReports(for: identifiers).value
                weatherReports = updatedReports
                
                cacheClient.addAirportLocations(identifiers, for: .requestedAirports)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                logger.log("Weather reports refreshed on \(Date.now)!")
            } catch {
                logger.error("\(error.localizedDescription)")
                delegate?.updatingLocationsFailed(error: error)
            }
        }
        
        self.refreshControl.endRefreshing()
    }
    
    // MARK: Public Methods
    func attemptToAddNewReport(airportIdentifier: String) async {
        self.showActivityIndicator()
        
        do {
            let weatherReport = try await weatherReportService.retrieveWeatherReport(for: airportIdentifier).value
            weatherReports.append(weatherReport)
            
            cacheClient.addAirportLocation(airportIdentifier, for: .requestedAirports)
            logger.info("\(airportIdentifier) was added to the list!")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.delegate?.weatherReportWasTapped(report: weatherReport)
            }
        } catch {
            logger.error("\(error.localizedDescription)")
            delegate?.addNewLocationFailed(error: error)
        }
        
        self.hideActivityIndicator()
    }
    
    func showActivityIndicator() {
        self.activityIndicatorView.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        self.activityIndicatorView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
}

// MARK: - Table View Data Source Methods
extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = weatherReports[indexPath.row].forecast.identifier.uppercased()
        
        cell.contentConfiguration = contentConfiguration
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - Table View Delegate Methods
extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherReport = weatherReports[indexPath.row]
        logger.info("\(weatherReport.forecast.identifier.uppercased()) was tapped!")
        delegate?.weatherReportWasTapped(report: weatherReport)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let identifier = weatherReports[indexPath.row].forecast.identifier
            
            weatherReports.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            cacheClient.removeAirportLocation(identifier.uppercased(), for: .requestedAirports)
        }
    }
}
