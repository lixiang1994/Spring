//
//  Solver.swift
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

class Solver: NSObject {
    
    private let config: Config
    private let view: UIView
    
    private var shouldAnimateAfterActive = false
    private var shouldAnimateInLayoutSubviews = true
    
    init(_ config: Config, _ view: UIView) {
        self.config = config
        self.view = view
        super.init()
        setupNotification()
    }
}

extension Solver {
    
    func animate(completion: (() -> Void)? = .none) {
        set(animateFrom: true)
        animatePreset()
        set(view: completion)
    }
    
    func animateTo(completion: (() -> Void)? = .none) {
        set(animateFrom: false)
        animatePreset()
        set(view: completion)
    }
    
    func customAwakeFromNib() {
        guard autohide else { return }
        alpha = 0
    }
    
    func customLayoutSubviews() {
        guard shouldAnimateInLayoutSubviews else { return }
        shouldAnimateInLayoutSubviews = false
        
        guard autostart, UIApplication.shared.applicationState == .active else {
            shouldAnimateAfterActive = true
            return
        }
        alpha = 0
        animate()
    }
}

// MARK: - Notification
extension Solver {
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc private func didBecomeActive(_ sender: NSNotification) {
        guard shouldAnimateAfterActive else {
            return
        }
        
        view.alpha = 0
        animate()
        shouldAnimateAfterActive = false
    }
}

extension Solver {
    
    private var autostart: Bool { return config.autostart }
    private var autohide: Bool { return config.autohide }
    private var animation: Animation.Preset { return config.animation}
    private var force: CGFloat { return config.force }
    private var delay: CGFloat { return config.delay }
    private var duration: CGFloat { return config.duration }
    private var damping: CGFloat { return config.damping }
    private var velocity: CGFloat { return config.velocity }
    private var repeatCount: Float { return config.repeatCount }
    private var x: CGFloat { return config.x }
    private var y: CGFloat { return config.y }
    private var scaleX: CGFloat { return config.scaleX }
    private var scaleY: CGFloat { return config.scaleY }
    private var rotate: CGFloat { return config.rotate }
    private var opacity: CGFloat { return config.opacity }
    private var animateFrom: Bool { return config.animateFrom }
    private var curve: Animation.Curve { return config.curve }
    
    // UIView
    private var layer: CALayer { return view.layer }
    private var transform: CGAffineTransform {
        get { return view.transform }
        set { view.transform = newValue }
    }
    private var alpha: CGFloat {
        get { return view.alpha }
        set { view.alpha = newValue }
    }
}

extension Solver {
    
    private func animatePreset() {
        view.alpha = 0.99
        switch animation {
        case .slideLeft:
            config.x = 300 * force
            
        case .slideRight:
            config.x = -300 * force
            
        case .slideDown:
            config.y = -300 * force
            
        case .slideUp:
            config.y = 300 * force
            
        case .squeezeLeft:
            config.x = 300
            config.scaleX = 3 * force
            
        case .squeezeRight:
            config.x = -300
            config.scaleX = 3 * force
            
        case .squeezeDown:
            config.y = -300
            config.scaleY = 3 * force
            
        case .squeezeUp:
            config.y = 300
            config.scaleY = 3 * force
            
        case .fadeIn:
            config.opacity = 0
            
        case .fadeOut:
            set(animateFrom: false)
            config.opacity = 0
            
        case .fadeOutIn:
            let animation = CABasicAnimation()
            animation.keyPath = "opacity"
            animation.fromValue = 1
            animation.toValue = 0
            animation.timingFunction = getTimingFunction(curve: curve)
            animation.duration = CFTimeInterval(duration)
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            animation.autoreverses = true
            layer.add(animation, forKey: "fade")
            
        case .fadeInLeft:
            config.opacity = 0
            config.x = 300 * force
            
        case .fadeInRight:
            config.x = -300 * force
            config.opacity = 0
            
        case .fadeInDown:
            config.y = -300 * force
            config.opacity = 0
            
        case .fadeInUp:
            config.y = 300 * force
            config.opacity = 0
            
        case .zoomIn:
            config.opacity = 0
            config.scaleX = 2 * force
            config.scaleY = 2 * force
            
        case .zoomOut:
            set(animateFrom: false)
            config.opacity = 0
            config.scaleX = 2 * force
            config.scaleY = 2 * force
            
        case .fall:
            set(animateFrom: false)
            config.rotate = 15 * (.pi / 180.0)
            config.y = 600 * force
            
        case .shake:
            let animation = CAKeyframeAnimation()
            animation.keyPath = "position.x"
            animation.values = [0, 30 * force, -30 * force, 30 * force, 0]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.timingFunction = getTimingFunction(curve: curve)
            animation.duration = CFTimeInterval(duration)
            animation.isAdditive = true
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "shake")
            
        case .pop:
            let animation = CAKeyframeAnimation()
            animation.keyPath = "transform.scale"
            animation.values = [0, 0.2*force, -0.2*force, 0.2*force, 0]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.timingFunction = getTimingFunction(curve: curve)
            animation.duration = CFTimeInterval(duration)
            animation.isAdditive = true
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "pop")
            
