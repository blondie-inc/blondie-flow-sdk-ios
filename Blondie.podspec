Pod::Spec.new do |s|
  s.name         = 'Blondie'
  s.version      = '0.0.4'
  s.summary      = 'Blondie Flow SDK built for Objective-C/Swift based mobile applications'
  s.author       = { "Blondie Consulting" => "hello@blondie.lv" }
  s.homepage     = "https://github.com/blondie-inc/blondie-flow-sdk-ios"
  s.license      = { :type => 'GNU General Public License v3.0' }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/blondie-inc/blondie-flow-sdk-ios.git", :tag => "v0.0.4" }
  s.source_files  = "Classes", "SDK/Blondie/**/*.{h,m}"
  s.requires_arc = true
end