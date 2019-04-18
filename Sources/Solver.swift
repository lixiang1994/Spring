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
            animation.timingFunction = curve.timingFunction
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
            animation.timingFunction = curve.timingFunction
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
            animation.timingFunction = curve.timingFunction
            animation.duration = CFTimeInterval(duration)
            animation.isAdditive = true
            animation.repeatCount = repeatCount
            animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(animation, forKey: "pop")
            
        case .active:
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = -0.023*force
            animation.toValue = 0.023*force
            animation.timingFunction = curve.timingFunction
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
            animation.timingFunction = curve.timingFunction
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
            animation.timingFunction = curve.timingFunction
            layer.add(animation, forKey: "3d")
            
        case .morph:
            let morphX = CAKeyframeAnimation()
            morphX.keyPath = "transform.scale.x"
            morphX.values = [1, 1.3 * force, 0.7, 1.3 * force, 1]
            morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphX.timingFunction = curve.timingFunction
            morphX.duration = CFTimeInterval(duration)
            morphX.repeatCount = repeatCount
            morphX.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphX, forKey: "morphX")
            
            let morphY = CAKeyframeAnimation()
            morphY.keyPath = "transform.scale.y"
            morphY.values = [1, 0.7, 1.3 * force, 0.7, 1]
            morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphY.timingFunction = curve.timingFunction
            morphY.duration = CFTimeInterval(duration)
            morphY.repeatCount = repeatCount
            morphY.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphY, forKey: "morphY")
            
        case .squeeze:
            let morphX = CAKeyframeAnimation()
            morphX.keyPath = "transform.scale.x"
            morphX.values = [1, 1.5 * force, 0.5, 1.5 * force, 1]
            morphX.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphX.timingFunction = curve.timingFunction
            morphX.duration = CFTimeInterval(duration)
            morphX.repeatCount = repeatCount
            morphX.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
            layer.add(morphX, forKey: "morphX")
            
            let morphY = CAKeyframeAnimation()
            morphY.keyPath = "transform.scale.y"
            morphY.values = [1, 0.5, 1, 0.5, 1]
            morphY.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
            morphY.timingFunction = curve.timingFunction
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
            x.timingFunction = curve.timingFunction
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
            options: [curve.animationOptions, .allowUserInteraction],
            animations: animations
        ) { [weak self] finished in
            
            self?.resetAll()
            completion?()
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
