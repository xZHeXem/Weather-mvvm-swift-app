# Podfile
#source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0' # or platform :osx, '10.10' if your target is OS X.
use_frameworks!

target 'Weather' do
    pod 'RxSwift'
    pod 'RxCocoa'
    
    pod 'Swinject'
    pod 'SwinjectStoryboard'

    pod 'Alamofire', '~> 5.2'
end

# RxTest and RxBlocking make the most sense in the context of unit/integration tests
target 'WeatherTests' do
    pod 'RxBlocking'
    pod 'RxTest'
end

