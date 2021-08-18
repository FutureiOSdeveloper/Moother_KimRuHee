//
//  SearchTVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/04.
//

import UIKit

import SnapKit
import Then

class SearchTVC: UITableViewCell {
    static let identifier = "SearchTVC"
    // MARK: - Properties
    let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .lightGray
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
        setupAutoLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .init(white: 1.0, alpha: 0.1)
        } else {
            self.backgroundColor = .none
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    func configUI() {
    }
    
    func setupAutoLayout() {
        addSubview(countryLabel)
        
        countryLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(45)
        }
    }
}
