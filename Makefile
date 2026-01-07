# Makefile for BridgeApp

PROJECT = BridgeApp.xcodeproj
SCHEME = BridgeApp
DESTINATION = 'platform=iOS Simulator,name=iPhone 15,OS=latest'

default: build

build:
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination $(DESTINATION) build

clean:
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) clean

test:
	# Note: Tests are currently disabled in the project file to resolve conflicts
	# xcodebuild -project $(PROJECT) -scheme $(SCHEME) -destination $(DESTINATION) test

run:
	xcrun simctl boot "iPhone 15" || true
	xcrun simctl install "iPhone 15" $(shell xcodebuild -project $(PROJECT) -scheme $(SCHEME) -configuration Debug -sdk iphonesimulator -destination $(DESTINATION) -showBuildSettings | grep -m 1 "CODESIGNING_FOLDER_PATH" | cut -d = -f 2)
	xcrun simctl launch "iPhone 15" BreeInTech.BridgeApp
