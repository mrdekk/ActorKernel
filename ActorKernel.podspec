Pod::Spec.new do |s|
  s.name         = "ActorKernel"
  s.version      = "0.1.0"
  s.summary      = "Actors implementation on swift"
  s.homepage     = "http://github.com/mrdekk/ActorKernel"
  s.license      = "MIT"
  s.author       = { "MrDekk" => "mrdekk@yandex.ru" }
  s.source       = { :git => "http://github.com/mrdekk/ActorKernel.git", :tag => "#{s.version}" }
  s.source_files  = "ActorKernel/Classes/**/*.{h,m,swift}"
  s.requires_arc = true
end
