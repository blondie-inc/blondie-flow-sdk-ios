Pod::Spec.new do |s|
  s.name         = "Blondie"
  s.version      = "1.0.0"
  s.summary      = "Blondie SDK"
  s.description  = "Blondie SDK (https://blondie.lv/)"
  s.homepage     = "https://github.com/blondie-inc/blondie-flow-sdk-ios"
  s.license      = { :type => "MIT" }
  s.author       = { "Blondie Consulting" => "hello@blondie.lv" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/blondie-inc/blondie-flow-sdk-ios.git", :tag => s.version.to_s }
  s.source_files  = "Classes", "SDK/Blondie/**/*.{h,m}"
  s.requires_arc = true
end