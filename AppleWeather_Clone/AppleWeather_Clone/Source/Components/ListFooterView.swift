//
//  ListFooterView.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/02.
//

import UIKit

class ListFooterView: UIView {
    // MARK: - Properties
    let switchButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.addTarget(self, action: #selector(touchupSwitchButton(_:)), for: .touchUpInside)
        
        let buttonText = "℃ / ℉"
        let normalButtonText = NSMutableAttributedString(string: buttonText)
        normalButtonText.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 2, length: 3))
        let selectedButtonText = NSMutableAttributedString(string: buttonText)
        selectedButtonText.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: 3))
        
        $0.setAttributedTitle(normalButtonText, for: .normal)
        $0.setAttributedTitle(selectedButtonText, for: .selected)
    }
    
    let webButton = UIButton().then {
        $0.setImage(UIImage(named: "img_weather"), for: .normal)
        $0.tintColor = .white
    }
        
    let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .white
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
        addSubviews([switchButton, webButton, searchButton])
        
        switchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        webButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }

        searchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - @objc
    @objc func touchupSwitchButton(_ sender: UIButton) {
        if switchButton.isSelected {
            switchButton.isSelected = false
            print("섭씨 C")
            NotificationCenter.default.post(name: NSNotification.Name("changeUnitToC"), object: nil)
        } else {
            switchButton.isSelected = true
            print("화씨 F")
            NotificationCenter.default.post(name: NSNotification.Name("changeUnitToF"), object: nil)
        }
    }
}
