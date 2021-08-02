//
//  DetailTVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import Then
import SnapKit

class DetailTVC: UITableViewCell {
    // 일출, 일몰 등등 부분 - 5개 반복
    static let identifier = "DetailTVC"
    
    // MARK: - Properties
    let leftTitleLabel = UILabel().then {
        $0.text = "일출"
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    let leftDetailLabel = UILabel().then {
        $0.text = "오전 5:32"
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    let rightTitleLabel = UILabel().then {
        $0.text = "일몰"
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
        $0.textColor = .lightGray
        $0.textAlignment = .left
    }
    
    let rightDetailLabel = UILabel().then {
        $0.text = "오후 7:44"
        $0.font = .systemFont(ofSize: 20, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Custom Method
    func configUI() {
        backgroundColor = .clear
    }
    
    func setupAutoLayout() {
        addSubviews([leftTitleLabel, leftDetailLabel, rightTitleLabel, rightDetailLabel])
        
        leftTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(20)
        }
        
        leftDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(leftTitleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(5)
        }
        
        rightTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(UIScreen.main.bounds.width / 2)
        }
        
        rightDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(leftTitleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().inset(UIScreen.main.bounds.width / 2)
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    func setData(leftTitle: String, leftDetail: String, rightTitle: String, rightDetail: String) {
        leftTitleLabel.text = leftTitle
        leftDetailLabel.text = leftDetail
        rightTitleLabel.text = rightTitle
        rightDetailLabel.text = rightDetail
    }
}
