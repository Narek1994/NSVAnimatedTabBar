#
# Be sure to run `pod lib lint NSVAnimatedTabBar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NSVAnimatedTabBar'
  s.version          = '0.3.0'
  s.summary          = 'Fully customizable animated tab bar'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Fully customizable animated tab bar, with sub option availability for center item,
Change almost anything you want, sizes, shadows, animations, add a curve for center item, etc...
                       DESC

  s.homepage         = 'https://github.com/Narek1994/NSVAnimatedTabBar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Narek1994' => 'nareksimonyan94@gmail.com' }
  s.source           = { :git => 'https://github.com/Narek1994/NSVAnimatedTabBar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version       = '5.0'
  s.source_files = 'NSVAnimatedTabBar/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NSVAnimatedTabBar' => ['NSVAnimatedTabBar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
