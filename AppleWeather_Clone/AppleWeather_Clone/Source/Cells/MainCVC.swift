//
//  MainCVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

class MainCVC: UICollectionViewCell {
    static let identifier = "MainCVC"
    
    // MARK: - Dummy Data
    var dailyList: [DailyWeatherModel] = [DailyWeatherModel(week: "화요일", image: "img_example", rain: "40%", high: "36", low: "28"),
                                          DailyWeatherModel(week: "수요일", image: "img_example", rain: "40%", high: "36", low: "28"),
                                          DailyWeatherModel(week: "목요일", image: "img_example", rain: "40%", high: "36", low: "28"),
                                          DailyWeatherModel(week: "금요일", image: "img_example", rain: "40%", high: "36", low: "28"),
                                          DailyWeatherModel(week: "토요일", image: "img_example", rain: "40%", high: "36", low: "28"),
                                          DailyWeatherModel(week: "일요일", image: "img_example", rain: "40%", high: "36", low: "28"),
                                          DailyWeatherModel(week: "월요일", image: "img_example", rain: "40%", high: "36", low: "28"),
                                          DailyWeatherModel(week: "화요일", image: "img_example", rain: "40%", high: "36", low: "28"),
                                          DailyWeatherModel(week: "수요일", image: "img_example", rain: "40%", high: "36", low: "28"),
                                          DailyWeatherModel(week: "목요일", image: "img_example", rain: "40%", high: "36", low: "28")]
    
    var detailList: [DetailModel] = [DetailModel(leftTitle: "일출", leftDetail: "오전 5:18", rightTitle: "일몰", rightDetail: "오후8:55"),
                                     DetailModel(leftTitle: "비 올 확률", leftDetail: "30%", rightTitle: "습도", rightDetail: "82%"),
                                     DetailModel(leftTitle: "바람", leftDetail: "남 3m/s", rightTitle: "체감", rightDetail: "18"),
                                     DetailModel(leftTitle: "강수량", leftDetail: "0.2cm", rightTitle: "기압", rightDetail: "1008hPa"),
                                     DetailModel(leftTitle: "가시거리", leftDetail: "11.3km", rightTitle: "자외선 지수", rightDetail: "5")]
    
    // MARK: - Properties
    var tableViewTopConstraint: NSLayoutConstraint!
    var tableViewTopLength: CGFloat = 0
    var tableViewTopInset: CGFloat = 300
    
    let localView = UIView()
    
    let locationLabel = UILabel().then {
        $0.text = "마포구"
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
        $0.textColor = .white
    }
    
    let conditionLabel = UILabel().then {
        $0.text = "맑음"
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .white
    }
    
    let tempLabel = UILabel().then {
        $0.text = "36"
        $0.font = .systemFont(ofSize: 100, weight: .light)
        $0.textColor = .white
    }
    
    let highLowStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.backgroundColor = .clear
    }
    
    let highLabel = UILabel().then {
        $0.text = "최고:37"
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .white
    }
    
    let lowLabel = UILabel().then {
        $0.text = "최저:25"
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.textColor = .white
    }
    
    let mainTV = UITableView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupAutoLayout()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    func configUI() {
        mainTV.backgroundColor = .clear
        
        mainTV.separatorStyle = .none
        mainTV.showsVerticalScrollIndicator = false
    }
    
    func setupAutoLayout() {
        addSubviews([locationLabel, conditionLabel, tempLabel,
                     highLowStackView, localView, mainTV])
        highLowStackView.addArrangedSubview(highLabel)
        highLowStackView.addArrangedSubview(lowLabel)
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(110)
            make.centerX.equalToSuperview()
        }
        
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(conditionLabel.snp.bottom).offset(-7)
            make.centerX.equalToSuperview()
        }
        
        highLowStackView.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(-7)
            //            make.bottom.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
        }
        
        //        localView.snp.makeConstraints { make in
        //            make.top.leading.trailing.equalToSuperview()
        //            make.height.equalTo(320)
        //        }
        
        mainTV.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        mainTV.contentInset = UIEdgeInsets(top: tableViewTopInset, left: 0, bottom: 0, right: 0)
        mainTV.contentOffset.y = -300
    }
    
    func setupTableView() {
        mainTV.delegate = self
        mainTV.dataSource = self
        
        mainTV.register(DailyTVC.self, forCellReuseIdentifier: "DailyTVC")
        mainTV.register(TodayTVC.self, forCellReuseIdentifier: "TodayTVC")
        mainTV.register(DetailTVC.self, forCellReuseIdentifier: "DetailTVC")
        mainTV.register(MapTVC.self, forCellReuseIdentifier: "MapTVC")
    }
}

