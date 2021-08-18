//
//  ListTVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/28.
//

import UIKit

import SnapKit
import Then

class ListTVC: UITableViewCell {
    static let identifier = "ListTVC"
    
    // MARK: - Properties
    let backImageView = UIImageView().then {
        $0.image = UIImage(named: "backImage")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let subTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    let tempLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 60, weight: .thin)
        $0.textColor = .white
        $0.textAlignment = .left
    }
        
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
        registerNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Custom Method
    func configUI() {
        subTitleLabel.getShadow()
        titleLabel.getShadow()
        tempLabel.getShadow()
        
        addSubviews([backImageView, subTitleLabel, titleLabel, tempLabel])
        backImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupFirstCellAutoLayout() { /// first cell
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalTo(tempLabel.snp.centerY)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    func setupRemainCellAutoLayout() { /// 남은 cell들        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalTo(tempLabel.snp.centerY)

        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeToC),
                                               name: NSNotification.Name("changeUnitToC"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeToF),
                                               name: NSNotification.Name("changeUnitToF"),
                                               object: nil)
    }
    
    // MARK: - @objc
    @objc func changeToC(_ sender: Notification) {
        let temp = Double(tempLabel.text!)!
        tempLabel.text = "\(round((temp - 32)/1.8))"
        print("F -> C", temp)
    }
    
    @objc func changeToF(_ sender: Notification) {
        let temp = Double(tempLabel.text!)!
        tempLabel.text = "\(temp*1.8 + 32)"
        print("C -> F", temp)
    }
    
    // MARK: - setData
    func setData(subtitle: String, title: String, temp: String) {
        subTitleLabel.text = subtitle
        titleLabel.text = title
        tempLabel.text = temp
    }
}
