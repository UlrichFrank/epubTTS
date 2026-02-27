#!/bin/bash
set -e

# Instead of creating manually, let me update the Podfile to not require a project initially
# Then use CocoaPods to create the workspace

cat > Podfile << 'EOF'
platform :ios, '15.0'

target 'epubTTS' do
  use_frameworks!
  
  # Core dependencies
  pod 'Readium', '~> 2.0'
  
  # Testing
  target 'epubTTSTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['SWIFT_VERSION'] = '5.9'
    end
  end
end
EOF

echo "✅ Podfile updated"
