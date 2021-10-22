use_frameworks!
inhibit_all_warnings!
platform :ios, '12.0'
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
  pod 'Tiercel', '3.2.5'
  pod 'Alamofire', '5.4.3'
  pod 'HandyJSON', '5.0.2'
  pod 'Kingfisher', '6.3.1'
  pod 'KeychainAccess', '4.2.2'
end

target 'HelloSwift' do
  ocPods
  swiftPods
  debugPods
end
