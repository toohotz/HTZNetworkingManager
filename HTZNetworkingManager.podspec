
#  Be sure to run `pod spec lint HTZNetworkingManager.podspec' to validate

Pod::Spec.new do |s|

s.name         = "HTZNetworkingManager"
s.version      = "0.1.0"
s.summary      = "A personal networking manager built to allow easier data parsing using Alamofire."

    s.license      = { :type => 'MIT',
    :text => <<-LICENSE
    Please consider promoting this project if you find it useful.
    The MIT License (MIT)
    Copyright (c) 2015, Kemar White.
    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    LICENSE
    }


s.author             = { "Kemar White" => "toohotz@me.com" }
s.platform     = :ios, "8.0"
s.ios.deployment_target = '8.0'

s.source = { :git => "https://github.com/toohotz/HotzNetworkingManager.git", :tag => "#{s.version}" }
s.homepage = "https://github.com/toohotz/HotzNetworkingManager"

s.source_files  =  "HTZNetworkingManager/**/*.{swift}"

s.framework  = "UIKit"

s.requires_arc = true

# s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
s.dependency "Alamofire"

end
