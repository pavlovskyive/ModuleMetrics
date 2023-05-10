xcodebuild -project ModuleMetrics.xcodeproj -scheme ModuleMetrics -configuration Release -arch arm64 clean build -derivedDataPath ./build/silicone/
sudo cp ./build/silicone/Build/Products/Release/ModuleMetrics /usr/local/bin/swift-metrics
sudo rm -rf ./build