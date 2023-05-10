xcodebuild -project ModuleMetrics.xcodeproj -scheme ModuleMetrics -configuration Release -arch x86_64 clean build -derivedDataPath ./build/intel/

echo "\nCopying executable to /usr/local/bin... May need root password..."
sudo cp ./build/silicone/Build/Products/Release/ModuleMetrics /usr/local/bin/swift-metrics
echo "** COPY COMPLETED **"

echo "\nRemoving left-overs..."
sudo rm -rf ./build

echo "\n** INSTALLATION COMPLETED! **"
echo "\nSee github repo (https://github.com/pavlovskyive/ModuleMetrics) for tips and uses."