Pod::Spec.new do |s|

  s.name         = "JJiOSTool"
  s.version      = "1.0.2"
  s.summary      = "iOS development tool"
  s.homepage     = "https://github.com/hamilyjing/JJiOSTool"
  s.license      = "MIT"
  s.author             = { "JJ" => "gongjian_001@126.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/hamilyjing/JJiOSTool.git", :tag => "1.0.1" }
  s.source_files  = "JJiOSTool", "JJiOSTool/**/*.{h,m}"
  s.library   = "z"
  ss.vendored_frameworks = "YZTOpenSSL/YZTOpenSSL.framework"

end
