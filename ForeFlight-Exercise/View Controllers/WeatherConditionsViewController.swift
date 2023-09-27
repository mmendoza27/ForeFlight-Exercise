//
//  WeatherConditionsViewController.swift
//  ForeFlight-Exercise
//
//  Created by Michael Mendoza on 9/24/23.
//

import UIKit

class WeatherConditionsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak private var tableView: UITableView!
    
    private var conditions: Conditions
    private var mirror: Mirror {
        Mirror(reflecting: conditions)
    }
    
    // MARK: - Initializers
    public init(conditions: Conditions) {
        self.conditions = conditions
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WeatherConditionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mirror.children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var contentConfiguration = UIListContentConfiguration.valueCell()
        let index = AnyIndex(indexPath.row)
        contentConfiguration.text = mirror.children[index].label
        contentConfiguration.secondaryText = String(describing: mirror.children[index].value)
        
        cell.contentConfiguration = contentConfiguration
        return cell
    }
}

extension WeatherConditionsViewController: UITableViewDelegate {
    
}
