import XCTest
@testable import ShortcutFoundation

protocol Animal {
    func walk()
}

struct Dog: Animal {
    func walk() {

    }
}

class BasicInjection {
    @OptionalInject var pet: Animal?
}

struct AppConfig: Config {
    func configure(_ injector: Injector) {
        injector.map(Animal.self) {
            Dog()
        }
    }
}

final class InjectionTests: XCTestCase {
    let context = Context()

    func test_injection() {
        inject()
        let sut = BasicInjection()
        XCTAssertNotNil(sut.pet)
    }

    func test_unmap() {
        inject()
        let sut = BasicInjection()
        XCTAssertNotNil(sut.pet)

        Injector.main.unmap(Animal.self)

        let unmappedSut = BasicInjection()
        XCTAssertNil(unmappedSut.pet)
    }

    private func inject() {
        context.configure(AppConfig()) {}
    }

    static var allTests = [
        ("test_injection", test_injection)
    ]
}
