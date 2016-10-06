source 'https://github.com/CocoaPods/Specs.git'

platform :ios, :deployment_target => 8.0

use_frameworks!

def shared_pods
    pod 'CryptoSwift', :git => "https://github.com/krzyzanowskim/CryptoSwift", :branch => "swift2"
end

target 'SMASaveSystem' do
   shared_pods
end

target 'SMASaveSystemTests' do
    shared_pods
end
