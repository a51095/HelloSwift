platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!
source "https://cdn.cocoapods.org/"

#Debug
def debugPods
  pod 'LookinServer', :configurations => ['Debug']
end

#Object-C
def ocPods
  pod 'MJRefresh', '3.7.2'
end

#Swift
def swiftPods
  pod 'Cache', '6.0.0'
  pod 'R.swift', '5.4.0'
  pod 'SnapKit', '5.0.1'
  pod 'HandyJSON', '5.0.2'
  pod 'Alamofire', '5.4.3'
  pod 'Kingfisher', '6.3.1'
  pod 'KeychainAccess', '4.2.2'
end

target 'HelloSwift' do
  ocPods
  swiftPods
  debugPods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] ='11.0'
    end
  end
end