// MARK: - UITableViewDelegate
extension MainCVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("yOffset",round(mainTV.contentOffset.y+47))
        print("topConstraint",tableViewTopLength)
        print("tableViewTopInset", tableViewTopInset)
        //        print("inset",tableViewTopInset)
        let yOffset = (mainTV.contentOffset.y+47)
        //        print("알파", self.highLowStackView.alpha)
        let yPlusOffset = yOffset+300
        
        if yOffset > -300 && yOffset < -75 {
            mainTV.contentInset = UIEdgeInsets(top: -yOffset, left: 0, bottom: 0, right: 0)
            if yPlusOffset > 0 && yPlusOffset <= 60 {
                locationLabel.snp.updateConstraints { make in
                    make.top.equalTo(110-yPlusOffset)
                }

            } else {
                locationLabel.snp.updateConstraints { make in
                    make.top.equalTo(50)
                }
            
            }
            
            //            mainTV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if yOffset > -75 {
            mainTV.contentInset = UIEdgeInsets(top: 75, left: 0, bottom: 0, right: 0)
//            locationLabel.snp.updateConstraints { make in
//                make.top.equalTo(50)
//            }
        }
        
        
        
        
        //        if yOffset > 0 && yOffset < 60 {
        //            locationLabel.snp.updateConstraints { make in
        //                make.top.equalTo(110-yOffset)
        //            }
        //
        //            mainTV.contentInset = UIEdgeInsets(top: tableViewTopInset+yOffset, left: 0, bottom: 0, right: 0)
        //        } else if yOffset > 205 {
        ////            mainTV.snp.updateConstraints { make in
        ////                make.top.equalToSuperview().inset(-220)
        ////            }
        //
        ////            tableViewTopLength = -47
        //        } else {
        //            tableViewTopLength = 0
        //        }
        
        //            if yOffset < 60 {
        ////                mainTV.setContentOffset(CGPoint(x: 0, y: 53), animated: true)
    }
    
    //
    
    //     else {
    //    //            mainTV.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
    //    }
}

// MARK: - UITableViewDelegate
extension MainCVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return mainTV.sectionHeaderHeight
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let firstHeaderView = UIView()
            firstHeaderView.backgroundColor = .brown
            firstHeaderView.alpha = 0.5
            return UIView()
        default:
            let secondHeaderView = TimeTempHeaderView()
            return secondHeaderView
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        default:
            return dailyList.count + 1 + detailList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        } else {
            return tableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // if 문으로 걍 section 1일 때만 주는 것.
        case 0:
            let cell = UITableViewCell()
            cell.backgroundColor = .green
            cell.alpha = 0.5
            return cell
        default:
            if indexPath.row < 10 {
                guard let dailyCell = tableView.dequeueReusableCell(withIdentifier: DailyTVC.identifier, for: indexPath) as? DailyTVC
                else { return UITableViewCell() }
                dailyCell.selectionStyle = .none
                dailyCell.setData(week: dailyList[indexPath.row].week, image: dailyList[indexPath.row].image,
                                  rain: dailyList[indexPath.row].rain, high: dailyList[indexPath.row].high,
                                  low: dailyList[indexPath.row].low)
                return dailyCell
                
            } else if indexPath.row < 11 {
                guard let todayCell = tableView.dequeueReusableCell(withIdentifier: TodayTVC.identifier, for: indexPath) as? TodayTVC
                else { return UITableViewCell() }
                todayCell.selectionStyle = .none
                return todayCell
                
            } else if indexPath.row < 16 {
                guard let detailCell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.identifier, for: indexPath) as? DetailTVC
                else { return UITableViewCell() }
                detailCell.selectionStyle = .none
                detailCell.setData(leftTitle: detailList[indexPath.row - dailyList.count - 1].leftTitle,
                                   leftDetail: detailList[indexPath.row - dailyList.count - 1].leftDetail,
                                   rightTitle: detailList[indexPath.row - dailyList.count - 1].rightTitle,
                                   rightDetail: detailList[indexPath.row - dailyList.count - 1].rightDetail)
                return detailCell
                
            } else {
                guard let mapCell = tableView.dequeueReusableCell(withIdentifier: MapTVC.identifier, for: indexPath) as? MapTVC
                else { return UITableViewCell() }
                mapCell.selectionStyle = .none
                return mapCell
            }
        }
    }
}
