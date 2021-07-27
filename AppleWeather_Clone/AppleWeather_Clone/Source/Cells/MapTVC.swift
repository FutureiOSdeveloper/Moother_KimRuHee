//
//  MapTVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/27.
//

import UIKit

class MapTVC: UITableViewCell {
    static let identifier = "MapTVC"
    
    // MARK: - Properties
    let lineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let localLabel = UILabel().then {
        $0.text = "아현동 날씨."
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    let mapButton = UIButton().then {
        $0.titleLabel?.text = "지도에서 열기"
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(touchupMapButton), for: .touchUpInside)
        let attributedString = NSMutableAttributedString(string: ($0.titleLabel?.text)!)
        attributedString.addAttribute(.underlineStyle, value: 1, range: NSMakeRange(0, ($0.titleLabel?.text!.count)!))
        $0.setAttributedTitle(attributedString, for: .normal)
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
        addSubviews([lineView, localLabel, mapButton])
        
        lineView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        localLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        mapButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(7)
            make.leading.equalTo(localLabel.snp.trailing).offset(5)
        }
    }
    
    // MARK: - @objc
    @objc func touchupMapButton(_ sender: UIButton) {
        
    }
}
