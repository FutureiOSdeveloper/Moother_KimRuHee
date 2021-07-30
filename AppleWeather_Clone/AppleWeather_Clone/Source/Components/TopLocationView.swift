//
//  FirstHeaderView.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import Then
import SnapKit

class TopLocationView: UIView {
    static let identifier = "FirstHeaderView"
    
    // MARK: - Properties
    let highTemp: String = ""
    let lowTemp: String = ""
    
    let locationLabel = UILabel().then {
        $0.text = "마포구"
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
        $0.textColor = .white
    }
    
    let conditionLabel = UILabel().then {
        $0.text = "맑음"
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .white
    }
    
    let tempLabel = UILabel().then {
        $0.text = "36"
        $0.font = .systemFont(ofSize: 100, weight: .light)
        $0.textColor = .white
    }
    
    let highLowStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }
    
    let highLabel = UILabel().then {
        $0.text = "최고:37"
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .white
    }
    
    let lowLabel = UILabel().then {
        $0.text = "최저:25"
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .white
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let backView = UIView().then {
        $0.backgroundColor = .brown
        $0.alpha = 0.5
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    func configUI() {
        backgroundColor = .clear
    }
    
    func setupAutoLayout() {
        addSubview(backView)
        addSubviews([locationLabel, conditionLabel, tempLabel,
                     highLowStackView, lineView])
        highLowStackView.addArrangedSubview(highLabel)
        highLowStackView.addArrangedSubview(lowLabel)
        
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(80)
            make.centerX.equalToSuperview()
        }
        
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(conditionLabel.snp.bottom).offset(-7)
            make.centerX.equalToSuperview()
        }
        
        highLowStackView.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(-7)
            make.bottom.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
