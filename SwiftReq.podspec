Pod::Spec.new do |s|
    s.name             = 'SwiftReq'
    s.version          = '1.1.1'
    s.summary          = 'The Swift library makes it easier to perform network requests with RESTful APIs.'
    s.homepage         = 'https://github.com/duynguyen02/SwiftReq'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Duy Nguyen' => 'mailto:duynguyen02.dev@gmail.com' }
    s.source           = { :git => 'https://github.com/duynguyen02/SwiftReq', :tag => s.version.to_s }
    
    s.platform        = :ios, '13.0'
    s.source_files     = 'Sources/**/*.swift'
    s.swift_version    = '5.0'
    s.dependency 'Alamofire', '~> 5.9.1'
end
