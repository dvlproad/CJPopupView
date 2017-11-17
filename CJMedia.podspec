Pod::Spec.new do |s|

  s.name         = "CJMedia"
  s.version      = "0.0.5"
  s.summary      = "自定义的多媒体(相册、图片、视频等)相关组件"
  s.homepage     = "https://github.com/dvlproad/CJPopupView"

  s.description  = <<-DESC
                  *、UIImagePickerControllerUtil：系统的相册选择器与查看器;
                  *、CJImagePicker：自定义的“图片选择器CJImagePickerViewController”
                  *、CJPhotoBrowser：自定义的“图片浏览器CJPhotoBrowser”
                  *、CJAlumbViewController：自定义的相册列表

                   A longer description of CJMedia in Markdown format.

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
 
  s.source       = { :git => "https://github.com/dvlproad/CJPopupView.git", :tag => "CJMedia_0.0.5" }
  # s.source_files  = "CJMedia/*.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

  s.subspec 'CJValidateAuthorizationUtil' do |ss|
    ss.source_files = "CJMedia/CJValidateAuthorizationUtil/**/*.{h,m}"
    ss.frameworks = "AssetsLibrary", "Photos", "AVFoundation", "CoreLocation"
  end

  s.subspec 'MySingleImagePickerController' do |ss|
    ss.source_files = "CJMedia/MySingleImagePickerController/**/*.{h,m}"
    #ss.frameworks = "MediaPlayer"

    ss.dependency 'CJMedia/CJValidateAuthorizationUtil'
  end

  
  s.subspec 'CJPhotoBrowser' do |ss|
    ss.source_files = "CJMedia/CJPhotoBrowser/**/*.{h,m}"
    ss.resources = "CJMedia/CJPhotoBrowser/**/*.{png,xib,bundle}"

    ss.dependency 'CJMedia/CJValidateAuthorizationUtil'
    ss.dependency 'Masonry'
    ss.dependency 'MBProgressHUD'
    ss.dependency 'SDWebImage'
  end

end
