//
//  WeatherListViewController.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

class WeatherListViewController: UIViewController {
    // MARK: - Properties
    let mainTV = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupAutoLayout()
        setupTableView()
    }
    
    // MARK: - Custom Method
    func configUI() {
        view.backgroundColor = .black
    }
    
    func setupAutoLayout() {
        view.addSubviews([mainTV])
        
        mainTV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupTableView() {
        mainTV.delegate = self
        mainTV.dataSource = self
        mainTV.register(ListTVC.self, forCellReuseIdentifier: "ListTVC")
        
        mainTV.separatorStyle = .none
        mainTV.backgroundColor = .clear
    }
    
    // MARK: - @objc
    @objc func touchupSearchButton(_ sender: UIButton) {
        print("누름")
        let nextVC = SearchViewController()
        self.present(nextVC, animated: true, completion: nil)
    }
}
 
// MARK: - UITableViewDelegate
extension WeatherListViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension WeatherListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = ListFooterView()
//        footerView.searchButton.addTarget(self, action: #selector(touchupSearchButton(_:)), for: .touchUpInside)
//        return footerView
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: ListTVC.identifier, for: indexPath) as? ListTVC
        else { return UITableViewCell() }
        listCell.selectionStyle = .none
        listCell.backgroundColor = .yellow
        return listCell
    }
}
