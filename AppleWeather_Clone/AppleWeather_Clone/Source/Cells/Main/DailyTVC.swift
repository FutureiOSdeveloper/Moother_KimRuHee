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
    let weekLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .white
    }
    
    let weatherImageView = UIImageView().then {
        $0.tintColor = .white
    }
    
    let rainPercentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = UIColor.init(red: 255/255, green: 255/255, blue: 102/255, alpha: 1.0)
    }
    
    let highTempLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .white
    }
    
    let lowTempLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor.init(white: 1.0, alpha: 0.8)
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
            make.leading.equalTo(weatherImageView.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
        
        highTempLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.equalTo(weatherImageView.snp.trailing).offset(100)
        }
        
        lowTempLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.equalTo(weatherImageView.snp.trailing).offset(140)
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
    
    // MARK: - setData
    func setData(week: String?, image: String?, rain: Double?, high: Double?, low: Double?) {
        weekLabel.text = week ?? ""
        if Int(rain!) == 0 {
            rainPercentLabel.alpha = 0
        } else {
            rainPercentLabel.alpha = 1
            rainPercentLabel.text = String(Int(rain ?? 0)) + "%"
        }
        highTempLabel.text = String(Int(high ?? 0))
        lowTempLabel.text = String(Int(low ?? 0))
        weatherImageView.image = UIImage(systemName: image ?? "")
    }
}
