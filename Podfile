use_frameworks!
inhibit_all_warnings!
platform :ios, '12.0'
source 'https://cdn.cocoapods.org/'

#Debug
def debugPods
	pod 'LookinServer', :subspecs => ['Swift'], :configurations => ['Debug']
end

#Objective-C
def ocPods
  pod 'MJRefresh', '3.7.8'
end

#Swift
def swiftPods
  pod 'Cache', '6.0.0'
  pod 'SnapKit', '5.7.1'
  pod 'Alamofire', '5.9.0'
  pod 'HandyJSON', '5.0.4-beta'
  pod 'Kingfisher', '7.11.0'
end

target 'HelloSwift' do
  ocPods
  debugPods
  swiftPods
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
		end
	end
end
