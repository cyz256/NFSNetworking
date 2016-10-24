Pod::Spec.new do |s|
  s.name         = "NFSNetworking"
  s.version      = "0.0.1"
  s.summary      = "NFSNetworking is a request util based on AFNetworking."
  s.homepage     = "https://github.com/liushixiang/NFSNetworking"
  s.license      = "MIT"
  s.author       = { "liushixiang" => "meatandgirl@qq.com",
                      "cyz256" => "cyz256@qq.com"
                    }
  s.source       = { :git => "http://github.com/liushixiang/NFSNetworking.git", :tag => "#{s.version}" }

  s.source_files  = "NFSNetworking/*.{h,m}"
  s.platform      = :ios, '7.0'
  s.requires_arc  = true
  s.source_files  = "NFSNetworking/*.{h,m}"
  s.dependency "AFNetworking", "~> 3.0"
end
