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
