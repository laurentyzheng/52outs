//
//  CardAppear.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-09-18.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//
import UIKit
import SpriteKit
import CoreMotion
import AudioToolbox

var FoldedCard = SKSpriteNode()

class PerformCardTrick: SKScene, SKPhysicsContactDelegate{
    
    let Bot = SKSpriteNode()
    let Top = SKSpriteNode()
    let Left = SKSpriteNode()
    let Right = SKSpriteNode()
    
    let bckg = SKSpriteNode()
    
    var suitArray: [String] = Settings.defaults.object(forKey: "suitArrangement") as? [String] ?? [String]()
    
    let motionManager = CMMotionManager()
    
    var physicalW: Float = 200
    var FoldedCardW: CGFloat{
        return CGFloat(physicalW)
    }
    var FoldedCardH: CGFloat{
        return FoldedCardW * 1.39
    }
    
    
    
    final var TopRight: CGPoint{
        return CGPoint(x: vc.ScreenHalfW()*2 - FoldedCardW/2, y: vc.ScreenHalfH()*2 - FoldedCardH/2 )
    }
    final var TopLeft: CGPoint{
        return CGPoint(x: FoldedCardW/2, y: vc.ScreenHalfH()*2 - FoldedCardH/2 )
    }
    final var BotRight: CGPoint{
        return CGPoint(x: vc.ScreenHalfW()*2 - FoldedCardW/2, y: FoldedCardH/2)
    }
    final var BotLeft: CGPoint{
        return CGPoint(x: FoldedCardW/2, y: FoldedCardH/2)
    }
    
    var touched: Bool = false
    var stopUserMotion: Bool = false
    
    func endRoutine () {
        FullCard.removeFromParent()
        self.removeFromParent()
        self.view?.window?.rootViewController = PerformanceReady ()
        self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
        Card.value = 0
        Card.suit = ""
        if Settings.defaults.bool(forKey: "exitWhenFinish"){
            exit(69)
        }
    }
    
    override func didMove(to view: SKView){
        super.didMove(to: view)
        AddWalls()
        SpawnMovingCard()
        motionManager.startAccelerometerUpdates()
        setBackground()
    }
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {
            // ignore
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location =  touch.location(in: self.view)
            let x = location.x
            let y = vc.ScreenHalfH()*2 - location.y
            let touchLocation = CGPoint(x: x, y: y)
            if FullCard.contains(touchLocation){
                if touchLocation.y > vc.ScreenHalfH()*2 - 10 || touchLocation.y < 10 || touchLocation.x < 10 || touchLocation.x > vc.ScreenHalfW()*2 - 10 {
                    endRoutine()
                } else {
                    AddWalls()
                }
            }
        }
        // Stop node from moving to touch
        touched = false
        stopUserMotion = false
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        let w : CGFloat = 101
        let h = w * 1.39
        let location = touch.location(in: self)
        var action: [SKAction]
        var moveAction: SKAction
        
        if location.x <= vc.ScreenHalfW() && location.y >=  vc.ScreenHalfH() { //topleft
            action = [SKAction.move(to: CGPoint(x: vc.ScreenHalfW() - w, y: vc.ScreenHalfH() + h), duration:(0.3)), SKAction.scaleX(to: -1, duration: 0.3),
                SKAction.scaleY(to: 1, duration: 0.3),]
        } else if location.x >= vc.ScreenHalfW() && location.y >=  vc.ScreenHalfH() {//topright
            action = [SKAction.move(to: CGPoint(x: vc.ScreenHalfW() + w, y: vc.ScreenHalfH() + h), duration:(0.3)),
                SKAction.scaleX(to: 1, duration: 0.3),
                SKAction.scaleY(to: 1, duration: 0.3),]
        } else if location.x <= vc.ScreenHalfW() && location.y <=  vc.ScreenHalfH() {//botleft
            action = [SKAction.move(to: CGPoint(x: vc.ScreenHalfW() - w, y: vc.ScreenHalfH() - h), duration:(0.3)),
                SKAction.scaleX(to: -1, duration: 0.3),
                SKAction.scaleY(to: -1, duration: 0.3),]
            FoldedCard.physicsBody?.isDynamic = false
        } else {//botright
            action = [SKAction.move(to: CGPoint(x: vc.ScreenHalfW() + w, y: vc.ScreenHalfH() - h), duration:(0.3)),
                SKAction.scaleX(to: 1, duration: 0.3),
                SKAction.scaleY(to: -1, duration: 0.3),]
        }
        moveAction = SKAction.group(action)
        moveAction.timingMode = .easeOut
        FoldedCard.run(moveAction)
        
