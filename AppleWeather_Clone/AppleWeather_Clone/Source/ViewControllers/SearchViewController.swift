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
    var countryList: [String] = ["ㅇ", "한국", "서울"]
    let searchController = UISearchController(searchResultsController: nil)

    let topView = UIView().then {
        $0.backgroundColor = UIColor.black
        $0.alpha = 0.7
    }
    
    let titleLabel = UILabel().then {
        $0.text = "도시, 우편번호 또는 공항 위치 입력"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    let searchBar = UISearchBar().then {
        $0.showsCancelButton = false
        $0.searchBarStyle = .minimal
        $0.searchTextField.backgroundColor = .lightGray
        $0.searchTextField.textColor = .white
        $0.searchTextField.tintColor = .white
        $0.searchTextField.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.6)])
    }
    
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
    }
    
    let searchTV = UITableView()
            
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupAutoLayout()
        setupTableView()
    }
    
    // MARK: - Custom Method
    func configUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        searchTV.backgroundColor = .clear
    }
    
    func setupAutoLayout() {
        view.addSubviews([topView, searchTV])
        topView.addSubviews([titleLabel, searchBar, cancelButton])
        
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
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        cell.selectionStyle = .gray
        return cell
    }
}
