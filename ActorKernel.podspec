Pod::Spec.new do |s|
  s.name         = "ActorKernel"
  s.version      = "0.1.0"
  s.summary      = "Actors implementation on swift"
  s.homepage     = "http://github.com/mrdekk/ActorKernel"
  s.license      = "MIT"
  s.author       = { "MrDekk" => "mrdekk@yandex.ru" }
  s.source       = { :git => "https://github.com/mrdekk/ActorKernel.git", :tag => "#{s.version}" }
  s.source_files  = "ActorKernel/Classes/**/*.{h,m,swift}"
  
  s.requires_arc = true

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = '9.0'
end
