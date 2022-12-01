Pod::Spec.new do |s|
  s.name                  = 'JudoKit-iOS'
  s.version               = '3.1.10'
  s.summary               = 'Judo Pay Full iOS Client Kit'
  s.homepage              = 'https://www.judopay.com/'
  s.license               = 'MIT'
  s.author                = { "Judopay" => 'developersupport@judopayments.com' }
  s.source                = { :git => 'https://github.com/Judopay/JudoKit-iOS.git', :tag => 'v' +  s.version.to_s }

  s.documentation_url     = 'https://docs.judopay.com'

  s.ios.deployment_target = '11.0'
  s.requires_arc          = true
  s.source_files          = 'Source/**/*.{m,h}'
  s.exclude_files         = 'Source/include/'

  s.dependency 'DeviceDNA', '~> 2.0.0'
  s.dependency 'TrustKit'
  s.dependency 'ZappMerchantLib'
  s.dependency 'Judo3DS2_iOS', '~> 1.1.3'

  s.frameworks            = 'CoreLocation', 'Security', 'CoreTelephony', 'Vision'
  s.resource_bundles      = { "JudoKit_iOS" => ["Resources/*.lproj/*.strings"] }
  s.resources             = ['Resources/judokit-icons.bundle', 'Resources/judokit-resources.bundle', 'Resources/judokit-countries-list.json']
end
