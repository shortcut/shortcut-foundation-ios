build: 
	swift build
	
test:
	swift test

lint:
	swiftlint --strict

fix_lint: 
	swiftlint --fix --format

doc: 
	jazzy -c
