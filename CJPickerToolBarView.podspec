Pod::Spec.new do |s|
  s.name         = "CJPickerToolBarView"
  s.version      = "0.0.4"
  s.summary      = "一个含toolBar的picker。在0.0.4版本这里停止使用，并改为pod‘CJPicker’中的CJToolbar与对应的picker结合使用"
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
