import XCTest
@testable import ShortcutFoundation

final class TaskFlowTests: XCTestCase {
    enum TestTaskError: Error {
        case genericError
        case expectedIntegerPreviousResult
    }
    
    func test_execute_and_complete_a_task() {
        let task = Task { flow, _ in
            flow.finish()
        }
        
        let exp = expectation(description: "Wait for task completion")
        
        let sequence = TaskSequence(tasks: task)
        sequence.whenDone { state in
            switch state {
            case .finished:
                exp.fulfill()
            default:
                fatalError()
            }
        }
        
        sequence.start()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_execute_and_cancel_a_task() {
        let task = Task { flow, _ in
            flow.cancel()
        }
        
        let exp = expectation(description: "Wait for task completion")
        
        let sequence = TaskSequence(tasks: task)
        sequence.whenDone { state in
            switch state {
            case .canceled:
                exp.fulfill()
            default:
                fatalError()
            }
        }
        
        sequence.start()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_execute_and_finish_a_task_with_an_error() {
        let task = Task { flow, _ in
            flow.finish(TestTaskError.genericError)
        }
        
        let exp = expectation(description: "Wait for task completion")
        
        let sequence = TaskSequence(tasks: task)
        sequence.whenDone { state in
            switch state {
            case .failed(let error):
                if case TestTaskError.genericError = error {
                     exp.fulfill()
                } else {
                    fatalError()
                }
            default:
                fatalError()
            }
        }
        
        sequence.start()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_execute_and_complete_a_task_passing_a_result() {
        let expectedResult = 2112
        
        let task = Task { flow, _ in
            flow.finish(expectedResult)
        }
        
        let exp = expectation(description: "Wait for task completion")
        
        let sequence = TaskSequence(tasks: task)
        sequence.whenDone { state in
            switch state {
            case .finished(let result):
                guard let result = result as? Int else {
                    fatalError()
                }
                
                XCTAssertNotNil(result)
                XCTAssertEqual(expectedResult, result)
                exp.fulfill()
            default:
                fatalError()
            }
        }
        
        sequence.start()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_execute_and_complete_a_two_tasks_passing_a_result() {
        let expectedResult = 4
        let initialResult = 2
        let secondResult = 2
        
        let firstTask = Task { flow, _ in
            flow.finish(initialResult)
        }
        
        let secondTask = Task { flow, previousResult in
            guard let previousResult = previousResult as? Int else {
                flow.finish(TestTaskError.expectedIntegerPreviousResult)
                return
            }
            flow.finish(previousResult + secondResult)
        }
        
        let exp = expectation(description: "Wait for task completion")
        
        let sequence = TaskSequence(tasks: firstTask, secondTask)
        sequence.whenDone { state in
            switch state {
            case .finished(let result):
                guard let result = result as? Int else {
                    fatalError()
                }
                
                XCTAssertNotNil(result)
                XCTAssertEqual(expectedResult, result)
                exp.fulfill()
            default:
                fatalError()
            }
        }
        
        sequence.start()
        
        wait(for: [exp], timeout: 1.0)
    }
}
