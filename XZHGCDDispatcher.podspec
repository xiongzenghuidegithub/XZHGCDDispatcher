Pod::Spec.new do |s|
  s.name         = "XZHGCDDispatcher"
  s.version      = "0.2.0"
  s.summary      = "wrapper basic on YYDispatchQueuePool, avoid thread count too many!!!."
  s.homepage     = "https://github.com/xiongzenghuidegithub/XZHGCDDispatcher"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "xiongzenghui" => "xiongzenghui@zhihu.com" }

  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'

  s.source       = {
    :git => "https://github.com/xiongzenghuidegithub/XZHGCDDispatcher.git",
    :tag => "#{s.version}"
  }
  
  s.source_files  = "XZHGCDDispatcher/Classes/**/*.{h,m}"
  s.public_header_files = "XZHGCDDispatcher/Classes/**/*.h"

  s.requires_arc = true
  s.frameworks = 'Foundation'
end
