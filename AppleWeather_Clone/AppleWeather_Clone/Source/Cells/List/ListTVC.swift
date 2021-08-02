//
//  ListTVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/28.
//

import UIKit

import Then
import SnapKit

class ListTVC: UITableViewCell {
    static let identifier = "ListTVC"
    // MARK: - Properties
    let localLabel = UILabel().then { ///  나의 위치 첫 번째 cell
        $0.text = "마포구"
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    let myLocalLabel = UILabel().then { ///  나의 위치 첫 번째 cell
        $0.text = "나의 위치"
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    let tempLabel = UILabel().then {
        $0.text = "29"
        $0.font = .systemFont(ofSize: 60, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    let timeLabel = UILabel().then {
        $0.text = "오전 4:29"
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    let countryLabel = UILabel().then {
        $0.text = "로스엔젤레스"
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
        
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Custom Method
    func configUI() {
        localLabel.getShadow()
        myLocalLabel.getShadow()
        tempLabel.getShadow()
        timeLabel.getShadow()
        countryLabel.getShadow()
    }
    
    func setupFirstCellAutoLayout() { /// first cell
        addSubviews([localLabel, myLocalLabel, tempLabel])
        
        localLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.bottom.equalTo(myLocalLabel.snp.top).offset(-1)
        }
        
        myLocalLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalTo(tempLabel.snp.centerY)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    func setupRemainCellAutoLayout() { /// 남은 cell들
        addSubviews([timeLabel, countryLabel, tempLabel])
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(20)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalTo(tempLabel.snp.centerY)

        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}
