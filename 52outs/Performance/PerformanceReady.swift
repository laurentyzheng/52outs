//
//  PerformanceReady.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-09-19.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//
import UIKit

class PerformanceReady: UIViewController {
    
    var suitArray: [String] = Settings.defaults.object(forKey: "suitArrangement") as? [String] ?? [String]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.addSubview(UpperLeft)
        self.view.addSubview(UpperRight)
        self.view.addSubview(LowerLeft)
        self.view.addSubview(LowerRight)
        // initializing the four (invisible) buttons that will determine the suit of the card
        let ExitPerformance = UIPanGestureRecognizer (target: self, action: #selector(ExitingPerfomance(sender:)))
        self.view.addGestureRecognizer(ExitPerformance)
        SetUpBackground()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func SetUpBackground (){
        if Settings.defaults.bool(forKey: "defaultBlackScreen"){
            self.view.backgroundColor = .black
        } else {
            let imageURL = Settings.defaults.url(forKey: "backgroundImagePath")!
            let bckgImage = imageHandler().fetchImage(url: imageURL)
            let bckg = UIImageView(image: bckgImage)
                bckg.frame = view.bounds
                bckg.contentMode = .scaleToFill
                view.insertSubview(bckg, at: 0)
        }
    }
    
    private let UpperLeft: UIButton = {
        let button = UIButton (frame: CGRect(x: 0, y: 0, width: vc.ScreenHalfW(), height: vc.ScreenHalfH()))
        button.addTarget(self,action: #selector(handleUpperLeft), for: .touchUpInside)
        button.isExclusiveTouch = true
        return button
    }()
    
    private let UpperRight: UIButton = {
        let button = UIButton (frame: CGRect(x: vc.ScreenHalfW(), y: 0, width: vc.ScreenHalfW(), height: vc.ScreenHalfH()))
        button.addTarget(self,action: #selector(handleUpperRight), for: .touchUpInside)
        button.isExclusiveTouch = true
        return button
    }()
    
    private let LowerLeft: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: vc.ScreenHalfH(), width: vc.ScreenHalfW(), height: vc.ScreenHalfH()))
        button.addTarget(self,action: #selector(handleLowerLeft), for: .touchUpInside)
        button.isExclusiveTouch = true
        return button
    }()
    
    private let LowerRight: UIButton = {
        let button = UIButton(frame: CGRect(x: vc.ScreenHalfW(), y: vc.ScreenHalfH(), width: vc.ScreenHalfW(), height: vc.ScreenHalfH()))
        button.addTarget(self,action: #selector(handleLowerRight), for: .touchUpInside)
        button.isExclusiveTouch = true
        return button
    }()
    
    @objc func handleUpperLeft() {
        let nextView = PerformanceStart()
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated: false, completion: {Card.suit = self.suitArray[0]})
    }
    @objc func handleUpperRight() {
        let nextView = PerformanceStart()
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated: false, completion: {Card.suit = self.suitArray[1]})
    }
    @objc func handleLowerLeft() {
        let nextView = PerformanceStart()
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated: false, completion: {Card.suit = self.suitArray[2]})
    }
    @objc func handleLowerRight() {
        let nextView = PerformanceStart()
        nextView.modalPresentationStyle = .fullScreen
        self.present(nextView, animated: false, completion: {Card.suit = self.suitArray[3]})
    }// Card Appears for any button, the value of the suit is stored for the later usage.
    
    
    @objc private func ExitingPerfomance( sender: UIPanGestureRecognizer) {
        if sender.numberOfTouches > 1 && sender.velocity(in: self.view).y > 0{
            if Settings.defaults.bool(forKey: "startOnLaunch"){
                let prevView = ViewController()
                prevView.modalTransitionStyle = .crossDissolve
                prevView.modalPresentationStyle = .fullScreen
                self.present(prevView, animated:true, completion: nil)
            } else {
                self.view?.window?.rootViewController = ViewController()
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }//exit performance screen when pinched
    }
    
}
