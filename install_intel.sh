xcodebuild -project ModuleMetrics.xcodeproj -scheme ModuleMetrics -configuration Release -arch x86_64 clean build -derivedDataPath ./build/intel/
sudo cp ./build/silicone/Build/Products/Release/ModuleMetrics /usr/local/bin/swift-metrics
sudo rm -rf ./build