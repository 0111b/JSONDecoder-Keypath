		  
Pod::Spec.new do |s|

	s.name         = "JSONDecoder-Keypath"
	s.version      = "0.1.0"
	s.summary      = "Add nested key path support to the JSONDecoder"
	s.description  = <<-DESC
	                 Add nested key path support to the Foundation.JSONDecoder
	                 DESC
	s.homepage     = "https://github.com/0111b/JSONDecoder-Keypath"  
	s.license      = "MIT"
	s.author             = { "Alexandr Goncharov" => "adanfermer@gmail.com" }
	s.social_media_url   = "http://twitter.com/0111b"
	s.platform     = :ios, "10.0"
	s.source       = { :git => "https://github.com/0111b/JSONDecoder-Keypath.git", :tag => "#{s.version}" }
	s.source_files  = "Sources/*/*"

end