//
//  Settings.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-10-11.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//

import UIKit
private var status: UILabel = UILabel(frame: CGRect(x: vc.ScreenHalfW() * 1.6, y: 0, width: 60, height: vc.ScreenHalfH() * 0.14))
public let tableColor = UIColor(red: 30/255, green: 30/255, blue: 40/255, alpha: 1.0)

let vc = ViewController()

class Settings: UIViewController {
    
    public static var defaults = UserDefaults.standard
    
    private var launchSwitch: UISwitch = {
        let Switch = UISwitch(frame: .zero)
        Switch.addTarget(self, action: #selector(handleLaunchSwitch(mySwitch:)), for: .valueChanged)
        return Switch
    }()
    
    private var exitSwitch: UISwitch = {
        let Switch = UISwitch(frame: .zero)
        Switch.addTarget(self, action: #selector(handleExitSwitch(mySwitch:)), for: .valueChanged)
        return Switch
    }()
    
    private var redButton: UIButton = {
        let button = UIButton.init(type: .roundedRect)
        button.frame = CGRect(x: vc.ScreenHalfW()*0.4 - 10, y: vc.ScreenHalfW() * 1.4 + 40, width: vc.ScreenHalfW()*0.6, height: vc.ScreenHalfW()*0.25)
        button.backgroundColor = .red
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRedBtn(_:)), for: .touchDown)
        return button
    } ()
    private var blueButton: UIButton = {
        let button = UIButton.init(type: .roundedRect)
        button.frame = CGRect(x: vc.ScreenHalfW() + 10, y: vc.ScreenHalfW() * 1.4 + 40, width: vc.ScreenHalfW()*0.6, height: vc.ScreenHalfW()*0.25)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleBlueBtn(_:)), for: .touchDown)
        return button
    } ()
    
    private var cardView: UIImageView = {
        let view = UIImageView()
        let width = vc.ScreenHalfW() * 0.9
        let height = width * 1.4
        view.frame = CGRect (x: vc.ScreenHalfW() - width/2, y: 30, width: width, height: height)
        return view
    }()
    // MARK: - Properties
    
    private var tableView: UITableView {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        table.frame = view.frame
        table.tableFooterView = UIView()
        table.backgroundColor = tableColor
        return table
    }
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        addBar()
    }
    
    @objc func handleClosed () {
     self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleBackToDefault () {
        let alert = UIAlertController(title: "Reset", message: "Do you want to reset all settings back to default?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.setAllToDefault()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    // MARK: - Helper Functions
    
    private func addBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationItem.title = "Settings"
        let close = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(handleClosed))
        let defaultRefresher = UIBarButtonItem(barButtonSystemItem: .refresh ,target: self, action: #selector(handleBackToDefault))
        close.tintColor = UIColor(red: 204/255, green: 241/255, blue: 255/255, alpha: 1)
        defaultRefresher.tintColor = .white
        navigationItem.rightBarButtonItem = close
        navigationItem.leftBarButtonItem = defaultRefresher
    }
    
    public func statusChange () {
        if Settings.defaults.bool(forKey: "defaultBlackScreen"){
            status.text = "Default"
        } else {
            status.text = "Seleted"
        }
        if Settings.defaults.bool(forKey: "startOnLaunch"){
            launchSwitch.setOn(true, animated: true)
        } else {
            launchSwitch.setOn(false, animated: true)
        }
        if Settings.defaults.bool(forKey: "exitWhenFinish"){
            exitSwitch.setOn(true, animated: true)
        } else {
            exitSwitch.setOn(false, animated: true)
        }
        if Settings.defaults.string(forKey: "cardColour") == "Red" {
            setToRed()
        } else {
            setToBlue()
        }
    }
    
    public func setAllToDefault(){
        Settings.defaults.set(true, forKey: "haveInstalled")
        Settings.defaults.set(true, forKey: "defaultBlackScreen")
        Settings.defaults.set(nil, forKey: "backgroundImagePath")
        Settings.defaults.set(false, forKey: "startOnLaunch")
        Settings.defaults.set(true, forKey: "allowChangeSuit")
        Settings.defaults.set(true, forKey: "allowVibration")
        Settings.defaults.set(1.5, forKey: "durationOfChangeSuit")
        Settings.defaults.set(["H", "C", "S", "D"], forKey: "suitArrangement")
        Settings.defaults.set("Red", forKey: "cardColour")
        Settings.defaults.set("false", forKey: "exitWhenFinish")
        statusChange()
    }
        
    @objc func handleRedBtn (_: UIButton) {
        Settings.defaults.set("Red", forKey: "cardColour")
        setToRed()
        
    }
    
    @objc func handleBlueBtn (_: UIButton) {
        Settings.defaults.set("Blue", forKey: "cardColour")
        setToBlue()
    }
    
    private func setToRed () {
        cardView.image = #imageLiteral(resourceName: "FoldedCard")
        redButton.alpha = 1
        redButton.layer.shadowRadius = 1
        redButton.layer.shadowColor = UIColor.white.cgColor
        redButton.layer.shadowOpacity = 0.5
        blueButton.alpha = 0.5
        blueButton.layer.shadowOpacity = 0
    }
    
    private func setToBlue () {
        cardView.image = #imageLiteral(resourceName: "BlueFolded")
        blueButton.alpha = 1
        blueButton.layer.shadowRadius = 1
        blueButton.layer.shadowColor = UIColor.white.cgColor
        blueButton.layer.shadowOpacity = 0.5
        redButton.alpha = 0.5
        redButton.layer.shadowOpacity = 0
    }
}

extension Settings: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return ScreenOptions.allCases.count
            case 1: return PerformanceOptions.allCases.count + 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return vc.ScreenHalfH() * 0.05
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            return vc.ScreenHalfH()
        }
        return vc.ScreenHalfH() * 0.14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        switch indexPath.section {
        case 0:
            statusChange()
            status.textColor = .init(white: 1, alpha: 0.5)
            let ScreenOpt = ScreenOptions(rawValue: indexPath.row)
            cell.textLabel?.text = ScreenOpt?.description
            if indexPath.row == 0 {
                cell.addSubview(status)
            } else if indexPath.row == 1 {
                launchSwitch.tag = indexPath.row // for detect which row switch Changed
                cell.accessoryView = launchSwitch
                cell.selectionStyle = .none
            } else {
                cell.accessoryView = exitSwitch
                cell.selectionStyle = .none
            }
        case 1:
            if indexPath.row == 0{
                let PerformanceOpt = PerformanceOptions(rawValue: indexPath.row)
                cell.textLabel?.text = PerformanceOpt?.description
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = UIColor.white
            } else {
                cell.addSubview(cardView)
                cell.addSubview(redButton)
                cell.addSubview(blueButton)
            }
        default:
            break
        }
        cell.textLabel?.textColor = .white
        cell.backgroundColor = tableColor
        return cell
    }
    
    @objc func handleExitSwitch (mySwitch: UISwitch){
        Settings.defaults.set(mySwitch.isOn, forKey: "exitWhenFinish")
    }
    
    @objc func handleLaunchSwitch (mySwitch: UISwitch){
        Settings.defaults.set(mySwitch.isOn, forKey: "startOnLaunch")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                let ScreenOpt = ScreenOptions(rawValue: indexPath.row)
                ScreenOpt?.action(self)
            case 1:
                let PerformanceOpt = PerformanceOptions(rawValue: indexPath.row)
                let list = PerformanceOpt?.list
                let title = "Customize"
                PerformanceOpt?.pushToNavigator(list!, title, self)
        default:
            break
        }
        if let index = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
}


