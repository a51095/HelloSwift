use_frameworks!
inhibit_all_warnings!
platform :ios, '12.0'
source 'https://cdn.cocoapods.org/'

# Debug
def debugPods
  pod 'SwiftLint', '0.55.1'
  pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']
end

# Objective-C
def ocPods
  pod 'MJRefresh', '3.7.9'
end

# Swift
def swiftPods
  pod 'Cache', '6.0.0'
  pod 'SnapKit', '5.7.1'
  pod 'Alamofire', '5.9.1'
  pod 'Kingfisher', '7.12.0'
  pod 'SmartCodable', '4.2.0'
  pod 'JXSegmentedView', '1.4.1'
  pod 'JXPagingView/Paging','2.1.3'
end

target 'HelloSwift' do
  ocPods
  swiftPods
  debugPods
end
