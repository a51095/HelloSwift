platform :ios, '11.0'
inhibit_all_warnings!
use_frameworks!
source "https://cdn.cocoapods.org/"

def commonPods

  #swift
  pod 'SnapKit', '5.0.1'
  pod 'Kingfisher', '5.15.8'
  pod 'HandyJSON', '5.0.2'
  pod 'Alamofire', '5.4.1'
  pod 'KeychainAccess', '4.2.1'
  pod 'Cache', '5.3.0'

  #辅助工具
  pod 'LookinServer', :configurations => ['Debug']
end

target 'HelloSwift' do
  commonPods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] ='11.0'
    end
  end
end

