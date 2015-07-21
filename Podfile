# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!

target 'BrewBuddy' do

pod 'MZFormSheetPresentationController', '~> 1.0.1'
pod 'HCSStarRatingView', :git => 'https://github.com/hugocampossousa/HCSStarRatingView.git'
pod 'TPKeyboardAvoiding', '~> 1.2.7'
pod 'HanekeSwift'
pod 'SVProgressHUD'
pod 'ReachabilitySwift', :git => 'https://github.com/ashleymills/Reachability.swift'

end

target 'BrewBuddyTests' do

end

post_install do |installer|
    puts 'Removing static analyzer support'
    installer.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['OTHER_CFLAGS'] = "$(inherited) -Qunused-arguments -Xanalyzer -analyzer-disable-all-checks"
        end
    end
end

