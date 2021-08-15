//
//  DailyTVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import Then
import SnapKit

class DailyTVC: UITableViewCell {
    // 화~요일별 날씨 테이블 셀 총 10개를 반복하면 됨
    static let identifier = "DailyTVC"
    
    // MARK: - Properties
    var weatherModel: WeatherModel?
    
    let weekLabel = UILabel().then {
        $0.text = "화요일"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .white
    }
    
    let weatherImageView = UIImageView()
    
    let rainPercentLabel = UILabel().then {
        $0.text = "40%"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .cyan
    }
    
    let highTempLabel = UILabel().then {
        $0.text = "37"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .white
    }
    
    let lowTempLabel = UILabel().then {
        $0.text = "26"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .lightGray
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
        addSubviews([weekLabel, weatherImageView, rainPercentLabel,
                     highTempLabel, lowTempLabel])
        
        weekLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(20)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        rainPercentLabel.snp.makeConstraints { make in
            make.leading.equalTo(weatherImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        lowTempLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(20)
        }
        
        highTempLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.trailing.equalTo(lowTempLabel.snp.leading).offset(-20)
        }
    }
    
    public func maskCell(fromTop margin: CGFloat) {
        layer.mask = visibilityMask(withLocation: margin / frame.size.height)
        layer.masksToBounds = true
    }
    
    private func visibilityMask(withLocation location: CGFloat) -> CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = bounds
        mask.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        let num = location as NSNumber
        mask.locations = [num, num]
        return mask
    }
    
    func generateCell(weather: DailyWeatherModel) {
        weekLabel.text = weather.week
        rainPercentLabel.text = weather.rain
        highTempLabel.text = weather.high
        lowTempLabel.text = weather.low
        weatherImageView.image = UIImage(contentsOfFile: weather.image)
    }
    
    // MARK: - setData
    func setData(week: String?, image: String?, rain: Int?, high: Int?, low: Int?) {
        weekLabel.text = week
        rainPercentLabel.text = String(rain ?? 0) + "%"
        highTempLabel.text = String(high ?? 0)
        lowTempLabel.text = String(low ?? 0)
        
        if let image = UIImage(named: image ?? "") {
            weatherImageView.image = image
        }
    }
}
