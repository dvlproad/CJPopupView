Pod::Spec.new do |s|
  s.name         = "CJPopoverView"
  s.version      = "0.0.3"
  s.summary      = "一个带箭号的弹出视图。在0.0.3版本这里停止使用，并改为pod‘CJPopupView/CJPopoverView’"
  s.homepage     = "https://github.com/dvlproad/CJPopupView"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/dvlproad/CJPopupView.git", :tag => "CJPopupView_2.0.4" }
  s.source_files  = "CJPicker/CJToolbar/*.{h,m}"
  s.frameworks = 'UIKit'

  s.deprecated = true

end
