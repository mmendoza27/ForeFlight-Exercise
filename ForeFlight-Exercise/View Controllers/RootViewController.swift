//
//  RootViewController.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/20/23.
//

import OSLog
import UIKit

class RootViewController: UINavigationController {
    // MARK: - Properties
    private var currentViewController: UIViewController?
    private let logger = Logger()
    private let weatherReportService = WeatherReportService()
    
    private var timer: Timer?
    
    // MARK: - View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = CacheClient.shared.restoreSettingsFromCache()
        if settings.userInterfaceFramework == .swiftUI {
            self.isNavigationBarHidden = true
            
        } else if settings.userInterfaceFramework == .uiKit {
            let locationsViewController = LocationsViewController(
                weatherReportService: weatherReportService,
                delegate: self
            )
            
            viewControllers = [locationsViewController]
            currentViewController = locationsViewController
            
            if settings.retrievalType == .fetch {
                setupAutomaticRefresh(for: settings.fetchInterval)
            }
        }
    }
    
    // MARK: - Private Methods
    private func displayErrorAlert(error: Error) {
        let errorAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        errorAlertController.addAction(okAction)
        
        present(errorAlertController, animated: true)
    }
    
    private func setupAutomaticRefresh(for interval: Settings.FetchInterval) {
        var timeInterval: TimeInterval
        let minuteInSeconds: Double = 60.0
        
        switch interval {
        case .oneMinute:
            timeInterval = 1.0 * minuteInSeconds
        case .fiveMinutes:
            timeInterval = 5.0 * minuteInSeconds
        case .fifteenMinutes:
            timeInterval = 15.0 * minuteInSeconds
        }
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] timer in
            guard let locationsViewController = self?.currentViewController as? LocationsViewController else { return }
            locationsViewController.refreshWeatherReports()
        })
    }
}

extension RootViewController: LocationsViewControllerDelegate {
    func settingsButtonWasTapped() {
        let storyboard = UIStoryboard(name: "Settings", bundle: .main)
        let settingsNavigationController = storyboard.instantiateViewController(withIdentifier: "SettingsNavigationController")
        let settingsViewController = settingsNavigationController.children.first as? SettingsViewController
        settingsViewController?.delegate = self
        
        present(settingsNavigationController, animated: true)
        logger.info("Settings screen was shown!")
    }
    
    func addNewLocationButtonWasTapped() {
        let alertController = UIAlertController(title: "Add New Location", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] action in
            guard let input = alertController?.textFields?.first?.text else { return }
            
            let airportIdentifier = input.uppercased()
            
            guard let locationsViewController = self?.currentViewController as? LocationsViewController else { return }
            
            Task {
                await locationsViewController.attemptToAddNewReport(airportIdentifier: airportIdentifier)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    func addNewLocationFailed(error: Error) {
        displayErrorAlert(error: error)
    }
    
    func updatingLocationsFailed(error: Error) {
        displayErrorAlert(error: error)
    }
    
    func weatherReportWasTapped(report: WeatherReport) {
        let locationDetailsViewController = LocationDetailsViewController(weatherReport: report)
        pushViewController(locationDetailsViewController, animated: true)
        logger.info("Location details screen was shown!")
    }
}

extension RootViewController: SettingsViewControllerDelegate {
    func automaticFetchValueChanged(isEnabled: Bool, interval: Settings.FetchInterval) {
        if isEnabled {
            setupAutomaticRefresh(for: interval)
        } else {
            self.timer?.invalidate()
            timer = nil
        }
    }
    
    func automaticFetchIntervalChanged(newValue: Settings.FetchInterval) {
        setupAutomaticRefresh(for: newValue)
    }
    
    func doneButtonTapped() {
        dismiss(animated: true)
        logger.log("Settings screen was dismissed!")
    }
}
