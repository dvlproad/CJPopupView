Pod::Spec.new do |s|

  s.name         = "CJPopupView"
  s.version      = "2.0.1"
  s.summary      = "自定义的几乎所有弹出视图"
  s.homepage     = "https://github.com/dvlproad/CJPopupView"

  s.description  = <<-DESC
                  1、CJPopoverView带箭号的弹出视图：a pop view with arrow
                  2、CJDragView 可悬浮拖动的视图

                   A longer description of CJPopupAction in Markdown format.

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

  s.author   = { "lichq" => "" }

  s.platform     = :ios, "7.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJPopupView.git", :tag => "CJDragView_0.0.1" }
  # s.source_files  = "CJPopupView/*.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.subspec 'CJPopoverView' do |ss|
    ss.source_files = "CJPopoverView/**/*.{h,m}"
    # ss.resources = "CJPopoverView/**/*.{png,xib}"
  end

  s.subspec 'CJDragView' do |ss|
    ss.source_files = "CJDragView/**/*.{h,m}"
    # ss.resources = "CJDragView/**/*.{png,xib}"
  end

end
