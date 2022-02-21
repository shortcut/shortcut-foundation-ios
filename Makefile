build: 
	swift build
	
test:
	swift test

lint:
	swiftlint --strict

fix_lint: 
	swiftlint autocorrect

doc: 
	jazzy -c