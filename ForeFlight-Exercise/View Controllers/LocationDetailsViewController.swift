//
//  LocationDetailsViewController.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/20/23.
//

import UIKit

class LocationDetailsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak private var segmentedControl: UISegmentedControl!
    @IBOutlet weak private var childView: UIView!
    @IBOutlet weak private var lastUpdatedLabel: UILabel!
    
    private var weatherReport: WeatherReport
    private var childViewController: UIViewController?
    
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy h:mm:ss a"
        formatter.timeZone = .autoupdatingCurrent
        formatter.locale = .autoupdatingCurrent
        return formatter
    }
    
    private var weatherConditionsViewController: WeatherConditionsViewController {
        let viewController = WeatherConditionsViewController(conditions: weatherReport.conditions)
        return viewController
    }
    
    private var weatherForecastViewController: WeatherForecastViewController {
        let viewController = WeatherForecastViewController(forecast: weatherReport.forecast)
        return viewController
    }
    
    // MARK: - Initializers
    public init(weatherReport: WeatherReport) {
        self.weatherReport = weatherReport
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = weatherReport.forecast.identifier.uppercased()
        let lastUpdatedValue = Self.dateFormatter.string(from: weatherReport.lastUpdated)
        lastUpdatedLabel.text = "Last updated at \(lastUpdatedValue)"
        
        addWeatherDetailsViewController(weatherConditionsViewController)
    }
    
    // MARK: - Action Methods
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        removeWeatherDetailsViewController()
        
        if sender.selectedSegmentIndex == 0 {
            addWeatherDetailsViewController(weatherConditionsViewController)
        } else if sender.selectedSegmentIndex == 1 {
            addWeatherDetailsViewController(weatherForecastViewController)
        }
    }
}

extension LocationDetailsViewController {
    func addWeatherDetailsViewController(_ viewController: UIViewController) {
        addChild(viewController)
        self.childView.addSubview(viewController.view)
        viewController.view.frame = childView.bounds
        viewController.didMove(toParent: self)
        childViewController = viewController
    }
    
    func removeWeatherDetailsViewController() {
        childViewController?.willMove(toParent: nil)
        childViewController?.view.removeFromSuperview()
        childViewController?.removeFromParent()
        childViewController = nil
    }
}
