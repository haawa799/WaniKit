
Pod::Spec.new do |s|
s.homepage    = "https://github.com/haawa799/WaniKit/tree/master"
s.name        = "WaniKit"
s.version     = "0.1.0"
s.summary     = "Swift wrapper for WaniKani.com API"
s.license     = { :type => "MIT" }
s.authors     = { "Andriy Kharchyshyn" => "haawaplus@gmail.com" }

s.requires_arc = true
s.ios.deployment_target = "8.0"
s.source   = { :git => "https://github.com/haawa799/WaniKit.git", :tag => "v0.1.0" }
s.source_files = 'Pod/Classes/**/*'
end
