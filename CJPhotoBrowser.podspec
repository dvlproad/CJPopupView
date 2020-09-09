Pod::Spec.new do |s|
  #验证方法1：pod lib lint CJPhotoBrowser.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/dvlproadSpecs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint CJPhotoBrowser.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  #提交方法： pod repo push dvlproad CJPhotoBrowser.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  s.name         = "CJPhotoBrowser"
  s.version      = "0.1.0"
  s.summary      = "自定义的“图片浏览器"
  s.homepage     = "https://github.com/dvlproad/CJPopupView"

  s.description  = <<-DESC
                  *、CJPhotoBrowser：自定义的“图片浏览器CJPhotoBrowser”
                  
                   A longer description of CJPhotoBrowser in Markdown format.

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

  s.platform     = :ios, "8.0"
 
  s.source       = { :git => "https://github.com/dvlproad/CJPopupView.git", :tag => "CJPhotoBrowser_0.1.0" }
  # s.source_files  = "CJPhotoBrowser/*.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  
  s.source_files = "CJPhotoBrowser/**/*.{h,m}"
  s.resources = "CJPhotoBrowser/**/*.{png,xib,bundle}"

  s.dependency 'Masonry'
  s.dependency 'MBProgressHUD'
  s.dependency 'SDWebImage'
  
end
