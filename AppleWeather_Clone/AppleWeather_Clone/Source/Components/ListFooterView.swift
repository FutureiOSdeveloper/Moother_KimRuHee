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
        $0.titleLabel?.text = "℃/℉"
        $0.setTitle("℃/℉", for: .normal)
//        $0.setAttributedTitle(<#T##title: NSAttributedString?##NSAttributedString?#>, for: <#T##UIControl.State#>)
        $0.addTarget(self, action: #selector(touchupSwitchButton(_:)), for: .touchUpInside)
        $0.alpha = 0.5
    }
    
    let webButton = UIButton().then {
        $0.setImage(UIImage(systemName: "die.face.4.fill"), for: .normal)
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
        switchButton.isSelected = true
    }
    
    func setupAutoLayout() {
        addSubviews([switchButton, webButton, searchButton])
        
        switchButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        webButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        searchButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - @objc
    @objc func touchupSwitchButton(_ sender: UIButton) {
        switchButton.setTitle("dhkd", for: .selected)
    }
}
