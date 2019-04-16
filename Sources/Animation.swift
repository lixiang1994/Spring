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
    
    enum Preset {
        case slideLeft, slideRight, slideDown, slideUp
        case squeezeLeft, squeezeRight, squeezeDown, squeezeUp
        case fadeInLeft, fadeInRight, fadeInDown, fadeInUp
        case fadeIn, fadeOut, fadeOutIn
        case zoomIn, zoomOut
        case flipX, flipY
        
        case fall
        case shake
        case pop
        case active
        case morph
        case squeeze
        case flash
        case wobble
        case swing
        case none
    }
    
    enum Curve {
        case linear
        case discrete
        case spring(damping: CGFloat)
        case easeIn, easeOut, easeInOut
        
        // http://easings.net/
        case easeInSine, easeOutSine, easeInOutSine
        case easeInQuad, easeOutQuad, easeInOutQuad
        case easeInCubic, easeOutCubic, easeInOutCubic
        case easeInQuart, easeOutQuart, easeInOutQuart
        case easeInQuint, easeOutQuint, easeInOutQuint
        case easeInExpo, easeOutExpo, easeInOutExpo
        case easeInCirc, easeOutCirc, easeInOutCirc
        case easeInBack, easeOutBack, easeInOutBack
        
        case custom(c1x: Float, c1y: Float, c2x: Float, c2y: Float)
        
        case none
        
        internal var animationOptions: UIView.AnimationOptions {
            switch self {
            case .easeIn:       return .curveEaseIn
            case .easeOut:      return .curveEaseOut
            case .easeInOut:    return .curveEaseInOut
            default:            return .curveLinear
            }
        }
        
        internal var timingFunction: CAMediaTimingFunction {
            switch self {
            case .easeIn:          return .init(name: .easeIn)
            case .easeOut:         return .init(name: .easeOut)
            case .easeInOut:       return .init(name: .easeInEaseOut)
            case .linear:          return .init(name: .linear)
            case .spring(let damping):
                return .init(controlPoints: 0.5, 1.1 + Float(damping / 3.0), 1, 1)
            case .discrete:        return .init(controlPoints: 1, 0, 1, 1)
                
            // http://easings.net/
            case .easeInSine:      return .init(controlPoints: 0.47, 0, 0.745, 0.715)
            case .easeOutSine:     return .init(controlPoints: 0.39, 0.575, 0.565, 1)
            case .easeInOutSine:   return .init(controlPoints: 0.445, 0.05, 0.55, 0.95)
            case .easeInQuad:      return .init(controlPoints: 0.55, 0.085, 0.68, 0.53)
            case .easeOutQuad:     return .init(controlPoints: 0.25, 0.46, 0.45, 0.94)
            case .easeInOutQuad:   return .init(controlPoints: 0.455, 0.03, 0.515, 0.955)
            case .easeInCubic:     return .init(controlPoints: 0.55, 0.055, 0.675, 0.19)
            case .easeOutCubic:    return .init(controlPoints: 0.215, 0.61, 0.355, 1)
            case .easeInOutCubic:  return .init(controlPoints: 0.645, 0.045, 0.355, 1)
            case .easeInQuart:     return .init(controlPoints: 0.895, 0.03, 0.685, 0.22)
            case .easeOutQuart:    return .init(controlPoints: 0.165, 0.84, 0.44, 1)
            case .easeInOutQuart:  return .init(controlPoints: 0.77, 0, 0.175, 1)
            case .easeInQuint:     return .init(controlPoints: 0.755, 0.05, 0.855, 0.06)
            case .easeOutQuint:    return .init(controlPoints: 0.23, 1, 0.32, 1)
            case .easeInOutQuint:  return .init(controlPoints: 0.86, 0, 0.07, 1)
            case .easeInExpo:      return .init(controlPoints: 0.95, 0.05, 0.795, 0.035)
            case .easeOutExpo:     return .init(controlPoints: 0.19, 1, 0.22, 1)
            case .easeInOutExpo:   return .init(controlPoints: 1, 0, 0, 1)
            case .easeInCirc:      return .init(controlPoints: 0.6, 0.04, 0.98, 0.335)
            case .easeOutCirc:     return .init(controlPoints: 0.075, 0.82, 0.165, 1)
            case .easeInOutCirc:   return .init(controlPoints: 0.785, 0.135, 0.15, 0.86)
            case .easeInBack:      return .init(controlPoints: 0.6, -0.28, 0.735, 0.045)
            case .easeOutBack:     return .init(controlPoints: 0.175, 0.885, 0.32, 1.275)
            case .easeInOutBack:   return .init(controlPoints: 0.68, -0.55, 0.265, 1.55)
                
            case .custom(let c1x, let c1y, let c2x, let c2y):
                return .init(controlPoints: c1x, c1y, c2x, c2y)
            default: return .init(name: .default)
            }
        }
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

