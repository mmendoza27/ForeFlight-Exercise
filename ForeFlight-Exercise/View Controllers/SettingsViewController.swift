//
//  SettingsViewController.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/24/23.
//

import OSLog
import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func automaticFetchValueChanged(isEnabled: Bool, interval: Settings.FetchInterval)
    func automaticFetchIntervalChanged(newValue: Settings.FetchInterval)
    func doneButtonTapped()
}

class SettingsViewController: UITableViewController {
    // MARK: - Properties
    @IBOutlet weak private var retrievalTypeSwitch: UISwitch!
    @IBOutlet weak private var fetchIntervalButton: UIButton!
    @IBOutlet weak private var frameworkTypeButton: UIButton!
    
    private let cacheClient = CacheClient.shared
    private let logger = Logger()
    
    public var settings: Settings!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: - View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSettingsUI()
        setupFetchIntervalMenu()
        setupFrameworkTypeMenu()
    }
    
    // MARK: - Actions
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        logger.log("Done button tapped!")
        delegate?.doneButtonTapped()
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        fetchIntervalButton.isEnabled = sender.isOn
        
        var retrievalType: Settings.RetrievalType
        if sender.isOn {
            retrievalType = .fetch
        } else {
            retrievalType = .pull
        }
        
        self.settings.retrievalType = retrievalType
        cacheClient.updateSetting(retrievalType.rawValue, for: .retrievalType)
        delegate?.automaticFetchValueChanged(isEnabled: sender.isOn, interval: settings.fetchInterval)
    }
    
    // MARK: - Private Methods
    private func setupSettingsUI() {
        settings = cacheClient.restoreSettingsFromCache()
        self.retrievalTypeSwitch.isOn = settings.retrievalType == .fetch
        fetchIntervalButton.isEnabled = self.retrievalTypeSwitch.isOn
    }
    
    private func setupFetchIntervalMenu() {
        let oneMinuteAction = UIAction(title: "1 minute", state: (settings.fetchInterval == .oneMinute) ? .on : .off) { [weak self] action in
            let fetchInterval = Settings.FetchInterval.oneMinute
            self?.settings.fetchInterval = fetchInterval
            self?.cacheClient.updateSetting(fetchInterval.rawValue, for: .fetchInterval)
            self?.logger.log("User tapped 1 minute!")
            self?.delegate?.automaticFetchIntervalChanged(newValue: fetchInterval)
        }
        
        let fiveMinutesAction = UIAction(title: "5 minutes", state: (settings.fetchInterval == .fiveMinutes) ? .on : .off) { [weak self] action in
            let fetchInterval = Settings.FetchInterval.fiveMinutes
            self?.settings.fetchInterval = fetchInterval
            self?.cacheClient.updateSetting(fetchInterval.rawValue, for: .fetchInterval)
            self?.logger.log("User tapped 5 minutes!")
            self?.delegate?.automaticFetchIntervalChanged(newValue: fetchInterval)
        }
        
        let fifteenMinutesAction = UIAction(title: "15 minutes", state: (settings.fetchInterval == .fifteenMinutes) ? .on : .off) { [weak self] action in
            let fetchInterval = Settings.FetchInterval.fifteenMinutes
            self?.settings.fetchInterval = fetchInterval
            self?.cacheClient.updateSetting(fetchInterval.rawValue, for: .fetchInterval)
            self?.logger.log("User tapped 15 minutes!")
            self?.delegate?.automaticFetchIntervalChanged(newValue: fetchInterval)
        }
        
        fetchIntervalButton.menu = UIMenu(title: "", children: [oneMinuteAction, fiveMinutesAction, fifteenMinutesAction])
    }
    
    private func setupFrameworkTypeMenu() {
        let uiKitAction = UIAction(title: "UIKit", state: (settings.userInterfaceFramework == .uiKit) ? .on : .off) { [weak self] action in
            let framework = Settings.UserInterfaceFramework.uiKit
            self?.settings.userInterfaceFramework = framework
            self?.cacheClient.updateSetting(framework.rawValue, for: .userInterfaceFramework)
            self?.logger.log("User is switching to UIKit!")
        }
        
        let swiftUIAction = UIAction(title: "SwiftUI", state: (settings.userInterfaceFramework == .swiftUI) ? .on : .off) { [weak self] action in
            let framework = Settings.UserInterfaceFramework.swiftUI
            self?.settings.userInterfaceFramework = framework
            self?.cacheClient.updateSetting(framework.rawValue, for: .userInterfaceFramework)
            self?.logger.log("User is switching to SwiftUI!")
        }
        
        frameworkTypeButton.menu = UIMenu(title: "", children: [uiKitAction, swiftUIAction])
    }
}
