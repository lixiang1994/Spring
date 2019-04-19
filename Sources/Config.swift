//
//  Config.swift
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

public class Config {
    public var animation: Animation.Preset = .none
    public var curve: Animation.Curve = .none
    public var force: CGFloat = 1
    public var delay: CGFloat = 0
    public var duration: CGFloat = 0.7
    public var damping: CGFloat = 0.7
    public var velocity: CGFloat = 0.7
    public var repeatCount: Float = 1
    public var x: CGFloat = 0
    public var y: CGFloat = 0
    public var scaleX: CGFloat = 1
    public var scaleY: CGFloat = 1
    public var rotate: CGFloat = 0
    public var opacity: CGFloat = 1
    public var animateFrom: Bool = true
}
