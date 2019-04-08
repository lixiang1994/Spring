
# Spring - Animation

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)


## 特性

- [x] 链式语法.
- [x] 无需继承父类.
- [x] 轻量级扩展.
- [x] 基于UIViewAnimation.
- [x] 无代码入侵.


## 安装

**Podfile**

```ruby
pod 'SpringAnimation'
```

**Carthage**

```ruby
github "lixiang1994/Spring"
```

## 使用

首先导入:

```swift
import SpringAnimation
```

下面是一些简单示例. 支持所有设备和模拟器:

### 链式调用

```swift
animationView.spring
.opacity(0.1)
.scale(0.8, 0.8)
.duration(2)
.curve(.easeOutQuad)
.animate()
```

### 方法
animate()
animateNext { ... }
animateTo()
animateToNext { ... }

### 动画类型
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

### 曲线
spring
linear
easeIn
easeOut
easeInOut

### 特性
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

\* 并非所有属性都能一起使用.

## 参考

> [Spring](https://github.com/MengTo/Spring)

## 贡献

如果你需要实现特定功能或遇到错误，请打开issue。 如果你自己扩展了Spring的功能并希望其他人也使用它，请提交拉取请求。


## 协议

Spring 使用 GPL 协议. 有关更多信息，请参阅 [LICENSE](LICENSE) 文件.
