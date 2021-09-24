import XCTest
@testable import ShortcutFoundation

final class EventDispatchTests: XCTestCase {

    struct TestEvent: IEvent {
        var type: String

        init(type: String) {
            self.type = type
        }
    }

    struct MyEvents {
        static let eventOneName = "eventOne"
        static let eventTwoName = "eventTwo"

        static let eventOne = TestEvent(type: MyEvents.eventOneName)
        static let eventTwo = TestEvent(type: MyEvents.eventTwoName)
    }

    func test_one_event_dispatched() {
        let expc = XCTestExpectation(description: "test_event_one_dispatched")
        let handler: ((IEvent) -> Void) = { event in
            XCTAssertEqual(event.type, MyEvents.eventOneName)
            expc.fulfill()
        }
        let eventDispatcher = EventDispatcher()
        eventDispatcher.addEventListener(forType: MyEvents.eventOne.type,
                                         handler: handler)
        eventDispatcher.dispatchEvent(event: MyEvents.eventOne)
        wait(for: [expc], timeout: 1.0)
    }

    func test_multiple_events_added() {
        let handler: ((IEvent) -> Void) = { _ in }
        let eventDispatcher = EventDispatcher()
        eventDispatcher.addEventListener(forType: MyEvents.eventOne.type,
                                         handler: handler)
        eventDispatcher.addEventListener(forType: MyEvents.eventTwo.type,
                                         handler: handler)
        XCTAssertTrue(eventDispatcher.hasEventListener(forType: MyEvents.eventOne.type))
        XCTAssertTrue(eventDispatcher.hasEventListener(forType: MyEvents.eventTwo.type))
    }

    func test_multiple_handlers_added() {
        let handler1: ((IEvent) -> Void) = { _ in }
        let handler2: ((IEvent) -> Void) = { _ in }
        
        let eventDispatcher = EventDispatcher()
        eventDispatcher.addEventListener(forType: MyEvents.eventOne.type,
                                         handler: handler1)
        eventDispatcher.addEventListener(forType: MyEvents.eventOne.type,
                                         handler: handler2)

        

        XCTAssertTrue(eventDispatcher.hasEventListener(forType: MyEvents.eventOne.type))
    }

    func test_event_added_to_dispatcher() {
        let handler: ((IEvent) -> Void) = { event in }
        let eventDispatcher = EventDispatcher()
        eventDispatcher.addEventListener(forType: MyEvents.eventOne.type, handler: handler)
        XCTAssertTrue(eventDispatcher.hasEventListener(forType: MyEvents.eventOne.type))
    }

    func test_event_removed_from_dispatcher() {
        let handler: ((IEvent) -> Void) = { event in }
        let eventDispatcher = EventDispatcher()
        eventDispatcher.addEventListener(forType: MyEvents.eventOne.type, handler: handler)
        eventDispatcher.removeEventListener(forType: MyEvents.eventOne.type)
        XCTAssertFalse(eventDispatcher.hasEventListener(forType: MyEvents.eventOne.type))
    }
}
