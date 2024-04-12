

Pod::Spec.new do |s|
  s.name             = 'CYNetWorkTool'
  s.version          = '0.1.6'
  s.summary          = 'A short description of CYNetWorkTool.'



  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/mountainpig/CYNetWorkTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mountainpig' => 'huangjingisi@163.com' }
  s.source           = { :git => 'https://github.com/mountainpig/CYNetWorkTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'CYNetWorkTool/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CYNetWorkTool' => ['CYNetWorkTool/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
end
