//
//  SettingsModel.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-10-18.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//
import UIKit

class SettingsCell: UITableViewCell {
    
    // MARK: - Properties
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Screen
    case Performance
    
    var description: String {
        switch  self {
        case .Screen:
            return "Screen"
        case .Performance:
            return "Performance"
        }
    }
    
}

enum ScreenOptions: Int, CaseIterable, CustomStringConvertible {
    case Background
    case DefaultStart
    case ExitApp
    
    var description: String {
        switch  self {
        case .Background:
            return "Performance Background"
        case .DefaultStart:
            return "Start trick when app launches"
        case .ExitApp:
            return "Exit app when trick ends"
        }
    }
    func action (_ VC: UIViewController) {
        switch self {
            case .Background:
                imagePicker.shared.showActionSheet(vc: VC)
            default:
                break
        }
    }
    
}

enum PerformanceOptions: Int, CaseIterable, CustomStringConvertible {
    case ChangeValue

    
    var description: String {
        switch  self {
        case .ChangeValue:
            return "Customize Suit Change"
        }
    }
    var list: [String] {
        switch self {
        case .ChangeValue:
            return ["Enable Suit Change Feature"]
        }
    }
    
    func pushToNavigator (_ list: [String], _ description: String, _ controller: UIViewController) {
        switch self {
        case .ChangeValue:
            let vc = SetSuitChange(items: list)
            vc.title = description
            controller.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



