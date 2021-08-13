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
    var weatherModel: WeatherModel!
    var hourlyModel: [HourlyWeather] = []
    
    let timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .white
    }
    
    let rainPercentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11, weight: .black)
        $0.textColor = .cyan
    }
    
    let weatherImageView = UIImageView().then {
        $0.image = UIImage(named: "img_example")
    }
    
    let tempLabel = UILabel().then {
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
    
    func generateCell(weather: HourlyWeather) {
        timeLabel.text = String(weather.time) + "시"
        rainPercentLabel.text = String(weather.rain) + "%"
        weatherImageView.image = UIImage(contentsOfFile: weather.image)
        tempLabel.text = String(weather.temp)
    }
    
    func setData(time: Int?, rain: Double?, image: String?, temp: Double?) {
        timeLabel.text = String(time ?? 0)
        
        if rain == 0 {
            rainPercentLabel.alpha = 0
        } else {
            rainPercentLabel.text = String(rain ?? 0) + "%"
        }
        
        if let image = UIImage(named: image ?? "") {
            weatherImageView.image = image
        }
        
        tempLabel.text = String(temp ?? 0)
    }
}
