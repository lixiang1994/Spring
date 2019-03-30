Pod::Spec.new do |s|

s.name         = "SpringAnimation"
s.version      = "1.0.6"
s.summary      = "一个简单易用的iOS链式动画扩展库 Swift"

s.homepage     = "https://github.com/lixiang1994/Spring"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios, "9.0"

s.source       = { :git => "https://github.com/lixiang1994/Spring.git", :tag => s.version }

s.source_files  = "Spring/**/*.swift"

s.requires_arc = true

s.frameworks = "UIKit", "Foundation"

s.swift_version = "4.2"
s.swift_versions = ["4.2", "5.0"]

end
