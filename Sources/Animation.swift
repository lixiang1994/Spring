//
//  Animation.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by lee on 2019/3/30.
//  Copyright © 2019年 lee. All rights reserved.
//

import Foundation
import UIKit

public enum Animation {
    case normal
    case curveEaseIn
    case curveEaseOut
    case curveEaseInOut
    case curveLinear
    case delay(TimeInterval)
}

public extension Animation {
    
    enum Preset: String {
        case slideLeft
        case slideRight
        case slideDown
        case slideUp
        case squeezeLeft
        case squeezeRight
        case squeezeDown
        case squeezeUp
        case fadeIn
        case fadeOut
        case fadeOutIn
        case fadeInLeft
        case fadeInRight
        case fadeInDown
        case fadeInUp
        case zoomIn
        case zoomOut
        case fall
        case shake
        case pop
        case active
        case flipX
        case flipY
        case morph
        case squeeze
        case flash
        case wobble
        case swing
        case none
    }
    
    enum Curve: String {
        case easeIn
        case easeOut
        case easeInOut
        case linear
        case spring
        case easeInSine
        case easeOutSine
        case easeInOutSine
        case easeInQuad
        case easeOutQuad
        case easeInOutQuad
        case easeInCubic
        case easeOutCubic
        case easeInOutCubic
        case easeInQuart
        case easeOutQuart
        case easeInOutQuart
        case easeInQuint
        case easeOutQuint
        case easeInOutQuint
        case easeInExpo
        case easeOutExpo
        case easeInOutExpo
        case easeInCirc
        case easeOutCirc
        case easeInOutCirc
        case easeInBack
        case easeOutBack
        case easeInOutBack
        case none
    }
}

extension Animation {
    
    public func spring(with duration: TimeInterval,
                       animations: @escaping () -> Void) {
        spring(with: duration, animations: animations, completion: nil)
    }
    
    public func spring(with duration: TimeInterval,
                       animations: @escaping () -> Void,
                       completion: ((Bool) -> Void)?) {
        
        switch self {
        case .normal:
            UIView.animate(
                withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.7,
                options: options,
                animations: animations,
                completion: completion
            )
            
        case .delay(let time):
            UIView.animate(
                withDuration: duration,
                delay: time,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.7,
                options: options,
                animations: animations,
                completion: completion
            )
            
        case .curveEaseIn,
             .curveEaseOut,
             .curveEaseInOut,
             .curveLinear:
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: options,
                animations: animations,
                completion: completion
            )
        }
    }
}

private extension Animation {
    
    var options: UIView.AnimationOptions {
        switch self {
        case .normal,
             .delay:                  return []
        case .curveEaseIn:            return .curveEaseIn
        case .curveEaseOut:           return .curveEaseOut
        case .curveEaseInOut:         return .curveEaseInOut
        case .curveLinear:            return .curveLinear
        }
    }
}

