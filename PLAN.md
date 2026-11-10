# HW3 Student Plan

## Starting point

- `Student` model, `StudentStoreError`, ten seed students and avatar assets are supplied and stay unchanged
- `StudentStore` (a `final class`) already exposes `students`,`students(matchingSubject:)` and the bonus `add/update/delete` methods with validation
- `SceneDelegate` shows a placeholder screen built with `NSLayoutConstraint`; it will be replaced

## Approach

**MVC boundary**

- Model: `Student`, `StudentStore`, `StudentSeedData`
- Views: `StudentCell` (reusable `UITableViewCell`) and the detail screen's subviews. Views only render data they are given; they never touch the store
- Controllers:
  - `StudentListViewController(store:subject:)`: one controller for both the full list and the subject-filtered list
  - `StudentDetailViewController(store:studentID:)`: shows every field and one button per subject

**One shared `StudentStore`**

- `SceneDelegate` creates exactly one `StudentStore()` and injects it through initializers into every controller it pushes
- Controllers do not keep their own copies of the student array - the single source of truth lets the screens stay correct

**Navigation**

- `UINavigationController` root → list → tap row → push detail → tap subject button → push filtered list → tap row → detail again. The back button is the system default.

**Subject filtering and how it is tested**

- Filtering is done only by `StudentStore.students(matchingSubject:)`: an exact, case-sensitive match that preserves store order
- Unit tests check the exact IDs and order for a known subject, that `math` returns nothing, and that an unknown subject returns an empty array
- A UI test taps `subjectButton.<subject>` on a detail screen and checks the pushed list's title and its cells

**UI and accessibility decisions**

- Dynamic Type: every label uses `UIFont.preferredFont(forTextStyle:)` with `adjustsFontForContentSizeCategory = true` and `numberOfLines = 0`. Table rows use `UITableView.automaticDimension`. The detail screen is a `UIScrollView`, so large text sizes stay reachable, and subject buttons use `UIButton.Configuration` so their titles scale and wrap.
- Required identifiers: `studentList` (table view), `studentCell.<student-id>` (set in `configure(with:)` because cells are reused), `studentDetails` (detail root view), `subjectButton.<subject>`.
- VoiceOver: each cell has one combined `accessibilityLabel` (name, age, grade, scholarship). Scholarship status is shown as text, not only as a colour. Subject buttons have an `accessibilityHint`.
- Safety: no force unwraps on data. Avatars fall back with `??` to a system image, and the detail screen uses `guard let` when the student is missing.
- Layout uses SnapKit only, with system colours (`.label`, `.secondaryLabel`, `.systemBackground`) for light and dark mode.

## Milestones

- [x] Student list and reusable cell
- [x] Detail screen and navigation
- [x] Subject-filtered list
- [x] Unit and UI tests
- [ ] Optional add/edit/delete bonus, if attempted: not attempted
- [ ] Local verification and CI review
- [ ] Final diff and evidence review

## Verification plan

Focused runs while developing:

```bash
# unit tests only
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test -only-testing:StudentDirectoryTests
# UI tests only
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test -only-testing:StudentDirectoryUITests
```

Planned student-authored tests (at least six):

1. Unit: the store's filter returns the exact students and order for `Math`.
2. Unit: the filter is case-sensitive (`math` returns an empty array).
3. Unit: an unknown subject returns an empty array and the store is unchanged.
4. UI: the app launches to `studentList` with the title `Students` and ten
   cells.
5. UI: tapping `studentCell.<id>` opens `studentDetails` with that student's
   name.
6. UI: tapping `subjectButton.Physics` pushes a list titled `Physics` that
   contains only the matching students.
7. UI: the back button returns from detail to the list.

Implemented tests (8; changed during implementation):

- `StudentStoreTests` (unit):
  1. `testFilterBySubjectReturnsOnlyMatchingStudentsInStoreOrder`: `Math` → Ada Lovelace, Katherine Johnson, Donald Knuth, in store order (compared by name).
  2. `testFilterIsCaseSensitive`: `Math` is non-empty, while `math` and `MATH` are empty.
  3. `testFilterWithUnknownSubjectReturnsEmptyAndDoesNotChangeStore`.
  4. `testFilterWorksWithInjectedStudents` (**added**): uses custom students via `StudentStore(students:)`, so the filter is not only checked against seed data.
- `StudentDirectoryFlowUITests` (UI):
  5. `testLaunchShowsStudentListTitledStudents`: checks the title, `studentList` and Ada's cell. **Changed:** it does not assert ten cells, because the table only creates cells for visible rows.
  6. `testTappingStudentOpensDetailsWithSubjectButtons`: checks `studentDetails`, the `Ada Lovelace` title, and all three `subjectButton.<subject>` buttons.
  7. `testTappingSubjectShowsOnlyMatchingStudents`: **changed** to `Math` (reachable from the first row). It checks the `Math` title, exactly 3 cells, and IDs 01, 04, 07.
  8. `testBackButtonReturnsFromDetailsToList`.

The tests use no network access, current time, random values or sleeps.

Final command (exactly as in the README), with the result recorded in
`AGENT_WORKLOG.md` together with the GitHub Actions run URL:

```bash
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test
```

CI note (changed during implementation): the GitHub `macos-15` runner image
updated on 2026-11-04, and its default Xcode 16.4 no longer finds an
`iPhone 17` simulator. The workflow now selects Xcode 26.2 before running the
same README command; the test command itself is unchanged.
