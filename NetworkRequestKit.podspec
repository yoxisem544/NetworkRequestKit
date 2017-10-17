#
# Be sure to run `pod lib lint NetworkRequestKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NetworkRequestKit'
  s.version          = '2.0.1'
  s.summary          = 'A fabulous way to handle network request.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yoxisem544/NetworkRequestKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yoxisem544' => 'yoxisem544@gmail.com' }
  s.source           = { :git => 'https://github.com/yoxisem544/NetworkRequestKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'NetworkRequestKit/Classes/'
  
  # s.resource_bundles = {
  #   'NetworkRequestKit' => ['NetworkRequestKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.dependency 'Alamofire', '~> 4.5'
  s.dependency 'PromiseKit', '~> 4.4'
  s.dependency 'SwiftyJSON', '~> 4.0.0-alpha'

end
