Pod::Spec.new do |s|
  s.name = "XZHGCDDispatcher"
  s.version = "0.2.0"
  s.summary = "wrapper basic on YYDispatchQueuePool, avoid thread count too many!!!."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"xiongzenghui"=>"xiongzenghui@zhihu.com"}
  s.homepage = "https://github.com/xiongzenghuidegithub/XZHGCDDispatcher"
  s.frameworks = "Foundation"
  s.requires_arc = true
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/XZHGCDDispatcher.framework'
end
