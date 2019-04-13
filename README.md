
# Spring - Animation

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

## [天朝子民](README_CN.md)

## Features

- [x] Chained grammar.
- [x] No inheritance required.
- [x] Lightweight expansion.
- [x] Based on UIViewAnimation.
- [x] No code intrusion.


## Installation

**CocoaPods - Podfile**

```ruby
source 'https://github.com/lixiang1994/Specs'

pod 'Spring'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/Spring"
```

## Usage

First make sure to import the framework:

```swift
import SpringAnimation
```

Here are some usage examples. All devices are also available as simulators:

### Chaining

```swift
 animationView.spring
  .opacity(0.1)
  .scale(0.8, 0.8)
  .duration(2)
  .curve(.easeOutQuad)
  .animate()
```

### Functions
    animate()
    animateNext { ... }
    animateTo()
    animateToNext { ... }

### Animation
    shake
    pop
    morph
    squeeze
    wobble
    swing
    flipX
    flipY
    fall
    squeezeLeft
    squeezeRight
    squeezeDown
    squeezeUp
    slideLeft
    slideRight
    slideDown
    slideUp
    fadeIn
    fadeOut
    fadeInLeft
    fadeInRight
    fadeInDown
    fadeInUp
    zoomIn
    zoomOut
    flash

### Curve
    spring
    linear
    easeIn
    easeOut
    easeInOut

### Properties
    force
    duration
    delay
    damping
    velocity
    repeatCount
    scale
    x
    y
    rotate

\* Not all properties work together.

## Reference

> [Spring](https://github.com/MengTo/Spring)

## Contributing

If you have the need for a specific feature that you want implemented or if you experienced a bug, please open an issue.
If you extended the functionality of Spring yourself and want others to use it too, please submit a pull request.


## License

Spring is under MIT license. See the [LICENSE](LICENSE) file for more info.
