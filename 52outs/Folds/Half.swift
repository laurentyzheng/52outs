//
//  Half.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-10-24.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//

import UIKit

public class Half {
    var stationary: UIImageView = UIImageView ()
    var rotating: UIImageView = UIImageView ()
    init(_ orientation: String, front: UIImage, valOfturn: Int, color: String) {
        var TopBack: UIImage!
        var BotBack: UIImage!
        var LeftBack: UIImage!
        var RightBack: UIImage!
        if color == "Red"{
            TopBack =  UIImage(named: "TopHalf")
            BotBack = UIImage(named: "BotHalf")
            LeftBack = UIImage(named:"LeftHalf")
            RightBack =  UIImage(named:"RightHalf")
        } else if color == "Blue"{
            TopBack =  UIImage(named: "BlueTopHalf")
            BotBack = UIImage(named: "BlueBotHalf")
            LeftBack = UIImage(named:"BlueLeftHalf")
            RightBack =  UIImage(named:"BlueRightHalf")
        }
    
        if orientation == "T"  || orientation == "B"{
            stationary = UIImageView (image: front.topHalf)
            if valOfturn == 1 || valOfturn == 3{
                rotating = UIImageView (image: BotBack)
            } else {rotating = UIImageView (image: TopBack)}
            rotating.layer.anchorPoint = CGPoint(x:0.5, y:1.0)
            stationary.frame = CGRect(x:vc.ScreenHalfW() - Card.W/2, y:vc.ScreenHalfH()-Card.H/2, width:Card.W, height:Card.H/2)
            rotating.frame = stationary.frame
            if orientation == "B" {
                stationary = UIImageView (image: front.bottomHalf)
                stationary.frame = CGRect(x:vc.ScreenHalfW() - Card.W/2, y:vc.ScreenHalfH(), width:Card.W, height:Card.H/2)
                rotating.layer.transform = CATransform3DMakeRotation(.pi, 1, 0, 0)
            }
        } else if orientation == "R"  || orientation == "L"{
            stationary = UIImageView(image: front.rightHalf)
            if valOfturn == 4 || valOfturn == 5{
                rotating = UIImageView(image: LeftBack)
            }else{rotating = UIImageView(image: RightBack)}
            rotating.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            stationary.frame = CGRect(x:vc.ScreenHalfW(), y:vc.ScreenHalfH()-Card.H/2, width:Card.W/2, height:Card.H)
            rotating.frame = stationary.frame
            if orientation == "L"{
                stationary = UIImageView(image: front.leftHalf)
                stationary.frame = CGRect(x:vc.ScreenHalfW() - Card.W/2, y:vc.ScreenHalfH()-Card.H/2, width:Card.W/2, height:Card.H)
                rotating.layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
            }
        }
    }
}
