use_frameworks!
inhibit_all_warnings!
platform :ios, '12.0'
source 'https://cdn.cocoapods.org/'

#Debug
def debugPods
  pod 'SwiftLint', '0.54.0'
	pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']
end

#Objective-C
def ocPods
  pod 'MJRefresh', '3.7.9'
end

#Swift
def swiftPods
  pod 'Cache', '6.0.0'
  pod 'SnapKit', '5.7.1'
  pod 'Alamofire', '5.9.1'
  pod 'HandyJSON', '5.0.0'
  pod 'Kingfisher', '7.11.0'
end

target 'HelloSwift' do
  ocPods
  swiftPods
  debugPods
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
		end
	end
end
