import UIKit
import SnapKit

final class StudentDetailViewController: UIViewController {
    private let store: StudentStore
    private let studentID: UUID
    
    private var student: Student? {
        store.students.first { $0.id == studentID }
    }
    
    private let scrollView = UIScrollView()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        return imageView
    }()
    
    private func makeLabel(_ text: String, style: UIFont.TextStyle, color: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = color
        label.numberOfLines = 0
        return label
    }
    
    init(store: StudentStore, studentID: UUID) {
        self.store = store
        self.studentID = studentID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "studentDetails"
        navigationItem.largeTitleDisplayMode = .never
        
        setupLayout()
        
        guard let student else {
            title = "Student not found"
            contentStackView.addArrangedSubview(makeLabel("This student no longer exists.", style: .body, color: .secondaryLabel))
            return
        }
        
        title = student.name
        render(student)
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(20)
            make.width.equalTo(scrollView.frameLayoutGuide).offset(-40)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(120)
        }
    }
    
    private func render(_ student: Student) {
        avatarImageView.image = UIImage(named: student.avatarName) ?? UIImage(systemName: "person.crop.circle")
        
        let avatarContainer = UIView()
        avatarContainer.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
        }
        contentStackView.addArrangedSubview(avatarContainer)
        
        let grade = student.averageGrade.formatted(.number.precision(.fractionLength(1)))
        contentStackView.addArrangedSubview(makeLabel(student.name, style: .title1))
        contentStackView.addArrangedSubview(makeLabel("Age: \(student.age)", style: .body))
        contentStackView.addArrangedSubview(makeLabel("Average grade: \(grade)", style: .body))
        contentStackView.addArrangedSubview(
            makeLabel("Scholarship: \(student.isScholarshipHolder ? "Yes" : "No")", style: .body)
        )
        contentStackView.addArrangedSubview(
            makeLabel("ID: \(student.id.uuidString)", style: .footnote, color: .secondaryLabel)
        )
        
        contentStackView.setCustomSpacing(24, after: contentStackView.arrangedSubviews.last ?? avatarContainer)
        contentStackView.addArrangedSubview(makeLabel("Subjects", style: .title3))
        
        for subject in student.subjects {
            contentStackView.addArrangedSubview(makeSubjectButton(subject))
        }
    }
    
    private func makeSubjectButton(_ subject: String) -> UIButton {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = subject
        configuration.titleLineBreakMode = .byWordWrapping
        
        let button = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            self?.showStudents(for: subject)
        })
        
        button.contentHorizontalAlignment = .leading
        button.accessibilityIdentifier = "subjectButton.\(subject)"
        button.accessibilityHint = "Shows students who take \(subject)"
        return button
    }
    
    private func showStudents(for subject: String) {
        let listController = StudentListViewController(store: store, subject: subject)
        navigationController?.pushViewController(listController, animated: true)
    }
}
