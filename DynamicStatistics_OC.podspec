#
# Be sure to run `pod lib lint DynamicStatistics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DynamicStatistics_OC'
  s.version          = '0.4.6'
  s.summary          = 'A library helps to collect user action data easily'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A library helps to collect user action data easily.
                       DESC

  s.homepage         = 'https://github.com/davidli86/DynamicStatistics'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'David' => '492334421@qq.com' }
  s.source           = { :git => 'git@github.com:davidli86/DynamicStatistics.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DynamicStatistics/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DynamicStatistics' => ['DynamicStatistics/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Security'
  s.dependency 'SAMKeychain'
end
