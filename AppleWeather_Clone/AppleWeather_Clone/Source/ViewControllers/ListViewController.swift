//
//  ListViewController.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import SnapKit
import Then

class ListViewController: UIViewController {
    // MARK: - Properties
    var cityList: [ListModel] = [ListModel(subTitle: "", title: "나의 위치", temp: "")]
    
    let mainTV = UITableView(frame: .zero, style: .grouped)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupAutoLayout()
        setupTableView()
        registerNotification()
    }
    
    // MARK: - Custom Method
    func configUI() {
        view.backgroundColor = .black
    }
    
    func setupAutoLayout() {
        view.addSubview(mainTV)
        
        mainTV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupTableView() {
        mainTV.delegate = self
        mainTV.dataSource = self
        mainTV.register(ListTVC.self, forCellReuseIdentifier: "ListTVC")
        
        mainTV.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        mainTV.sectionHeaderHeight = 0

        mainTV.separatorStyle = .none
        mainTV.backgroundColor = .clear
        mainTV.contentInsetAdjustmentBehavior = .never
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addCity(_:)),
                                               name: NSNotification.Name("appendCity"),
                                               object: nil)
    }
    
    // MARK: - setData
    func setData(cityList: [ListModel]) {
        self.cityList = cityList
    }
    
    // MARK: - @objc
    @objc func touchupWebButton(_ sender: UIButton) {
        let application = UIApplication.shared
        let weatherURL = URL(string: "https://weather.com/ko-KR/weather/today/")!
        if application.canOpenURL(weatherURL) {
            application.open(weatherURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func touchupSearchButton(_ sender: UIButton) {
        let nextVC = SearchViewController()
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func addCity(_ notification: Notification) {
        print(cityList, "addCity")
        if let list = notification.object as? [ListModel] {
            cityList.append(contentsOf: list)
        }
        mainTV.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 {
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cityList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
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
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: ListTVC.identifier, for: indexPath) as? ListTVC
        else { return UITableViewCell() }
        listCell.selectionStyle = .none
        if indexPath.row == 0 {
            listCell.setupFirstCellAutoLayout()
        } else {
            listCell.setupRemainCellAutoLayout()
            
        }
        listCell.setData(subtitle: cityList[indexPath.row].subTitle,
                         title: cityList[indexPath.row].title,
                         temp: cityList[indexPath.row].temp)
        
        return listCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("pageControl"), object: indexPath.row)
            if indexPath.row == 0 {
                NotificationCenter.default.post(name: NSNotification.Name("clickCell"),
                                                object: [self.cityList[indexPath.row].subTitle,
                                                         self.cityList[indexPath.row].temp])
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("clickCell"),
                                                object: [self.cityList[indexPath.row].title,
                                                         self.cityList[indexPath.row].temp])
            }
        }
    }
}
