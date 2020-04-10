source 'https://github.com/CocoaPods/Specs.git'
target 'BaseProject' do
platform :ios, '9.0'
pod 'SVProgressHUD'
pod 'MJRefresh'
pod 'AFNetworking'
pod 'Masonry'
pod 'YYKit'
pod 'IQKeyboardManager'
pod 'ZYBannerView'
pod 'BRPickerView'
#bug统计
pod 'Bugly'

#友盟
#基础库
pod 'UMCCommon'
pod 'UMCSecurityPlugins'
##统计
pod 'UMCAnalytics'
#rac信号量
pod 'ReactiveObjC'
#内存泄露检测工具
#pod 'MLeaksFinder'
#蘑菇街组件
pod 'MGJRouter'
#钥匙串保存数据
pod 'UICKeyChainStore'
pod 'WechatOpenSDK','1.8.4'
pod 'SJBaseVideoPlayer'
#pod 'GQImageViewer'
pod 'GQImageVideoViewer'
pod "Qiniu", "~> 7.3"
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end

