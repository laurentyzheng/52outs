//
//  Global.swift
//  52outs
//
//  Created by Laurent Zheng on 2021-08-31.
//

import UIKit
import SpriteKit

/**
 Global Variables
 */
var FullCard = SKSpriteNode()

var FullCardReady = Bool()

var FoldedCardW: CGFloat{
    let physicalW: Float = 200
    return CGFloat(physicalW)
}
var FoldedCardH: CGFloat{
    return FoldedCardW * 1.39
}

/// points for folded card
var TopRight: CGPoint{
    return CGPoint(x: vc.ScreenHalfW()*2 - FoldedCardW/2, y: vc.ScreenHalfH()*2 - FoldedCardH/2 )
}
var TopLeft: CGPoint{
    return CGPoint(x: FoldedCardW/2, y: vc.ScreenHalfH()*2 - FoldedCardH/2 )
}
var BotRight: CGPoint{
    return CGPoint(x: vc.ScreenHalfW()*2 - FoldedCardW/2, y: FoldedCardH/2)
}
var BotLeft: CGPoint{
    return CGPoint(x: FoldedCardW/2, y: FoldedCardH/2)
}


///boolean for folded card's positions
var isAtTopLeft: Bool {
    return abs(FoldedCard.position.x - TopLeft.x) < 1 && abs(FoldedCard.position.y - TopLeft.y) < 1
}

var isAtTopRignt: Bool {
    return abs(FoldedCard.position.x - TopRight.x) < 1 &&  abs(FoldedCard.position.y - TopRight.y) < 1
}

var isAtBotLeft: Bool {
    return abs(FoldedCard.position.x - BotLeft.x) < 1 &&  abs(FoldedCard.position.y - BotLeft.y) < 1
}

var isAtBotRight: Bool {
    return abs(FoldedCard.position.x - BotRight.x) < 1 && abs(FoldedCard.position.y - BotRight.y) < 1
}

