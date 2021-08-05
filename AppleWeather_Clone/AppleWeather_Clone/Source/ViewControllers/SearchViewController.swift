//
//  SearchViewController.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/02.
//

import UIKit

import Then
import SnapKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    var countryList: [String] = ["Blur Effect 주기", "김연경 사랑해", "네카라쿠배 가자들!"]

    let topView = UIView().then {
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
    }
        
    let titleLabel = UILabel().then {
        $0.text = "도시, 우편번호 또는 공항 위치 입력"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    let searchBar = UISearchBar().then {
        $0.becomeFirstResponder()
        $0.keyboardAppearance = .dark
        $0.showsCancelButton = false
        $0.searchBarStyle = .minimal
        $0.searchTextField.leftView?.tintColor = UIColor.white.withAlphaComponent(0.5)
        $0.searchTextField.backgroundColor = .lightGray
        $0.searchTextField.textColor = .white
        $0.searchTextField.tintColor = .white
        $0.searchTextField.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색",
                                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
    }
    
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.addTarget(self, action: #selector(touchupCancelButton(_:)), for: .touchUpInside)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let searchTV = UITableView().then {
        $0.backgroundColor = .clear
    }
            
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupBlurEffect()
        setupAutoLayout()
        setupTableView()
    }
    
    // MARK: - Custom Method
    func configUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        topView.addSubview(visualEffectView)
    }
    
    func setupAutoLayout() {
        view.addSubviews([topView, searchTV])
        topView.addSubviews([titleLabel, searchBar, cancelButton, lineView])
        
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(6)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-2)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar.snp.centerY)
            make.trailing.equalToSuperview().inset(10)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        searchTV.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func setupTableView() {
        searchTV.delegate = self
        searchTV.dataSource = self
        searchTV.register(SearchTVC.self, forCellReuseIdentifier: "SearchTVC")
        
        searchTV.separatorStyle = .none
    }
    
    // MARK: - @objc
    @objc func touchupCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVC", for: indexPath) as? SearchTVC
        else { return UITableViewCell() }
        cell.countryLabel.text = self.countryList[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}
