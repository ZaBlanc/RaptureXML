Pod::Spec.new do |s|
  s.name          = 'RaptureXML@Gilt'
  s.version       = '1.0.10'
  s.license       = 'MIT'
  s.summary       = 'A simple, sensible, block-based XML API for iOS and Mac development.'
  s.description   = 'Forked by Gilt Groupe to allow access to the xml property of the RXMLElement class from within CocoaPods.'
  s.homepage      = 'https://github.com/ZaBlanc/RaptureXML'
  s.author        = { 'John Blanco' => 'zablanc@gmail.com' }
  s.source        = { :git => 'https://github.com/emaloney/RaptureXML.git', :tag => s.version.to_s }
  s.source_files  = 'RaptureXML/*'
  s.module_name   = 'RaptureXML'
  s.header_dir    = 'RaptureXML'

  s.libraries     = 'z', 'xml2'
  s.xcconfig      = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  s.requires_arc  = true
end
