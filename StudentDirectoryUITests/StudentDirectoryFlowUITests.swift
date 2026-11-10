import XCTest

final class StudentDirectoryFlowUITests: XCTestCase {
    private var app: XCUIApplication!

    private let adaCellID = "studentCell.00000000-0000-0000-0000-000000000001"

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testLaunchShowsStudentListTitledStudents() {
        XCTAssertTrue(app.navigationBars["Students"].exists)
        XCTAssertTrue(app.tables["studentList"].exists)
        XCTAssertTrue(app.cells[adaCellID].exists)
    }

    func testTappingStudentOpensDetailsWithSubjectButtons() {
        app.cells[adaCellID].tap()

        XCTAssertTrue(app.otherElements["studentDetails"].exists)
        XCTAssertTrue(app.navigationBars["Ada Lovelace"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Algorithms"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Math"].exists)
        XCTAssertTrue(app.buttons["subjectButton.Design"].exists)
    }

    func testTappingSubjectShowsOnlyMatchingStudents() {
        app.cells[adaCellID].tap()
        app.buttons["subjectButton.Math"].tap()

        XCTAssertTrue(app.navigationBars["Math"].exists)
        let cells = app.tables["studentList"].cells
        XCTAssertEqual(cells.count, 3)
        XCTAssertTrue(cells["studentCell.00000000-0000-0000-0000-000000000001"].exists)
        XCTAssertTrue(cells["studentCell.00000000-0000-0000-0000-000000000004"].exists)
        XCTAssertTrue(cells["studentCell.00000000-0000-0000-0000-000000000007"].exists)
    }

    func testBackButtonReturnsFromDetailsToList() {
        app.cells[adaCellID].tap()
        XCTAssertTrue(app.otherElements["studentDetails"].exists)

        app.navigationBars.buttons.element(boundBy: 0).tap()

        XCTAssertTrue(app.navigationBars["Students"].exists)
        XCTAssertTrue(app.tables["studentList"].exists)
    }
}
