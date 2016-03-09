#
# Be sure to run `pod lib lint CMPlayerViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CMPlayerViewController"
  s.version          = "0.1.0"
  s.summary          = "A Customizable Video Player Controller based on AVPlayer"

  s.description      = <<-DESC 
  CMPlayerViewController is a convenient view controller to use AVPlayer in a view controller. It looks like AVPlayerViewController but it is fully customizable ans works on iOS 7 sublime 

  DESC

  s.homepage         = "https://github.com/celian-m/CMPlayerViewController"
  s.screenshots     = "github.com/celian-m/CMPlayerViewController/blob/master/Assets/SC1.png", "https://github.com/celian-m/CMPlayerViewController/blob/master/Assets/SC2.png"
  s.license          = 'Apache'
  s.author           = { "Celian Moutafis" => "celian@mouce.fr" }
  s.source           = { :git => "https://github.com/celian-m/CMPlayerViewController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/celian_m

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'CMPlayerViewController' => ['Pod/Assets/*.xib', 'Pod/Assets/*.xcassets/*']
  }

end
