use_frameworks!
inhibit_all_warnings!
platform :ios, '12.0'
source 'https://cdn.cocoapods.org/'

#Debug
def debugPods
  pod 'LookinServer', :configurations => ['Debug']
end

#Objective-C
def ocPods
  pod 'MJRefresh', '3.7.6'
end

#Swift
def swiftPods
  pod 'Cache', '6.0.0'
  pod 'SnapKit', '5.6.0'
  pod 'Alamofire', '5.8.1'
  pod 'HandyJSON', '5.0.4-beta'
  pod 'Kingfisher', '7.10.0'
end

target 'HelloSwift' do
  ocPods
  debugPods
  swiftPods
end
