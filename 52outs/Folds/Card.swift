//
//  Model.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-10-12.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//

import UIKit

public class Card {
    public static var value =  Int() {
        didSet{
            if value == 0 || value > 13{
                chosenCard = String(value)
            } else {
                chosenCard = "\(String(value))\(suit)"
            }
        }
    }
    public static var suit = String()
    public static var W: CGFloat {
        let physicalSize: Float = 382
        let CGPhyscialSize: CGFloat = CGFloat(physicalSize)
        if vc.ScreenHalfH() * 2 < CGPhyscialSize {
            return vc.ScreenHalfW() * 2
        } else {
        return CGPhyscialSize
        }
    }
    public static var H = W * 1.4
    public static var chosenCard = String()
}

class FirstSwipe: UIPanGestureRecognizer {
    var type = Int ()
}

class SecondSwipe: UIPanGestureRecognizer{
    var add = Bool()
}
