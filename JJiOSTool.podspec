Pod::Spec.new do |s|

  s.name         = "JJiOSTool"
  s.version      = "1.0.8"
  s.summary      = "iOS development tool"
  s.homepage     = "https://github.com/hamilyjing/JJiOSTool"
  s.license      = "MIT"
  s.author       = { "JJ" => "gongjian_001@126.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/hamilyjing/JJiOSTool.git", :tag => s.version }
  s.source_files = "JJiOSTool", "JJiOSTool/SystemCategory/NSArray+JJ.h", "JJiOSTool/SystemCategory/NSArray+JJ.m"
  s.library      = "z"

  #s.source_files = 'YZTOpenSSL/YZTOpenSSL.framework/Headers/**.h'
  #s.public_header_files = 'YZTOpenSSL/YZTOpenSSL.framework/Headers/**.h'
  s.vendored_frameworks = 'YZTOpenSSL/YZTOpenSSL.framework'

end
