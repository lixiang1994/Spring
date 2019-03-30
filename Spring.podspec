Pod::Spec.new do |s|

s.name         = "Spring"
s.version      = "1.0.0"
s.summary      = "一个简单易用的iOS链式动画扩展库"

s.homepage     = "https://github.com/lixiang1994/Spring"

s.license      = "MIT"

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios
s.platform     = :ios, "8.0"

s.source       = { :git => "https://github.com/lixiang1994/Spring.git", :tag => "1.0.0"}

s.source_files  = "Spring/**/*.swift"

s.requires_arc = true

s.swift_version = "5.0"

end
