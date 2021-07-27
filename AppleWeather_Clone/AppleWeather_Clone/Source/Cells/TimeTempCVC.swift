//
//  TimeTempCVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import Then
import SnapKit

class TimeTempCVC: UICollectionViewCell {
    static let identifier = "TimeTempCVC"
    
    // MARK: - Properties
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    
    let timeLabel = UILabel().then {
        $0.text = "지금"
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .white
    }
    
    let weatherImageView = UIImageView().then {
        $0.backgroundColor = .white
//        $0.image = UIImage(named: <#T##String#>)
    }
    
    let tempLabel = UILabel().then {
        $0.text = "일몰"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .white
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

    }
    
    func setupAutoLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(weatherImageView)
        stackView.addArrangedSubview(tempLabel)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.width.height.equalTo(33)
        }        
    }
    
    func setData(time: String, image: String, temp: String) {
        timeLabel.text = time
        tempLabel.text = temp
        
        if let image = UIImage(named: image) {
            weatherImageView.image = image
        }
    }
}
