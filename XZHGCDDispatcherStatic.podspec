Pod::Spec.new do |s|
  s.name         = "XZHGCDDispatcherStatic"
  s.version      = "0.1.0"
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
  
  s.vendored_framework = "Frameworks/XZHGCDDispatcher-#{s.version}/ios/XZHGCDDispatcher.framework"

  s.requires_arc = true
  s.frameworks = 'Foundation'
end
