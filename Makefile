build: 
	swift build
	
test:
	swift test

lint:
	swiftlint --strict

fix_lint: 
	swiftlint --fix

doc: 
	jazzy -c
