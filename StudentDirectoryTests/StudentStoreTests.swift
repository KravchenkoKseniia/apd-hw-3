import XCTest
@testable import StudentDirectory

final class StudentStoreTests: XCTestCase {

    func testFilterBySubjectReturnsOnlyMatchingStudentsInStoreOrder() {
        let store = StudentStore()

        let names = store.students(matchingSubject: "Math").map(\.name)

        XCTAssertEqual(names, ["Ada Lovelace", "Katherine Johnson", "Donald Knuth"])
    }

    func testFilterIsCaseSensitive() {
        let store = StudentStore()
        
        XCTAssertTrue(!store.students(matchingSubject: "Math").isEmpty)
        XCTAssertTrue(store.students(matchingSubject: "math").isEmpty)
        XCTAssertTrue(store.students(matchingSubject: "MATH").isEmpty)
    }

    func testFilterWithUnknownSubjectReturnsEmptyAndDoesNotChangeStore() {
        let store = StudentStore()
        let before = store.students

        let result = store.students(matchingSubject: "Chemistry")

        XCTAssertTrue(result.isEmpty)
        XCTAssertEqual(store.students, before)
    }

    func testFilterWorksWithInjectedStudents() {
        let first = Student(id: UUID(), name: "First", age: 20, averageGrade: 80,
                            isScholarshipHolder: false, subjects: ["Art"], avatarName: "avatar-default")
        let second = Student(id: UUID(), name: "Second", age: 21, averageGrade: 90,
                             isScholarshipHolder: true, subjects: ["Music", "Art"], avatarName: "avatar-default")
        let third = Student(id: UUID(), name: "Third", age: 22, averageGrade: 70,
                            isScholarshipHolder: false, subjects: ["Music"], avatarName: "avatar-default")
        let store = StudentStore(students: [first, second, third])

        XCTAssertEqual(store.students(matchingSubject: "Art"), [first, second])
        XCTAssertEqual(store.students(matchingSubject: "Music"), [second, third])
    }
}
