Pod::Spec.new do |s|
  s.name         = "SCNNodeVisualDebugger"
  s.version      = "0.0.2"
  s.summary      = "SCNNodeVisualDebugger in Swift"
  s.homepage     = "https://github.com/CommanderPho/SCNNodeVisualDebugger"
  s.license      = "Apache 2.0 license"
  s.author       = { "Andrey Arzhannikov" => "andreya@handsome.is" }

  # s.platform     = :ios, "9.0"
  s.ios.deployment_target  = '9.0'
  s.osx.deployment_target  = '10.10'

  s.source       = { :git => "https://github.com/CommanderPho/SCNNodeVisualDebugger.git", :branch => "develop" }

  s.source_files  = "Sources/*.swift"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

end