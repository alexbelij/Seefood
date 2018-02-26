//
//  SettingsViewController.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/19/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        if let nav = navigationController?.navigationBar {
            nav.prefersLargeTitles = false
            nav.barTintColor = .white
            nav.tintColor = Constants.Colors().secondaryColor
            nav.isTranslucent = true
            self.title = "Settings"
        }
        setupNavBarButtons()
        setupViews()
    }
    
    func setupNavBarButtons() {
        //self.navigationItem.hidesBackButton = true
        let closeButtonImage = UIImage(named: "ic_close_white")?.withRenderingMode(.alwaysTemplate)
        let closeButton = UIButton()
        closeButton.contentMode = .scaleAspectFill
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTouchUpInside(sender:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let searchBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.setLeftBarButton(searchBarButtonItem, animated: true)
    }

    lazy var settingsTableViewController: SettingsTableViewController = {
        let vc = SettingsTableViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    func setupViews() {
        let containerView: UIView? = view
        addChildViewController(settingsTableViewController)
        containerView?.addSubview(settingsTableViewController.view)
        settingsTableViewController.didMove(toParentViewController: self)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": settingsTableViewController.view]) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: [], metrics: nil, views: ["v0": settingsTableViewController.view])
        )
    }
    
    @objc func closeButtonTouchUpInside(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
        let label = UILabel()
        label.text = tableSections[section]
        label.backgroundColor = .lightGray
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            
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
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            
            versionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            versionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
            ])
        
    }
    
}







