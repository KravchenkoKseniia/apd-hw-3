import UIKit
import SnapKit

final class StudentCell: UITableViewCell {
    static let reuseId = "StudentCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 28
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let scholarshipLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with student: Student) {
        avatarImageView.image = UIImage(named: student.avatarName) ?? UIImage(systemName: "person.crop.circle")
        nameLabel.text = student.name
        
        let grade = student.averageGrade.formatted(.number.precision(.fractionLength(1)))
        detailsLabel.text = "Age \(student.age) · Grade \(grade)"
        
        if student.isScholarshipHolder {
            scholarshipLabel.text = "Scholarship"
            scholarshipLabel.textColor = .systemBlue
        } else {
            scholarshipLabel.text = "No Scholarship"
            scholarshipLabel.textColor = .secondaryLabel
        }
        
        accessibilityIdentifier = "studentCell.\(student.id.uuidString)"
        accessibilityLabel = "\(student.name), age \(student.age), grade \(grade), " + (student.isScholarshipHolder ? "scholarship holder" : "no scholarship")
    }
    
    private func setupLayout() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(textStackView)
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(detailsLabel)
        textStackView.addArrangedSubview(scholarshipLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.layoutMarginsGuide)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
            make.top.greaterThanOrEqualTo(contentView.layoutMarginsGuide)
            make.bottom.lessThanOrEqualTo(contentView.layoutMarginsGuide)
        }
        
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.top.bottom.trailing.equalTo(contentView.layoutMarginsGuide)
        }
    }
}


#if DEBUG
import SwiftUI

#Preview(traits: .sizeThatFitsLayout) {
    let cell = StudentCell(style: .default, reuseIdentifier: StudentCell.reuseId)
    if let student = StudentSeedData.students.first {
        cell.configure(with: student)
    }
    return cell
}
#endif
