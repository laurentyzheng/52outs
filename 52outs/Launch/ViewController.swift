//
//  ViewController.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-09-18.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//

import UIKit
import SpriteKit

/**
 View Controller of Home Page
 - Sets all buttons  and  button objc functions
 */


class ViewController: UIViewController {
    
    public func ScreenHalfW() -> CGFloat{
        return (self.view.safeAreaLayoutGuide.layoutFrame.size.width)/2
    } // (width of screen)/2
    public func ScreenHalfH() -> CGFloat {
        return (self.view.safeAreaLayoutGuide.layoutFrame.size.height)/2
    }// (height of screen)/2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackGround()
        setButton()
        // background for the first page
    }
    
    func setBackGround () {
        let bckg = CAGradientLayer()
        bckg.frame = view.bounds
        bckg.startPoint = CGPoint(x: 0, y: 0)
        bckg.endPoint = CGPoint(x: 1, y: 1)
        let grey = UIColor(red: 20/255, green: 30/255, blue: 30/255, alpha: 1.0)
        bckg.colors = [grey.cgColor, UIColor.white.cgColor]
        view.layer.insertSublayer(bckg, at: 0)
        let front = UIImageView(image: #imageLiteral(resourceName: "Front"))
        let w = ScreenHalfW() * 2
        front.frame =  CGRect(x: ScreenHalfW() - w/2, y: ScreenHalfH() - w/1.5, width: w, height: w)
        self.view.addSubview(front)
    }
    
    private func setButton (){
        let w = ScreenHalfW()
        let h = w/3
        launchButton.frame = CGRect (x: ScreenHalfW() - w/2, y: ScreenHalfH() * 1.4, width: w, height: h)
        secretButton.frame = CGRect (x: ScreenHalfW() - w/2, y: ScreenHalfH() * 1.4 + h + 15, width: w, height: h)
        settingsButton.frame = CGRect (x: ScreenHalfW()/5, y: ScreenHalfH()/7.5, width: ScreenHalfW()/4, height: ScreenHalfW()/4)
        self.view.addSubview(settingsButton)
        self.view.addSubview(launchButton)
        self.view.addSubview(secretButton)
    }
    
    private let settingsButton: UIButton = {
        let settings = #imageLiteral(resourceName: "setting button")
        let Button = UIButton()
        Button.setImage(settings, for: .normal)
        Button.addTarget(self, action: #selector(PressedSettings(_:)), for: .touchUpInside)
        return Button
    }()
    
    private let launchButton: UIButton = {
       let button = UIButton.init(type: .roundedRect)
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.setTitle("Start Trick", for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(PressedStart (_:)), for: .touchUpInside)
        return button
    }()
    
    private let secretButton: UIButton = {
        let button = UIButton.init(type: .roundedRect)
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 15
        button.setTitle("Learn Secret", for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(PressedSecret(_:)), for: .touchUpInside)
        return button
    } ()
    
    @objc private func PressedSecret (_: UIButton){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let nextView = SwipingController(collectionViewLayout: layout)
        nextView.modalTransitionStyle = .coverVertical
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated:true, completion: nil)
    }
    
    @objc private func PressedStart (_: UIButton){
        let nextView = PerformanceReady()
        nextView.modalTransitionStyle = .crossDissolve
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated:true, completion: nil)
    }
    @objc private func PressedSettings (_: UIButton){
        let settingsPage = Settings()
        let settingsNavigator = UINavigationController(rootViewController: settingsPage)
        show(settingsNavigator, sender: self)
    }
}
