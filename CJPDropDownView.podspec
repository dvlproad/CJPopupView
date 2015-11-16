Pod::Spec.new do |s|
  s.name         = "CJPDropDownView"
  s.version      = "1.1.0"
  s.summary      = "类似美团的下拉视图"
  s.homepage     = "https://github.com/dvlproad/CJPopup"
  s.license      = "MIT"
  s.author             = "dvlproad"
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/dvlproad/CJPopup.git", :tag => "1.1.0" }
  s.source_files  = "CJPDropDownView/**/*.{h,m}"
  # s.resources = "CJPDropDownView/**/*.{png,xib}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  s.dependency 'RadioButtons', '~> 1.2.0'

end
