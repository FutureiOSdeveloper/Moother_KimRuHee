//
//  TodayTVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import SnapKit
import Then

class TodayTVC: UITableViewCell {
    // 1개만 써주면 됨 오늘~ 웅앵부분
    static let identifier = "TodayTVC"
    
    // MARK: - Properties    
    let topLineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let todayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    let bottomLineView = UIView().then {
        $0.backgroundColor = .white
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
        addSubviews([topLineView, todayLabel, bottomLineView])
        
        topLineView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        todayLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(13)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
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
}
