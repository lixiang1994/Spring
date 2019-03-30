//
//  UIView+Animation.swift
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

// MARK: - 链式属性
public extension Wrapper where Base: UIView {
    
    @discardableResult
    func autostart(_ autostart: Bool) -> Wrapper {
        config.autostart = autostart
        return self
    }
    @discardableResult
    func autohide(_ autohide: Bool) -> Wrapper {
        config.autohide = autohide
        return self
    }
    @discardableResult
    func force(_ force: CGFloat) -> Wrapper {
        config.force = force
        return self
    }
    @discardableResult
    func delay(_ delay: CGFloat) -> Wrapper {
        config.delay = delay
        return self
    }
    @discardableResult
    func duration(_ duration: CGFloat) -> Wrapper {
        config.duration = duration
        return self
    }
    @discardableResult
    func damping(_ damping: CGFloat) -> Wrapper {
        config.damping = damping
        return self
    }
    @discardableResult
    func velocity(_ velocity: CGFloat) -> Wrapper {
        config.velocity = velocity
        return self
    }
    @discardableResult
    func repeatCount(_ repeatCount: Float) -> Wrapper {
        config.repeatCount = repeatCount
        return self
    }
    @discardableResult
    func potint(_ x: CGFloat, _ y: CGFloat) -> Wrapper {
        config.x = x
        config.y = y
        return self
    }
    @discardableResult
    func scale(_ x: CGFloat, _ y: CGFloat) -> Wrapper {
        config.scaleX = x
        config.scaleY = y
        return self
    }
    @discardableResult
    func rotate(_ rotate: CGFloat) -> Wrapper {
        config.rotate = rotate
        return self
    }
    @discardableResult
    func opacity(_ opacity: CGFloat) -> Wrapper {
        config.opacity = opacity
        return self
    }
    @discardableResult
    func animateFrom(_ animateFrom: Bool) -> Wrapper {
        config.animateFrom = animateFrom
        return self
    }
    @discardableResult
    func curve(_ curve: Animation.Curve) -> Wrapper {
        config.curve = curve
        return self
    }
    @discardableResult
    func animation(_ animation: Animation.Preset) -> Wrapper {
        config.animation = animation
        return self
    }
    // UIView
    @discardableResult
    func transform(_ transform: CGAffineTransform) -> Wrapper {
        base.transform = transform
        return self
    }
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Wrapper {
        base.alpha = alpha
        return self
    }
}

public extension Wrapper where Base: UIView {
    
    func animate(_ animation: Animation.Preset? = .none,
                        completion: (() -> Void)? = .none) {
        animation.map { config.animation = $0 }
        solver.animate(completion: completion)
    }
    
    func animateTo(_ animation: Animation.Preset? = .none,
                   completion: (() -> Void)? = .none) {
        animation.map { config.animation = $0 }
        solver.animateTo(completion: completion)
    }
    
    func customAwakeFromNib() {
        solver.customLayoutSubviews()
    }
    
    func customLayoutSubviews() {
        solver.customLayoutSubviews()
    }
}

private var taskConfigKey: Void?
private var taskSolverKey: Void?

extension Wrapper where Base: UIView {
    
    public func set(config: (Config) -> Void) {
        config(self.config)
    }
    
    private var config: Config {
        guard let config = objc_getAssociatedObject(base, &taskConfigKey) as? Config else {
            let value = Config()
            objc_setAssociatedObject(base, &taskConfigKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        return config
    }
    
    private var solver: Solver {
        guard let solver = objc_getAssociatedObject(base, &taskSolverKey) as? Solver else {
            let value = Solver(config, base)
            objc_setAssociatedObject(base, &taskSolverKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        return solver
    }
}
