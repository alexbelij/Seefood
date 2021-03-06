//
//  SettingsViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/19/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SettingsHandler: PopupController {

    lazy var settingsTableViewController: SettingsTableViewController = {
        let vc = SettingsTableViewController.init(style: .grouped)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    override func setupViews() {
        super.setupViews()
        
        baseView.addSubview(settingsTableViewController.view)
        setupContent(content: settingsTableViewController.view)
    }
    
}

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewToggleCell.self, forCellReuseIdentifier: toggleCellId)
        tableView.register(TableViewDescCell.self, forCellReuseIdentifier: descCellId)
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
    }
    
    func registerSettingsBundle() {
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    let tableSections = ["Seefood", "Version"]
    let tableContent = [["Limited Suggestions"],
                        ["Version"]]
    let toggleCellId = "toggleCell"
    let descCellId = "descCell"
    let sectionHeaderHeight: CGFloat = 30
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 18, y: 5, width: 200, height: 25))
        label.text = tableSections[section].uppercased()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: toggleCellId, for: indexPath) as! TableViewToggleCell
                cell.name = tableContent[section][row]
                return cell
            }
        case 1:
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: descCellId, for: indexPath) as! TableViewDescCell
                cell.name = tableContent[section][row]
                return cell
            }
        default:
            break
        }
        assert(false, "missing cell")
    }
}

class TableViewToggleCell: BaseTableViewCell {
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let toggle: UISwitch = {
        let toggle = UISwitch()
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: "limited_recipes") as! Bool {
            toggle.setOn(true, animated: false)
        } else {
            toggle.setOn(false, animated: false)
        }
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    override func setupViews() {
        self.addSubview(toggle)
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
            toggle.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            toggle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
            ])
        
        toggle.addTarget(self, action: #selector(toggled(sender:)), for: .valueChanged)
    }
    
    @objc func toggled(sender: UISwitch) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(sender.isOn, forKey: "limited_recipes")
    }
    
}

class TableViewDescCell: BaseTableViewCell {
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let userDefaults = UserDefaults.standard
        label.text = userDefaults.value(forKey: "version") as? String
        return label
    }()
    
    override func setupViews() {
        self.addSubview(versionLabel)
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
            
            versionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            versionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
            ])
    }
    
}
