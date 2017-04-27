#
# Be sure to run `pod lib lint PPComLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PPComLib@JL'
  s.version          = '0.1.7.1'
  s.summary          = 'PPCom-iOS-SDK for PPMessage'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/JasonRSTX/ppcom-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JasonLi' => 'rstx_reg@aliyun.com' }
  s.source           = { :git => 'https://github.com/JasonRSTX/ppcom-ios-sdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PPComLib/Classes/**/*'
  #s.source_files = 'PPComLib/Classes/PPComLib.h,PPComLib/Classes/PPSDK.{h,m},PPComLib/Classes/PPSDKConfiguration.{h,m}'
  #s.public_header_files = 'PPComLib/Classes/PPComLib.h,PPComLib/Classes/PPSDK.h,PPComLib/Classes/PPSDKConfiguration.h'
  
  #s.resource_bundles = {
  #   'PPComLibAssets' => ['PPComLib/Assets/*.*']
  #}

  #s.subspec 'api' do |api|
  #  api.source_files = 'PPComLib/Classes/api/**/*.*'
  #  api.public_header_files = 'PPComLib/Classes/api/**/*.h'
  #end
  
  #s.subspec 'bean' do |bean|
  #  bean.source_files = 'PPComLib/Classes/bean/**/*.*'
  #  bean.public_header_files = 'PPComLib/Classes/bean/**/*.h'
  #end
  
  #s.subspec 'controllers' do |controllers|
  #  controllers.source_files = 'PPComLib/Classes/controllers/**/*.*'
  #  controllers.public_header_files = 'PPComLib/Classes/controllers/*.h'
  #end

  #s.subspec 'mock' do |mock|
  #  mock.source_files = 'PPComLib/Classes/mock/**/*.*'
  #  mock.public_header_files = 'PPComLib/Classes/mock/**/*.h'
  #end
  
  #s.subspec 'notification' do |notification|
  #  notification.source_files = 'PPComLib/Classes/notification/**/*.*'
  #  notification.public_header_files = 'PPComLib/Classes/notification/**/*.h'
  #end
  
  #s.subspec 'service' do |service|
  #  service.source_files = 'PPComLib/Classes/service/**/*.*'
  #  service.public_header_files = 'PPComLib/Classes/service/**/*.h'
  #end
  
  #s.subspec 'utils' do |utils|
  #  utils.source_files = 'PPComLib/Classes/utils/**/*.*'
  #  utils.public_header_files = 'PPComLib/Classes/utils/**/*.h'
  #end
  
  #s.subspec 'view' do |view|
  #  view.source_files = 'PPComLib/Classes/view/**/*.*'
  #  view.public_header_files = 'PPComLib/Classes/view/**/*.h'
  #end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 3.0'
  s.dependency 'SDWebImage', '~>3.8.1'
  s.dependency 'PPJTSImageViewController'
  s.dependency 'SocketRocket'
end
