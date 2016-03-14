
Pod::Spec.new do |s|

  s.name         = "WaniKit"
  s.version      = "2.0.2"
  s.summary      = "WaniKit - Swift wrapper for WaniKani.com API."
  s.description  = <<-DESC
  WaniKit - Swift wrapper for WaniKani.com API. It's based on NSOperation and NSOperationQueue, as described in this WWDC2015 talk.
                   DESC

  s.homepage     = "https://github.com/haawa799/WaniKit/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Andrew Kharchyshyn" => "haawaplus@gmail.com" }
  s.social_media_url   = "http://twitter.com/haawa799"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.source       = { :git => "https://github.com/haawa799/WaniKit.git", :tag => "v#{s.version}" }
  s.source_files  = "WaniKit", "Sources/WaniKit/*.{h,m,swift}"
  s.public_header_files = "Sources/WaniKit/*.h"

end
