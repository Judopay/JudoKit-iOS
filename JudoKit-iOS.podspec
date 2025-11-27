Pod::Spec.new do |s|
  s.name                  = 'JudoKit-iOS'
  s.version               = '6.1.0'
  s.summary               = 'Judo Pay Full iOS Client Kit'
  s.homepage              = 'https://www.judopay.com/'
  s.license               = 'MIT'
  s.author                = { "Judopay" => 'developersupport@judopayments.com' }
  s.source                = { :git => 'https://github.com/Judopay/JudoKit-iOS.git', :tag => 'v' +  s.version.to_s }

  s.documentation_url     = 'https://docs.judopay.com'

  s.ios.deployment_target = '12.0'
  s.requires_arc          = true
  s.source_files          = 'Source/**/*.{m,h}'
  s.exclude_files         = 'Source/include/'

  s.dependency 'DeviceDNA', '2.1.2'
  s.dependency 'TrustKit', '~> 3.0.7'
  s.dependency 'Judo3DS2_iOS', '1.3.0'
  s.dependency 'RavelinEncrypt', '1.1.2'

  s.frameworks            = 'CoreLocation', 'Security', 'CoreTelephony', 'Vision'
  s.ios.resource_bundle   = {
    'JudoKit_iOS' => 'Source/Resources/**/*.{lproj,png,json,strings,xcprivacy}'
  }
end
