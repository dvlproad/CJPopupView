Pod::Spec.new do |s|
  s.name         = "CJPopoverView"
  s.version      = "0.0.2"
  s.summary      = "a pop view with arrow.（带箭号的弹出视图）"
  s.homepage     = "https://github.com/dvlproad/CJPopup"
  s.license      = "MIT"
  s.author             = "dvlproad"
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/dvlproad/CJPopup.git", :tag => "popoverView_0.0.2" }
  s.source_files  = "CJPopoverView/**/*.{h,m}"
  # s.resources = "CJPopoverView/**/*.{png,xib}"
  s.frameworks = 'UIKit'

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end

