//
//  Quarter.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-10-24.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//

import UIKit

public class Quarter {
    var rotating: UIImageView = UIImageView()
    var stationary: UIImageView = UIImageView()
    init (_ val: Int, w: CGFloat, h: CGFloat, color: String){
        var rotHori:UIImage!
        var staHori:UIImage!
        var rotVert:UIImage!
        var staVert:UIImage!
        if color == "Red"{
            rotHori =  UIImage(named: "RotatingPieceH")
            staHori = UIImage(named: "StationaryPieceH")
            rotVert = UIImage(named:"RotatingPieceV")
            staVert =  UIImage(named:"StationaryPieceV")
        } else if color == "Blue"{
            rotHori =  UIImage(named: "BlueRotatingPieceH")
            staHori = UIImage(named: "BlueStationaryPieceH")
            rotVert = UIImage(named:"BlueRotatingPieceV")
            staVert =  UIImage(named:"BlueStationaryPieceV")
        }
        if val < 4 {
            var imageID = rotHori
            if val > 1 {
                imageID = UIImage(cgImage: (imageID?.cgImage)!, scale: (imageID!.scale), orientation: .downMirrored)
            }
            rotating.image = imageID
            stationary.image = staHori
            rotating.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        } else {
            var imageID = rotVert
            if val % 2 == 0 {
                imageID = imageID!.withHorizontallyFlippedOrientation()
            }
            rotating.image = imageID
            stationary.image = staVert
            rotating.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        }
        if val == 0 {
            rotating.frame = CGRect(x:vc.ScreenHalfW(), y:vc.ScreenHalfH() - h, width:w, height: h)
            stationary.frame = CGRect(x:vc.ScreenHalfW() - w, y:vc.ScreenHalfH() - h, width:w, height: h)
            rotating.layer.transform = CATransform3DMakeRotation( .pi, 0, 1, 0)
        } else if val == 1 {
            rotating.frame = CGRect(x:vc.ScreenHalfW(), y:vc.ScreenHalfH() - h, width:w, height: h)
            stationary.frame = rotating.frame
            stationary.layer.transform = CATransform3DMakeRotation( .pi, 0, 1, 0)
        } else if val == 2 {
            rotating.frame = CGRect(x:vc.ScreenHalfW(), y:vc.ScreenHalfH(), width:w, height: h)
            stationary.frame = CGRect(x:vc.ScreenHalfW() - w, y:vc.ScreenHalfH(), width:w, height: h)
            stationary.layer.transform = CATransform3DMakeRotation( .pi, 1, 0, 0)
            rotating.layer.transform = CATransform3DMakeRotation( .pi, 0, 1, 0)
        } else if val == 3 {
            rotating.frame = CGRect(x:vc.ScreenHalfW(), y:vc.ScreenHalfH(), width:w, height: h)
            stationary.frame = rotating.frame
            stationary.layer.transform = CATransform3DMakeRotation( .pi, 0, 0, 1)
        } else if val == 4 {
            stationary.frame = CGRect(x:vc.ScreenHalfW() - w, y:vc.ScreenHalfH() - h, width:w, height: h)
            rotating.frame = stationary.frame
            stationary.layer.transform = CATransform3DMakeRotation( .pi, 0, 0, 1)
        } else if val == 5 {
            stationary.frame = CGRect(x:vc.ScreenHalfW(), y:vc.ScreenHalfH() - h, width:w, height: h)
            rotating.frame = stationary.frame
            stationary.layer.transform = CATransform3DMakeRotation( .pi, 1, 0, 0)
        } else if val == 6 {
            rotating.frame = CGRect(x:vc.ScreenHalfW() - w, y:vc.ScreenHalfH() - h, width:w, height: h)
            stationary.frame = CGRect(x:vc.ScreenHalfW() - w, y:vc.ScreenHalfH(), width:w, height: h)
            stationary.layer.transform = CATransform3DMakeRotation( .pi, 0, 1, 0)
            rotating.layer.transform = CATransform3DMakeRotation( .pi, 1, 0, 0)
        } else if val == 7 {
            rotating.frame = CGRect(x:vc.ScreenHalfW(), y:vc.ScreenHalfH() - h, width:w, height: h)
            stationary.frame = CGRect(x:vc.ScreenHalfW(), y:vc.ScreenHalfH(), width:w, height: h)
            rotating.layer.transform = CATransform3DMakeRotation( .pi, 1, 0, 0)
        } else {
            print("val not right")
        }
    }
}
