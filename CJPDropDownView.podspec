Pod::Spec.new do |s|
  s.name         = "CJPDropDownView"
  s.version      = "1.1.1"
  s.summary      = "一个类似美团的下拉视图.在1.1.1版本这里停止使用，并改为pod‘CJPicker’里的‘CJRelatedPickerRichView’"
  s.homepage     = "https://github.com/dvlproad/CJPopupView"
  s.license      = "MIT"
  s.author             = { "dvlproad" => "studyroad@qq.com" }
  # s.social_media_url   = "http://twitter.com/dvlproad"

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/dvlproad/CJPopupView.git", :tag => "CJFile_0.0.2" }
  s.source_files  = "CJPopupView/*.{h,m}"
  #s.resources = "CJFile/{png}"
  s.frameworks = 'UIKit'

  s.deprecated = true

end
