import UIKit
import SnapKit

final class StudentListViewController: UIViewController {
    private let store: StudentStore
    private let subject: String?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.accessibilityIdentifier = "studentList"
        return tableView
    }()
    
    private var students: [Student] {
        if let subject {
            return store.students(matchingSubject: subject)
        }
        return store.students
    }
    
    init(store: StudentStore, subject: String? = nil) {
        self.store = store
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = subject ?? "Students"
        view.backgroundColor = .systemBackground
        
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension StudentListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.reuseId, for: indexPath) as? StudentCell else {
            return UITableViewCell()
        }
        cell.configure(with: students[indexPath.row])
        return cell
    }
    
}

extension StudentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = students[indexPath.row]
        let detailController = StudentDetailViewController(store: store, studentID: student.id)
        navigationController?.pushViewController(detailController, animated: true)
    }
}
