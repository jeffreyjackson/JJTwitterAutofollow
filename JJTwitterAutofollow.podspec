Pod::Spec.new do |spec|
  spec.name         = 'JJTwitterAutofollow'
  spec.version      = '1.0'
  spec.license      = 'MIT'
  spec.summary      = 'A simple class for autofollowing twitter accounts'
  spec.homepage     = 'https://github.com/jeffreyjackson/JJTwitterAutofollow'
  spec.author       = 'Jeffrey Jackson'
  spec.source       = { :git => 'git://github.com/jeffreyjackson/JJTwitterAutofollow.git', :tag => '1.0' }
  spec.source_files = 'JJTwitterAutofollow/Classes/*'
  spec.requires_arc = true
  spec.dependency 'STTwitter'
end
