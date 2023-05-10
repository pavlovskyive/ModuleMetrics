xcodebuild -project ModuleMetrics.xcodeproj -scheme ModuleMetrics -configuration Release -arch arm64 clean build -derivedDataPath ./build/silicone/

echo "\nCopying executable to /usr/local/bin...\nMay need root password..."
sudo cp ./build/silicone/Build/Products/Release/ModuleMetrics /usr/local/bin/swift-metrics
echo "\n** COPY COMPLETED **"

echo "\nRemoving left-overs..."
sudo rm -rf ./build

echo "\n** INSTALLATION COMPLETED **"
echo "\nSee github repo (https://github.com/pavlovskyive/ModuleMetrics) for tips and uses."