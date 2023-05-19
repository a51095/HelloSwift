use_frameworks!
inhibit_all_warnings!
platform :ios, '12.0'
source 'https://cdn.cocoapods.org/'

#Debug
def debugPods
  pod 'LookinServer', :configurations => ['Debug']
  pod 'WoodPeckeriOS', :configurations => ['Debug']
end

#Objective-C
def ocPods
  pod 'MJRefresh', '3.7.5'
end

#Swift
def swiftPods
  pod 'Cache', '6.0.0'
  pod 'SnapKit', '5.6.0'
  pod 'Alamofire', '5.7.1'
  pod 'HandyJSON', '5.0.2'
  pod 'Kingfisher', '7.6.2'
end

target 'HelloSwift' do
  ocPods
  debugPods
  swiftPods
end
