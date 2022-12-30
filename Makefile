build: 
	swift build
	
test:
	swift test

lint:
	swiftlint --strict

fix-lint: 
	swiftlint --fix

doc: 
	jazzy -c
