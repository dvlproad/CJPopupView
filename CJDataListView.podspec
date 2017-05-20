Pod::Spec.new do |s|
  s.name         = "CJDataListView"
  s.version      = "1.3.0"
  s.summary      = "一个类似美团下拉视图的使用.在1.3.0版本这里停止使用，并改为pod‘CJPicker中的CJRelatedPickerRichView与CJRadioButtons结合使用"
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
