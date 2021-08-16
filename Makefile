destination = "platform=iOS Simulator,OS=13.1,name=iPhone 11"
libraryName = ShortcutFoundation
projectName = "$(libraryName).xcodeproj"
packageName = "$(libraryName)-Package"
derivedDataPath = "./xctest"

build_scope:
	xcodebuild -scheme $(packageName) -destination $(destination) | xcpretty

build: project build_scope clear
	
test_scope:
	set -o pipefail && xcodebuild -scheme $(packageName) -enableCodeCoverage YES -destination $(destination) test | xcpretty

build_for_testing_ci:
	set -o pipefail && xcodebuild -scheme $(packageName) -enableCodeCoverage YES -derivedDataPath $(derivedDataPath) -destination $(destination) build-for-testing | xcpretty

test_scope_ci:
	set -o pipefail && xcodebuild -scheme $(packageName) -enableCodeCoverage YES -derivedDataPath $(derivedDataPath) -destination $(destination) test-without-building | xcpretty -r junit

test: test_scope clear

build_unit_tests_ci: build_for_testing_ci clear

test_ci: test_scope_ci clear

lint_scope:
	swiftlint --strict
	
lint_autocorrect_scope:
	swiftlint autocorrect

lint: lint_scope clear

fixlint: lint_autocorrect_scope clear

jazzy_scope:
	jazzy -c

jazzy: jazzy_scope clear