        touched = true
        
        for touch in touches {
            let location =  touch.location(in: self.view)
            let x = location.x
            let y = vc.ScreenHalfH()*2 - location.y
            let touchLocation = CGPoint(x: x, y: y)
            
            if FullCard.contains(touchLocation){
                stopUserMotion = true
                previousLocation = touchLocation
            }
        }
        
        
    }
    
    var previousLocation = CGPoint()
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location =  touch.location(in: self.view)
            let x = location.x
            let y = vc.ScreenHalfH()*2 - location.y
            let touchLocation = CGPoint(x: x, y: y)
            if FullCard.contains(touchLocation){
                Bot.removeFromParent()
                Top.removeFromParent()
                Left.removeFromParent()
                Right.removeFromParent()
                let diffX = x - previousLocation.x
                let diffY = y - previousLocation.y
                let FullCardAction = SKAction.move(by: CGVector(dx: diffX, dy: diffY), duration: 0)
                FullCard.run(FullCardAction)
                previousLocation = touchLocation
            }
        }
    }

    
    override func  update(_ currentTime: TimeInterval) {
        if !(intersects(FullCard)) && self.contains(FullCard) {
            endRoutine()
        }
        processUserMotion(forUpdate: currentTime, node: FoldedCard)
        if FullCardReady{
            processUserMotion(forUpdate: currentTime, node: FullCard)
        }
        if Settings.defaults.bool(forKey:"allowChangeSuit"){
            ChangeSuit()
        }
        FoldedCard.physicsBody?.isDynamic = !touched
        FullCard.physicsBody?.isDynamic = !stopUserMotion
    }
    
    func setBackground () {
        if Settings.defaults.bool(forKey: "defaultBlackScreen"){
            self.backgroundColor = .black
        } else {
            let imageURL = Settings.defaults.url(forKey: "backgroundImagePath")!
            let bckgImage = imageHandler().fetchImage(url: imageURL)
            bckg.texture = .init (image: bckgImage)
            bckg.position = CGPoint(x: vc.ScreenHalfW(), y: vc.ScreenHalfH())
            bckg.zPosition = -1
            bckg.size = CGSize(width: vc.ScreenHalfW()*2, height: vc.ScreenHalfH()*2)
            addChild(bckg)
        }
    }
    
    func SpawnMovingCard() {
        if Settings.defaults.string(forKey: "cardColour") == "Red"{
            FoldedCard = SKSpriteNode(imageNamed: "FoldedCard")
        } else {
            FoldedCard = SKSpriteNode(imageNamed: "BlueFolded")
        }
        FoldedCard.size.width = FoldedCardW
        FoldedCard.size.height = FoldedCardH
        FoldedCard.position = CGPoint (x: vc.ScreenHalfW() , y: vc.ScreenHalfH()) // Set to centre
        FoldedCard.physicsBody = SKPhysicsBody (rectangleOf: CGSize (width: FoldedCardW, height: FoldedCardH))
        FoldedCard.physicsBody!.allowsRotation = false
        FoldedCard.physicsBody!.affectedByGravity = false
        FoldedCard.physicsBody!.mass = 0.05
        addChild(FoldedCard)
    }
    
    func processUserMotion(forUpdate currentTime: CFTimeInterval, node: SKSpriteNode) {
        if let data = motionManager.accelerometerData {
            if (fabs(data.acceleration.x) > 0.1) {
                node.physicsBody!.applyForce(CGVector(dx: 80.0 * CGFloat(data.acceleration.x), dy: 0))
            }
            if (fabs(data.acceleration.y) > 0.1) {
                node.physicsBody!.applyForce(CGVector(dx: 0, dy: 80.0 * CGFloat(data.acceleration.y)))
            }
        }
    }
    
    func AddWalls() {
        Bot.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: vc.ScreenHalfW()*2, height: 1), center: CGPoint(x:vc.ScreenHalfW(), y:0))
        Bot.physicsBody?.isDynamic = false
        addChild(Bot)
        Top.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: vc.ScreenHalfW()*2, height: 1), center: CGPoint(x:vc.ScreenHalfW(), y:vc.ScreenHalfH()*2))
        Top.physicsBody?.isDynamic = false
        addChild(Top)
        Left.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: 1, height: vc.ScreenHalfH()*2), center: CGPoint(x:0, y:vc.ScreenHalfH()))
        Left.physicsBody?.isDynamic = false
        addChild(Left)
        Right.physicsBody = SKPhysicsBody(rectangleOf: CGSize (width: 1, height: vc.ScreenHalfH()*2), center: CGPoint(x:vc.ScreenHalfW()*2, y:vc.ScreenHalfH()))
        Right.physicsBody?.isDynamic = false
        addChild(Right)
    }
    
    var suitChangedTo: [Bool] = [false, false, false, false]
    
    final var isAtTopLeft: Bool {
        return abs(FoldedCard.position.x - TopLeft.x) < 1 && abs(FoldedCard.position.y - TopLeft.y) < 1
    }
    
    final var isAtTopRignt: Bool {
        return abs(FoldedCard.position.x - TopRight.x) < 1 &&  abs(FoldedCard.position.y - TopRight.y) < 1
    }
    
    final var isAtBotLeft: Bool {
        return abs(FoldedCard.position.x - BotLeft.x) < 1 &&  abs(FoldedCard.position.y - BotLeft.y) < 1
    }
    
    final var isAtBotRight: Bool {
        return abs(FoldedCard.position.x - BotRight.x) < 1 && abs(FoldedCard.position.y - BotRight.y) < 1
    }
    
    var CornersArr: [CGPoint] {
        return [TopLeft, TopRight, BotLeft, BotRight]
    }
    
    func ChangeSuit() {
        if !(isAtTopLeft || isAtTopRignt || isAtBotLeft || isAtBotRight) {
            self.removeAllActions()
            for n in 0...3 {self.suitChangedTo[n] = false}
        }
        if isAtTopLeft && !suitChangedTo[0]{
            changeSuitModel(0)
        } else if isAtTopRignt && !suitChangedTo[1]{
            changeSuitModel(1)
        } else if isAtBotLeft && !suitChangedTo[2]{
            changeSuitModel(2)
        } else if isAtBotRight && !suitChangedTo[3]{
            changeSuitModel(3)
        }
    }
    
    func changeSuitModel (_ num: Int){
        self.suitChangedTo[num] = true
        let wait = SKAction.wait(forDuration: Settings.defaults.double(forKey:"durationOfChangeSuit"))
        self.run(wait, completion: {
            for n in 0...3 {if n != num {self.suitChangedTo[n] = false}}
            if abs(FoldedCard.position.x - self.CornersArr[num].x) < 2 && abs(FoldedCard.position.y - self.CornersArr[num].y) < 2 && Card.suit != self.suitArray[num]{
                if Settings.defaults.bool(forKey:"allowVibration"){
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                Card.suit = self.suitArray[num]
            }
        })
    }
    
    
}
