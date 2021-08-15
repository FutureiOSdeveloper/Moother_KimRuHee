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
    let timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    let rainPercentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11, weight: .regular)
        $0.textColor = .cyan
    }
    
    let weatherImageView = UIImageView().then {
        $0.image = UIImage(named: "img_example")
    }
    
    let tempLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
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
        backgroundColor = .clear
    }
    
    func setupAutoLayout() {
        addSubviews([timeLabel, rainPercentLabel, weatherImageView, tempLabel])
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        rainPercentLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(rainPercentLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - setData
    func setData(time: Int?, image: String?, temp: Double?) {
        timeLabel.text = String(time ?? 0).stringToTime(formatter: "a hh:mm")
        tempLabel.text = String(Int(temp ?? 0)) + "º"
        if let image = UIImage(named: image ?? "") {
            weatherImageView.image = image
        }
    }
}
