//
//  PerformaceStart.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-09-19.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//
import UIKit
import SpriteKit
import AudioToolbox

var FullCard = SKSpriteNode()

var FullCardReady = Bool()

class PerformanceStart: UIViewController, UIGestureRecognizerDelegate{
    
    var finalCard: UIImage!
    
    var tempBack: UIImage!
    
    var hasBegun: Bool = false
    
    var valOfturn: Int = 0
    
    var orientation: String = String()
    
    var rotCorner: UIImageView!
    var satCorner: UIImageView!
    var rotHalf: UIImageView!
    var satHalf: UIImageView!
    
    var animator = UIViewPropertyAnimator()
    
    var zero: UIView = UIView()
    var one: UIView = UIView()
    var two: UIView = UIView()
    var three: UIView = UIView()
    
    var swipeViews : [UIView] = []

    var swipes : [FirstSwipe] = []
    
    override func loadView() {
        self.view = SKView()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        GoToStartTrick()
        AddSwipesToView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let scene = PerformCardTrick()
    
    private func GoToStartTrick(){
        let view = self.view as! SKView?
        view!.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.size = view!.bounds.size
        view!.presentScene(scene)
    }

    
    private func AddSwipesToView(){
        swipeViews = [zero,one,two,three]
        zero.frame = CGRect(x: 0, y: 0, width: vc.ScreenHalfW(), height: vc.ScreenHalfH())
        one.frame =  CGRect(x: vc.ScreenHalfW(), y: 0, width: vc.ScreenHalfW(), height: vc.ScreenHalfH())
        two.frame =  CGRect(x: 0, y: vc.ScreenHalfH(), width: vc.ScreenHalfW(), height: vc.ScreenHalfH())
        three.frame = CGRect(x: vc.ScreenHalfW(), y: vc.ScreenHalfH(), width: vc.ScreenHalfW(), height: vc.ScreenHalfH())
        for n in 0...7 {
            swipes.insert(FirstSwipe(target: self, action: #selector (self.FirstOpen)), at: n)
            swipes[n].type = n
            swipes[n].maximumNumberOfTouches = 1
            swipes[n].minimumNumberOfTouches = 1
            if n < 4{
                swipeViews[n].addGestureRecognizer(swipes[n])
                self.view.addSubview(swipeViews[n])
            } else {
                swipes[n].delegate = self
                swipeViews[n-4].addGestureRecognizer(swipes[n])
            }
        }
    }
    
    @objc func FirstOpen(_ recognizer: FirstSwipe){
        let val = recognizer.type
        switch recognizer.state {
            case .began:
                ClearRecognizers(except: recognizer.view)
                SetUpCorner(val)
                FoldedCard.removeFromParent()
                self.view.addSubview(satCorner)
                self.view.addSubview(rotCorner)
                self.animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeOut, animations: {
                    if val < 4{
                        if val % 2 == 0 {self.rotCorner.layer.transform = CATransform3DRotate(self.RotateHorV(true), .pi, 0, 1, 0)
                        } else {self.rotCorner.layer.transform = self.RotateHorV(true)}
                    } else {
                        if val >= 6{self.rotCorner.layer.transform = CATransform3DRotate(self.RotateHorV(false), .pi, 1, 0, 0)
                        } else {self.rotCorner.layer.transform = self.RotateHorV(false)}
                    }
                })
                self.animator.startAnimation()
                self.animator.pauseAnimation()
            case .changed:
                if val < 4{
                    self.animator.fractionComplete = recognizer.translation(in: rotCorner).x / 300
                } else {
                    self.animator.fractionComplete = recognizer.translation(in: rotCorner).y / -440
                }
            case .ended:
                if self.animator.fractionComplete < 0.5 {
                    self.animator.isReversed = true
                    self.animator.pauseAnimation()
                    self.animator.startAnimation()
                    self.animator.addCompletion{  position in
                        if position == .start{
                            self.satCorner.removeFromSuperview()
                            self.rotCorner.removeFromSuperview()
                            self.scene.addChild(FoldedCard)
                            FoldedCard.physicsBody!.mass = 0.05
                            self.ClearRecognizers(except: nil)
                            self.AddSwipesToView()
                        }
                    }
                } else {
                    self.ClearRecognizers(except: nil)
                    self.animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                    self.animator.addCompletion{position in
                        if position == .end {self.firstSwipeDone(val)}}
                }
            default: ()
        }
    }
    
    @objc private func SecondOpen (_ recognizer: SecondSwipe){
        if recognizer.add == true && hasBegun == false {
            Card.value += 8
        }
        switch recognizer.state{
        case .began:
            SetUpHalves()
            for view in self.view.subviews {
                if view != zero && view != two && view != three && view != one {
                view.removeFromSuperview()
                }
            }
            //ClearRecognizers(except: recognizer.view)
            self.view.addSubview(satHalf)
            self.view.addSubview(rotHalf)
            hasBegun = true
            animator = UIViewPropertyAnimator (duration: 1.5, curve: .easeOut, animations: {
                if self.orientation == "T" {
                    self.rotHalf.layer.transform = self.RotateHorV(false)
                } else if self.orientation == "B"{
                    self.rotHalf.layer.transform = CATransform3DRotate(self.RotateHorV(false), .pi, 1, 0, 0)
                } else if self.orientation == "L" {
                    self.rotHalf.layer.transform = CATransform3DRotate(self.RotateHorV(true), .pi, 0, 1, 0)
                } else {
                    self.rotHalf.layer.transform = self.RotateHorV(true)
                }
            })
            self.animator.startAnimation()
            self.animator.pauseAnimation()
        case .changed:
            if self.orientation == "T" || self.orientation == "B"{
                self.animator.fractionComplete = recognizer.translation(in: rotHalf).y / -440
            } else {
                self.animator.fractionComplete = recognizer.translation(in: rotHalf).x / 300
            }
            if self.animator.fractionComplete > 0.5{
                self.MatchRotHalfImage()
                self.satHalf.contentMode = .scaleAspectFill
            } else {
                self.rotHalf.image = self.tempBack
                satHalf.contentMode = .scaleAspectFit
            }
            
        case .ended:
            if self.animator.fractionComplete < 0.5 {
                self.animator.isReversed = true
                self.animator.pauseAnimation()
                self.animator.startAnimation()
            } else {
                self.animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                self.ClearRecognizers(except: nil)
            }
            self.animator.addCompletion{position in
                if position == .end {self.cardOpened()}}
        default:()
        }
    }
    
    
    private func SetUpCorner (_ val: Int){
        let cardQuarters = Quarter(val, w: Card.W/2, h: Card.H/2, color: Settings.defaults.string(forKey: "cardColour")!)
        rotCorner = cardQuarters.rotating
        satCorner = cardQuarters.stationary
        rotCorner.contentMode = .scaleAspectFill
        satCorner.contentMode = .scaleAspectFill
    }
    
    private func SetUpHalves () {
        let cardImage = UIImage(named: Card.chosenCard)
        finalCard = cardImage
        let CardHalf = Half(orientation, front: (cardImage)!, valOfturn: self.valOfturn, color: Settings.defaults.string(forKey: "cardColour")!)
        satHalf = CardHalf.stationary
        rotHalf = CardHalf.rotating
        tempBack = rotHalf.image
        satHalf.contentMode = .scaleAspectFit
        rotHalf.contentMode = .scaleAspectFill
    }
    
    
    func RotateHorV(_ HorV: Bool) -> CATransform3D{
        var rotate = CATransform3DIdentity
        rotate.m34 = 1.0 / -900
        
        if HorV == true {
            rotate = CATransform3DRotate(rotate, .pi, 0, 1, 0)
        } else {
            rotate = CATransform3DRotate(rotate, .pi, 1, 0, 0)
        }
        return rotate
    }
    
    func ClearRecognizers (except: UIView? = nil) {
        for n in 0...3 {
            if let recognizers = self.swipeViews[n].gestureRecognizers {
                for recognizer in recognizers {
                    if swipeViews[n] != except {
                        self.swipeViews[n].removeGestureRecognizer(recognizer)
                    }
                }
            }
        }
    }
    
    func MatchRotHalfImage (){
        if orientation == "T" {
            let imageIdentity = finalCard.bottomHalf
            rotHalf.image = UIImage(cgImage: (imageIdentity?.cgImage)!, scale: (imageIdentity?.scale)!, orientation: .downMirrored)
        } else if orientation == "B"{
            rotHalf.image = finalCard.topHalf
        } else if orientation == "L"{
            rotHalf.image = finalCard.rightHalf
        } else {
            rotHalf.image = finalCard.leftHalf?.withHorizontallyFlippedOrientation()
        }
    }
    
    func firstSwipeDone (_ val: Int){
        valOfturn = val
        let secondSwipe = SecondSwipe(target: self, action: #selector (self.SecondOpen))
        secondSwipe.add = false
        secondSwipe.maximumNumberOfTouches = 1
        let secondSwipeAdd = SecondSwipe(target: self, action: #selector (self.SecondOpen))
        secondSwipeAdd.maximumNumberOfTouches = 1
        secondSwipeAdd.add = true
        if val == 0 || val == 1 {
            orientation = "T"
            zero.addGestureRecognizer(secondSwipe)
            one.addGestureRecognizer(secondSwipeAdd)
        } else if val == 2 || val == 3 {
            orientation = "B"
            two.addGestureRecognizer(secondSwipeAdd)
            three.addGestureRecognizer(secondSwipe)
        } else if val == 4 || val == 6 {
            orientation = "L"
            zero.addGestureRecognizer(secondSwipeAdd)
            two.addGestureRecognizer(secondSwipe)
        } else {orientation = "R"
            one.addGestureRecognizer(secondSwipe)
            three.addGestureRecognizer(secondSwipeAdd)
        }
        Card.value = val
    }
    
    func cardOpened (){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        FullCard = SKSpriteNode(texture: SKTexture(image: finalCard))
        FullCard.size = CGSize(width: Card.W, height: Card.H)
        FullCard.position = CGPoint (x: vc.ScreenHalfW() , y: vc.ScreenHalfH())
        FullCard.physicsBody = SKPhysicsBody(rectangleOf: FullCard.size)
        FullCard.physicsBody!.allowsRotation = false
        FullCard.physicsBody!.affectedByGravity = false
        FullCard.physicsBody!.mass = 0.01
        FullCard.physicsBody!.linearDamping = 0
        scene.addChild(FullCard)
        FullCardReady = true
        let pinchForCardToDissapear = UIPinchGestureRecognizer(target: self, action:  #selector(self.handlePinch(_:)))
        self.view.addGestureRecognizer(pinchForCardToDissapear)
    }
    
    
    @objc func handlePinch (_ recognizer: UIPinchGestureRecognizer){
        var action: SKAction!
        action = SKAction.fadeAlpha(to: 0, duration: 0.3)
        
        if recognizer.state == .changed {
            FullCard.alpha = recognizer.scale
        } else if recognizer.state == .ended {
            if let recognizers = self.view.gestureRecognizers {
                for recognizer in recognizers {
                    self.view.removeGestureRecognizer(recognizer)
                }
            }
            action.timingMode = .easeOut
            FullCard.run(action, completion: {
                FullCardReady = false
                FullCard.removeFromParent()
                self.scene.removeFromParent()
                self.dismiss(animated: false, completion: {
                    Card.value = 0
                    Card.suit = ""
                    if Settings.defaults.bool(forKey: "exitWhenFinish"){
                        exit(69)
                    }
                })
            })
        }
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGesture.velocity(in: panGesture.view)
            return abs(velocity.y) > abs(velocity.x)
        }
        return true
    }
}