        case .active:
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = -0.023*force
            animation.toValue = 0.023*force
            animation.timingFunction = getTimingFunction(curve: curve)
            animation.duration = CFTimeInterval(duration)
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            animation.autoreverses = true
            animation.fillMode = .forwards
            animation.isAdditive = true
            animation.repeatCount = repeatCount
            layer.add(animation, forKey: "active")
            
        case .flipX:
            config.rotate = 0
            config.scaleX = 1
            config.scaleY = 1
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / layer.frame.size.width/2
            
            let animation = CABasicAnimation()
            animation.keyPath = "transform"
            animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 0, 0))
            animation.toValue = NSValue(caTransform3D:
                CATransform3DConcat(perspective, CATransform3DMakeRotation(.pi, 0, 1, 0)))
            animation.duration = CFTimeInterval(duration)
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            animation.timingFunction = getTimingFunction(curve: curve)
            layer.add(animation, forKey: "3d")
            
        case .flipY:
            var perspective = CATransform3DIdentity
            perspective.m34 = -1.0 / layer.frame.size.width / 2
            
            let animation = CABasicAnimation()
            animation.keyPath = "transform"
            animation.fromValue = NSValue(caTransform3D:
                CATransform3DMakeRotation(0, 0, 0, 0))
            animation.toValue = NSValue(caTransform3D:
                CATransform3DConcat(perspective, CATransform3DMakeRotation(.pi, 1, 0, 0)))
            animation.duration = CFTimeInterval(duration)
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            animation.timingFunction = getTimingFunction(curve: curve)
            layer.add(animation, forKey: "3d")
            
        case .morph:
            let morphX = CAKeyframeAnimation()
            morphX.keyPath = "transform.scale.x"
            morphX.values = [1, 1.3 * force, 0.7, 1.3 * force, 1]
            morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphX.timingFunction = getTimingFunction(curve: curve)
            morphX.duration = CFTimeInterval(duration)
            morphX.repeatCount = repeatCount
            morphX.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphX, forKey: "morphX")
            
            let morphY = CAKeyframeAnimation()
            morphY.keyPath = "transform.scale.y"
            morphY.values = [1, 0.7, 1.3 * force, 0.7, 1]
            morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphY.timingFunction = getTimingFunction(curve: curve)
            morphY.duration = CFTimeInterval(duration)
            morphY.repeatCount = repeatCount
            morphY.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphY, forKey: "morphY")
            
        case .squeeze:
            let morphX = CAKeyframeAnimation()
            morphX.keyPath = "transform.scale.x"
            morphX.values = [1, 1.5 * force, 0.5, 1.5 * force, 1]
            morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphX.timingFunction = getTimingFunction(curve: curve)
            morphX.duration = CFTimeInterval(duration)
            morphX.repeatCount = repeatCount
            morphX.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphX, forKey: "morphX")
            
            let morphY = CAKeyframeAnimation()
            morphY.keyPath = "transform.scale.y"
            morphY.values = [1, 0.5, 1, 0.5, 1]
            morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphY.timingFunction = getTimingFunction(curve: curve)
            morphY.duration = CFTimeInterval(duration)
            morphY.repeatCount = repeatCount
            morphY.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphY, forKey: "morphY")
            
        case .flash:
            let animation = CABasicAnimation()
            animation.keyPath = "opacity"
            animation.fromValue = 1
            animation.toValue = 0
            animation.duration = CFTimeInterval(duration)
            animation.repeatCount = repeatCount * 2.0
            animation.autoreverses = true
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "flash")
            
        case .wobble:
            let animation = CAKeyframeAnimation()
            animation.keyPath = "transform.rotation"
            animation.values = [0, 0.3 * force, -0.3 * force, 0.3 * force, 0]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.duration = CFTimeInterval(duration)
            animation.isAdditive = true
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "wobble")
            
            let x = CAKeyframeAnimation()
            x.keyPath = "position.x"
            x.values = [0, 30 * force, -30 * force, 30 * force, 0]
            x.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            x.timingFunction = getTimingFunction(curve: curve)
            x.duration = CFTimeInterval(duration)
            x.isAdditive = true
            x.repeatCount = repeatCount
            x.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(x, forKey: "x")
            
        case .swing:
            let animation = CAKeyframeAnimation()
            animation.keyPath = "transform.rotation"
            animation.values = [0, 0.3 * force, -0.3 * force, 0.3 * force, 0]
            animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            animation.duration = CFTimeInterval(duration)
            animation.isAdditive = true
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "swing")
            
        case .none:
            break
        }
    }
    
    private func set(view completion: (() -> Void)?) {
        
        func transformAnimate() {
            let translate = CGAffineTransform(translationX: x, y: y)
            let scale = CGAffineTransform(scaleX: scaleX, y: scaleY)
            let rotate = CGAffineTransform(rotationAngle: self.rotate)
            let translateAndScale = translate.concatenating(scale)
            transform = rotate.concatenating(translateAndScale)
            
            alpha = opacity
        }
        
        let animations =  { [weak self] in
            guard let self = self else { return }
            
            if self.animateFrom {
                self.transform = .identity
                self.alpha = 1
                
            } else {
                transformAnimate()
            }
        }
        
        if animateFrom {
            transformAnimate()
        }
        
        UIView.animate(
            withDuration: TimeInterval(duration),
            delay: TimeInterval(delay),
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity,
            options: [getAnimationOptions(curve: curve), .allowUserInteraction],
            animations: animations
        ) { [weak self] finished in
            completion?()
            self?.resetAll()
        }
    }
    
    private func getAnimationOptions(curve: Animation.Curve) -> UIView.AnimationOptions {
        switch curve {
        case .easeIn:       return .curveEaseIn
        case .easeOut:      return .curveEaseOut
        case .easeInOut:    return .curveEaseInOut
        default:            return .curveLinear
        }
    }
    
    private func getTimingFunction(curve: Animation.Curve) -> CAMediaTimingFunction {
        switch curve {
        case .easeIn: return .init(name: .easeIn)
        case .easeOut: return .init(name: .easeOut)
        case .easeInOut: return .init(name: .easeInEaseOut)
        case .linear: return .init(name: .linear)
        case .spring: return .init(controlPoints: 0.5, 1.1 + Float(force / 3), 1, 1)
        case .easeInSine: return .init(controlPoints: 0.47, 0, 0.745, 0.715)
        case .easeOutSine: return .init(controlPoints: 0.39, 0.575, 0.565, 1)
        case .easeInOutSine: return .init(controlPoints: 0.445, 0.05, 0.55, 0.95)
        case .easeInQuad: return .init(controlPoints: 0.55, 0.085, 0.68, 0.53)
        case .easeOutQuad: return .init(controlPoints: 0.25, 0.46, 0.45, 0.94)
        case .easeInOutQuad: return .init(controlPoints: 0.455, 0.03, 0.515, 0.955)
        case .easeInCubic: return .init(controlPoints: 0.55, 0.055, 0.675, 0.19)
        case .easeOutCubic: return .init(controlPoints: 0.215, 0.61, 0.355, 1)
        case .easeInOutCubic: return .init(controlPoints: 0.645, 0.045, 0.355, 1)
        case .easeInQuart: return .init(controlPoints: 0.895, 0.03, 0.685, 0.22)
        case .easeOutQuart: return .init(controlPoints: 0.165, 0.84, 0.44, 1)
        case .easeInOutQuart: return .init(controlPoints: 0.77, 0, 0.175, 1)
        case .easeInQuint: return .init(controlPoints: 0.755, 0.05, 0.855, 0.06)
        case .easeOutQuint: return .init(controlPoints: 0.23, 1, 0.32, 1)
        case .easeInOutQuint: return .init(controlPoints: 0.86, 0, 0.07, 1)
        case .easeInExpo: return .init(controlPoints: 0.95, 0.05, 0.795, 0.035)
        case .easeOutExpo: return .init(controlPoints: 0.19, 1, 0.22, 1)
        case .easeInOutExpo: return .init(controlPoints: 1, 0, 0, 1)
        case .easeInCirc: return .init(controlPoints: 0.6, 0.04, 0.98, 0.335)
        case .easeOutCirc: return .init(controlPoints: 0.075, 0.82, 0.165, 1)
        case .easeInOutCirc: return .init(controlPoints: 0.785, 0.135, 0.15, 0.86)
        case .easeInBack: return .init(controlPoints: 0.6, -0.28, 0.735, 0.045)
        case .easeOutBack: return .init(controlPoints: 0.175, 0.885, 0.32, 1.275)
        case .easeInOutBack: return .init(controlPoints: 0.68, -0.55, 0.265, 1.55)
        default: return .init(name: .default)
        }
    }
}

extension Solver {
    
    func set(animateFrom value: Bool) {
        config.animateFrom = value
    }
    
    private func reset() {
        config.x = 0
        config.y = 0
        config.opacity = 1
    }
    
    private func resetAll() {
        config.x = 0
        config.y = 0
        config.animation = .none
        config.opacity = 1
        config.scaleX = 1
        config.scaleY = 1
        config.rotate = 0
        config.damping = 0.7
        config.velocity = 0.7
        config.repeatCount = 1
        config.delay = 0
        config.duration = 0.7
    }
}
