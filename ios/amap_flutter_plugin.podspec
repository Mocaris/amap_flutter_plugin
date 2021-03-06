#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint amap_flutter_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'amap_flutter_plugin'
  s.version          = '0.0.1'
  s.summary          = '高德插件'
  s.description      = <<-DESC
高德插件
                       DESC
  s.homepage         = 'https://github.com/Mocaris/amap_flutter_plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'imocaris@outlook.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'AMapSearch'
  s.platform = :ios, '9.0'
  s.static_framework = true
  # Flutter.framework does not contain a i386 slice.
  #s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
