#!/bin/bash
set -e

echo "🔧 Fixing iOS Build Issues..."

# Step 1: Clean everything
echo "📦 Cleaning build arifacts..."
flutter clean

# Step 2: Remove iOS build cache
echo "🗑️  Removing iOS build cache..."
cd ios
rm -rf Pods Podfile.lock .symlinks Flutter/Flutter.podspec Flutter/Flutter.framework build/ .dart_tool/

# Step 3: Reset pod repo
pod repo update --silent || true

# Step 4: Get Flutter dependencies
cd ..
flutter pub get

# Step 5: Regenerate iOS files
cd ios
pod install --repo-update

echo "✅ iOS Build Fixed! Ready to run: flutter run"
