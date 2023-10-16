#  s.resources = ['Classes/PhotoBrowser/resource/ZLPhotoBrowser.bundle','Classes/AKGallery/*.png']

# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html

#  s.resource = 'Classes/PhotoBrowser/resource/ZLPhotoBrowser.bundle'

Pod::Spec.new do |s|
  s.name             = 'image_pickers'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.resources = ['Assets/*.png']
  s.dependency 'Flutter'
  s.dependency 'AFNetworking'
  s.dependency 'SDWebImage'
  s.dependency 'ZLPhotoBrowser', '~> 4.4.5'
  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end


