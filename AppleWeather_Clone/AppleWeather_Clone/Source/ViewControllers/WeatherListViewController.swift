//
//  WeatherListViewController.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import Then
import SnapKit

class WeatherListViewController: UIViewController {
    // MARK: - Properties
    var weatherList: [String] = ["0", "1", "2", "3", "4"]
    
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
        mainTV.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - @objc
    @objc func touchupWebButton(_ sender: UIButton) {
        print("web버튼 누름")
        let application = UIApplication.shared
        let weatherURL = URL(string: "https://weather.com/ko-KR/weather/today/")!
        
        if application.canOpenURL(weatherURL) {
            application.open(weatherURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func touchupSearchButton(_ sender: UIButton) {
        print("검색버튼 누름")
        let nextVC = SearchViewController()
        self.present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension WeatherListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDataSource
extension WeatherListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = ListFooterView()
        footerView.webButton.addTarget(self, action: #selector(touchupWebButton(_:)), for: .touchUpInside)
        footerView.searchButton.addTarget(self, action: #selector(touchupSearchButton(_:)), for: .touchUpInside)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        } else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let listCell = tableView.dequeueReusableCell(withIdentifier: ListTVC.identifier, for: indexPath) as? ListTVC
            else { return UITableViewCell() }
            listCell.setupFirstCellAutoLayout()
            listCell.selectionStyle = .none
            listCell.backgroundColor = .brown
//            listCell.isUserInteractionEnabled = false
//            listCell.userInteractionEnabledWhileDragging = false
            return listCell
        } else {
            guard let listCell = tableView.dequeueReusableCell(withIdentifier: ListTVC.identifier, for: indexPath) as? ListTVC
            else { return UITableViewCell() }
            listCell.setupRemainCellAutoLayout()
            listCell.selectionStyle = .none
            listCell.backgroundColor = .blue
            return listCell
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = weatherList[sourceIndexPath.row]
        weatherList.remove(at: sourceIndexPath.row)
        weatherList.insert(moveCell, at: destinationIndexPath.row)
    }
}
