//
//  ListViewController.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import Then
import SnapKit

class ListViewController: UIViewController {
    // MARK: - Properties
    var cityList: [ListModel] = [ListModel(time: "마포구", country: "나의 위치", temp: "33"),
                                    ListModel(time: "오전 4:21", country: "하와이", temp: "33"),
                                    ListModel(time: "오전 6:21", country: "도쿄", temp: "22"),
                                    ListModel(time: "오전 7:21", country: "Chiyoda", temp: "18"),
                                    ListModel(time: "오전 8:21", country: "로스엔젤레스", temp: "33")]
    
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
        if indexPath.row == 0 {
            guard let listCell = tableView.dequeueReusableCell(withIdentifier: ListTVC.identifier, for: indexPath) as? ListTVC
            else { return UITableViewCell() }
            listCell.setupFirstCellAutoLayout()
            listCell.selectionStyle = .none
            listCell.backgroundView = UIImageView.init(image: UIImage(named: "img_rain"))
            listCell.setFirstCellData(local: cityList[indexPath.row].time,
                                      myLocal: cityList[indexPath.row].country,
                                      temp: cityList[indexPath.row].temp)
            return listCell
        } else {
            guard let listCell = tableView.dequeueReusableCell(withIdentifier: ListTVC.identifier, for: indexPath) as? ListTVC
            else { return UITableViewCell() }
            listCell.setupRemainCellAutoLayout()
            listCell.selectionStyle = .none
            listCell.backgroundView = UIImageView.init(image: UIImage(named: "img_sun"))
            listCell.setCellData(time: cityList[indexPath.row].time,
                                 country: cityList[indexPath.row].country,
                                 temp: cityList[indexPath.row].temp)
            return listCell
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveCell = cityList[sourceIndexPath.row]
        cityList.remove(at: sourceIndexPath.row)
        cityList.insert(moveCell, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name("pageControl"), object: indexPath.row)
            if indexPath.row == 0 {
                NotificationCenter.default.post(name: NSNotification.Name("clickFirstCell"),
                                                object: [self.cityList[0].time, self.cityList[0].temp])
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("clickOtherCell"),
                                                object: [self.cityList[indexPath.row].country, self.cityList[indexPath.row].temp])
            }
        }
    }
}
