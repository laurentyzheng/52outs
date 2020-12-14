//
//  SetSuitChange.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-10-25.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//

import UIKit

class SetSuitChange: UIViewController{
    
    
    private var SuitSwitchView: UISwitch = UISwitch(frame: .zero)
    private var VibrateSwitchView: UISwitch = UISwitch(frame: .zero)
    private var DurationSliderView: UISlider = UISlider(frame: CGRect(x: vc.ScreenHalfW() * 0.15, y:vc.ScreenHalfH() * 0.05, width: vc.ScreenHalfW()*1.7, height: 20))
    private var SectionView = UILabel (frame: CGRect(x: vc.ScreenHalfH() * 0.1, y: -25, width: 280, height: 40))
    private var DurationSecView = UILabel (frame: CGRect(x: vc.ScreenHalfH() * 0.7, y: -25, width: 60, height: 40))
    
    private let SuitFrame = UIView (frame: CGRect(x: vc.ScreenHalfW() * 0.25, y: vc.ScreenHalfH() * 0.15, width: vc.ScreenHalfW() * 1.5, height: vc.ScreenHalfW() * 1.5))
    private var UpperLeftFrame = UIImageView(image: #imageLiteral(resourceName: "UpperLeft Frame"))
    private var UpperRightFrame = UIImageView(image: #imageLiteral(resourceName: "UpperRight Frame"))
    private var LowerLeftFrame = UIImageView(image: #imageLiteral(resourceName: "LowerLeft Frame"))
    private var LowerRightFrame = UIImageView(image: #imageLiteral(resourceName: "LowerRight Frame"))
    
    private let HeartImage = UIImageView(image: #imageLiteral(resourceName: "Heart"))
    private let ClubImage = UIImageView(image: #imageLiteral(resourceName: "Club"))
    private let SpadesImage = UIImageView(image: #imageLiteral(resourceName: "Spades"))
    private let DiamondImage = UIImageView(image: #imageLiteral(resourceName: "Diamond"))
    
    
    private var frameArr: [UIImageView]{
        return [UpperLeftFrame, UpperRightFrame, LowerLeftFrame, LowerRightFrame]
    }
    
    private var suitDict: [String:UIImageView]{
        return ["H":HeartImage,
                "C":ClubImage,
                "S":SpadesImage,
                "D":DiamondImage]
    }
    
    private var tableView: UITableView!
    
    public let items: [String]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        hideViews()
        configureSuitFrame()
        arrangeSuit()
        SuitFrame.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(suitPan(_:))))
        // Do any additional setup after loading the view.
    }
    
    init(items: [String]){
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = vc.ScreenHalfH() * 0.14
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = tableColor
    }
    private func statusChange () {
        if Settings.defaults.bool(forKey: "allowChangeSuit"){
            SuitSwitchView.setOn(true, animated: true)
        } else {
            SuitSwitchView.setOn(false, animated: true)
        }
        if Settings.defaults.bool(forKey: "allowVibration"){
            VibrateSwitchView.setOn(true, animated: true)
        } else {
            VibrateSwitchView.setOn(false, animated: true)
        }
        DurationSliderView.setValue(Settings.defaults.float(forKey: "durationOfChangeSuit"), animated: true)
    }
    
    private func hideViews() {
        let hide = !(Settings.defaults.bool(forKey: "allowChangeSuit"))
        VibrateSwitchView.isHidden = hide
        DurationSliderView.isHidden = hide
        SectionView.isHidden = hide
        DurationSecView.isHidden = hide
    }
    
    private func configureSuitFrame () {
        let halfW = SuitFrame.frame.size.width / 2
        UpperLeftFrame.frame = CGRect(x: 0, y: 0, width: halfW-5, height: halfW-5)
        UpperRightFrame.frame = CGRect(x: halfW+5, y: 0, width: halfW-5, height: halfW-5)
        LowerLeftFrame.frame = CGRect(x: 0, y: halfW+5, width: halfW-5, height: halfW-5)
        LowerRightFrame.frame = CGRect(x: halfW+5, y: halfW+5, width: halfW-5, height: halfW-5)
        SuitFrame.addSubview(UpperLeftFrame)
        SuitFrame.addSubview(UpperRightFrame)
        SuitFrame.addSubview(LowerLeftFrame)
        SuitFrame.addSubview(LowerRightFrame)
    }
    
    
    private func centreSuit (frame: UIImageView, suit: UIImageView){
        suit.frame.size.width = frame.frame.size.width - 20
        suit.frame.size.height = frame.frame.size.height - 20
        suit.frame.origin.x = 10
        suit.frame.origin.y = 10
        frame.addSubview(suit)
    }
    
    var location = CGPoint()
    var suit = UIImageView()
    var frameSwitchTo = UIImageView()
    @objc func suitPan (_ recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            location = recognizer.location(in: SuitFrame)
            for i in 0...3 {
                if frameArr[i].frame.contains(location){
                    if let suitImage = frameArr[i].subviews[0] as? UIImageView {
                        suit = suitImage
                    } else {
                        break
                    }
                }
            }
            suit.frame.size.width += 20
            suit.frame.size.height += 20
            suit.alpha = 0.5
        case .changed:
            suit.transform = CGAffineTransform(translationX: recognizer.translation(in: self.view).x, y: recognizer.translation(in: self.view).y)
            for i in 0...3 {
                if frameArr[i].frame.contains(recognizer.location(in: SuitFrame)) && frameArr[i] != suit.superview{
                    frameArr[i].alpha = 0.5
                } else {
                    frameArr[i].alpha = 1
                }
            }
        case .ended:
            var allowSwitch = false
            for i in 0...3{
                if frameArr[i].alpha == 0.5{
                    frameSwitchTo = frameArr[i]
                    allowSwitch = true
                }
            }
            if allowSwitch {
                switchSuit(first: frameSwitchTo, second: suit.superview as! UIImageView)
            }
            frameSwitchTo.alpha = 1
            suit.frame.size.width -= 20
            suit.frame.size.height -= 20
            suit.alpha = 1
            suit.transform = .identity
            adjustSuitArrangement()
        default:
            ()
        }
        
    }
    
    private func arrangeSuit () {
        let suitArr = Settings.defaults.array(forKey: "suitArrangement")
        for i in 0...3 {
            let arrVal = suitArr![i] as! String
            centreSuit(frame: frameArr[i], suit: suitDict[arrVal]!)
        }
    }
    
    private func switchSuit (first: UIImageView, second: UIImageView){
        let firstImageView = (first.subviews[0] as? UIImageView)!
        let secondImageView = (second.subviews[0] as? UIImageView)!
        firstImageView.removeFromSuperview()
        secondImageView.removeFromSuperview()
        first.addSubview(secondImageView)
        second.addSubview(firstImageView)
    }
    
    private func adjustSuitArrangement (){
        var arr: [String] = []
        for i in 0...3{
            let suitImage = (frameArr[i].subviews[0] as? UIImageView)!
            let suitString = suitDict.key(forValue: suitImage)
            arr.append(suitString!)
        }
        Settings.defaults.setValue(arr, forKey: "suitArrangement")
    }

}

extension SetSuitChange: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return vc.ScreenHalfH() * 0.08
    }
    
    @objc func handleDurationChange (slider: UISlider){
        let sliderVal = Double (Int(slider.value * 10)) / 10
        DurationSecView.text = "\(sliderVal) sec"
        Settings.defaults.set(sliderVal, forKey: "durationOfChangeSuit")
    }
    
    @objc func handleSuitSwitch (mySwitch: UISwitch){
        Settings.defaults.set(mySwitch.isOn, forKey: "allowChangeSuit")
        VibrateSwitchView.isHidden = !(mySwitch.isOn)
        DurationSliderView.isHidden = !(mySwitch.isOn)
        SectionView.isHidden = !(mySwitch.isOn)
        DurationSecView.isHidden = !(mySwitch.isOn)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func handleVibrateSwitch (mySwitch: UISwitch){
        Settings.defaults.set(mySwitch.isOn, forKey: "allowVibration")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            if indexPath.row == 2 {
                return vc.ScreenHalfH() * 1.3
            } else {
                if !(SuitSwitchView.isOn){
                        return 0
                }
            }
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        statusChange()
        SuitSwitchView.addTarget(self, action: #selector(handleSuitSwitch(mySwitch:)), for: .valueChanged)
        DurationSliderView.maximumValue = 4
        DurationSliderView.addTarget(self, action: #selector(handleDurationChange(slider:)), for: .valueChanged)
        VibrateSwitchView.addTarget(self, action: #selector(handleVibrateSwitch(mySwitch:)), for: .valueChanged)
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        if indexPath.section == 0 {
            cell.accessoryView = SuitSwitchView
            cell.textLabel?.text = items[indexPath.row]
        } else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    SectionView.text = "Duration for Suit Change:"
                    SectionView.textColor = .white
                    SectionView.alpha = 0.8
                    SectionView.font = UIFont.systemFont(ofSize: 16.0)
                    DurationSecView.text = "\(DurationSliderView.value) sec"
                    DurationSecView.font = UIFont.systemFont(ofSize: 18.0)
                    DurationSecView.textColor = .white
                    cell.addSubview(SectionView)
                    cell.addSubview(DurationSecView)
                    cell.addSubview(DurationSliderView)
                } else if indexPath.row == 1 {
                    cell.accessoryView = VibrateSwitchView
                    cell.textLabel?.text = "Vibrate When Suit Changes"
                } else if indexPath.row == 2 {
                    let text = UILabel (frame: CGRect(x: vc.ScreenHalfW() * 0.1, y: vc.ScreenHalfH() * 0.03, width: 200, height: 40))
                    let instruction = UILabel (frame: CGRect(x: vc.ScreenHalfW() * 1.2, y: vc.ScreenHalfH() * 0.03, width: 200, height: 40))
                    instruction.text = "Drag to customize"
                    text.text = "Suit Arrangement"
                    text.textColor = .white
                    text.font = UIFont.systemFont(ofSize: 19)
                    instruction.font = UIFont(name: "Gillsans", size: 17)
                    instruction.textColor = .white
                    cell.addSubview(text)
                    cell.addSubview(instruction)
                    cell.addSubview(SuitFrame)
                }
        }
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .white
        cell.backgroundColor = tableColor
        return cell
    }
    
}
 
extension Dictionary where Value: Equatable {
    func key(forValue value: Value) -> Key? {
        return first { $0.1 == value }?.0
    }
}
