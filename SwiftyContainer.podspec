#
#  Be sure to run `pod spec lint SwiftyContainer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "SwiftyContainer"
  spec.version      = "0.0.3"
  spec.summary      = "Simple animation SwiftyContainer."
  spec.homepage     = "https://github.com/jungseungyeo/SwiftyContainer"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "jungseungyeo" => "duwjdtmd91@gmail.com" }
  spec.source       = { :git => "https://github.com/jungseungyeo/SwiftyContainer.git", :tag => "#{spec.version}" }
  spec.source_files  = "SwiftyContainer/SwiftyContainer/Source/*.swift"
  spec.requires_arc  = true
  spec.swift_version = "5.0"
  spec.ios.deployment_target = "11.0"
end
