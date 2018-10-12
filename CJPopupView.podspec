Pod::Spec.new do |s|
  #验证方法：pod lib lint CJPopupView.podspec --allow-warnings --use-libraries --verbose
  s.name         = "CJPopupView"
  s.version      = "2.1.0"
  s.summary      = "自定义的几乎所有弹出视图"
  s.homepage     = "https://github.com/dvlproad/CJPopupView"

  s.description  = <<-DESC
                  - CJPopupView/CJPopoverView：带箭号的弹出视图(a pop view with arrow)
                  - CJPopupView/CJDragView：可悬浮拖动的视图
                  - CJPopupView/CJMaskGuideHUD：镂空的引导视图
                  - CJPopupView/CJMaskGuideView：镂空的引导视图2

                   A longer description of CJPopupView in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  

  #s.license      = {
  #  :type => 'Copyright',
  #  :text => <<-LICENSE
  #            © 2008-2016 Dvlproad. All rights reserved.
  #  LICENSE
  #}
  s.license      = "MIT"

  s.author   = { "dvlproad" => "" }

  s.platform     = :ios, "7.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJPopupView.git", :tag => "CJPopupView_2.1.0" }
  # s.source_files  = "CJPopupView/*.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.subspec 'CJPopoverView' do |ss|
    ss.source_files = "CJPopupView/CJPopoverView/**/*.{h,m}"
    # ss.resources = "CJPopupView/CJPopoverView/**/*.{png,xib}"
  end

  s.subspec 'CJMaskGuideHUD' do |ss|
    ss.source_files = "CJPopupView/CJMaskGuideHUD/**/*.{h,m}"
    ss.resources = "CJPopupView/CJMaskGuideHUD/**/*.{png,xib}"
  end

  s.subspec 'CJMaskGuideView' do |ss|
    ss.source_files = "CJPopupView/CJMaskGuideView/**/*.{h,m}"
    ss.resources = "CJPopupView/CJMaskGuideView/**/*.{png,xib}"
  end

end
