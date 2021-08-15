//
//  MainCVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import Moya
import Then
import SnapKit

class MainCVC: UICollectionViewCell {
    static let identifier = "MainCVC"
    
    // MARK: - Network
    private let weatherProvider = MoyaProvider<WeatherService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    var weatherModel: WeatherModel?
    
    // MARK: - Properties
    var timeList = [Current]()
    var dailyList = [Daily]()
    var detailList: [DetailModel] = []

    var latitude: Double?
    var longtitude: Double?
    
    var rain: Int = 0
    var max: Int?
    var min: Int?
    var sunrise: Int = 0
    var sunset: Int = 0
    var rainPercent: Int = 0
    var humidity: Int = 0
    var wind: Int = 0
    var feelLike: Int = 0
    var pressure: Int = 0
    var look: Double = 0
    var uvi: Int = 0
    var condition: String = ""
    
    let locationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 30, weight: .regular)
        $0.textColor = .white
    }
    
    let conditionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    let tempLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 100, weight: .thin)
        $0.textColor = .white
    }
    
    let highLowStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.alignment = .center
        $0.backgroundColor = .clear
    }
    
    let highLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    let lowLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .white
    }
    
    let mainTV = UITableView()
            
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupAutoLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(receiveFirstCell(_:)),
                                               name: NSNotification.Name("clickFirstCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveOtherCell(_:)),
                                               name: NSNotification.Name("clickOtherCell"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    func configUI() {
        mainTV.backgroundColor = .clear
        mainTV.separatorStyle = .none
        mainTV.showsVerticalScrollIndicator = false
        
        locationLabel.getShadow()
        conditionLabel.getShadow()
        tempLabel.getShadow()
        highLabel.getShadow()
        lowLabel.getShadow()
    }
    
    func setupAutoLayout() {
        addSubviews([locationLabel, conditionLabel, tempLabel,
                     highLowStackView, mainTV])
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
            make.centerX.equalToSuperview()
        }
        
        mainTV.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        mainTV.contentInset = UIEdgeInsets(top: 320, left: 0, bottom: 0, right: 0)
        mainTV.contentOffset.y = -320
    }
    
    func setupTableView() {
        mainTV.delegate = self
        mainTV.dataSource = self
        
        mainTV.register(DailyTVC.self, forCellReuseIdentifier: "DailyTVC")
        mainTV.register(TodayTVC.self, forCellReuseIdentifier: "TodayTVC")
        mainTV.register(DetailTVC.self, forCellReuseIdentifier: "DetailTVC")
        mainTV.register(MapTVC.self, forCellReuseIdentifier: "MapTVC")
    }

    // MARK: - setData
    func setData(location: String, temp: String, condition: String, max: String, min: String) {
        locationLabel.text = location
        tempLabel.text = temp
        conditionLabel.text = condition
        highLabel.text = max
        lowLabel.text = min
    }
    
    // MARK: - @objc
    @objc func receiveFirstCell(_ notifiction: Notification) {
        if let location = notifiction.object as? [String],
           let temp = notifiction.object as? [String] {
            locationLabel.text = location[0]
            tempLabel.text = temp[1]
        }
    }
    
    @objc func receiveOtherCell(_ notifiction: Notification) {
        if let location = notifiction.object as? [String],
           let temp = notifiction.object as? [String] {
            locationLabel.text = location[0]
            tempLabel.text = temp[1]
        }
    }
}

// MARK: - UITableViewDelegate
extension MainCVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// mainTV.contentOffset.y 이 있는데 굳이 300을 더해서 yPlusOffset을 만들어 준 이유는
        /// mainTV의 contentInset에서 top을 300만큼 내려줬기 때문에 mainTV.contentOffset.y의 default값이 현재 -300이라서
        /// 아래 locationLabel의 top Constraint를 쉽게 계산해주기 위함
        let tvContentOffsetY = (mainTV.contentOffset.y+47)
        let yPlusOffset = tvContentOffsetY+320
        
        if tvContentOffsetY >= -320 && tvContentOffsetY < -75 {
            mainTV.contentInset = UIEdgeInsets(top: -tvContentOffsetY, left: 0, bottom: 0, right: 0)
            if yPlusOffset >= 0 && yPlusOffset <= 60 {
                locationLabel.snp.updateConstraints { make in
                    make.top.equalTo(110-yPlusOffset)
                }
                tempLabel.alpha = (60-yPlusOffset)/60
                highLowStackView.alpha = (60-yPlusOffset)/60
            } else {
                locationLabel.snp.updateConstraints { make in
                    make.top.equalTo(50)
                }
                tempLabel.alpha = 0
                highLowStackView.alpha = 0
            }
            
        } else if tvContentOffsetY >= -75 {
            mainTV.contentInset = UIEdgeInsets(top: 75, left: 0, bottom: 0, right: 0)
            
        } else {
            locationLabel.snp.updateConstraints { make in
                make.top.equalTo(110)
            }
            tempLabel.alpha = 1.0
            highLowStackView.alpha = 1.0
        }
        
        for cell in self.mainTV.visibleCells {
            let paddingToDisappear = CGFloat(75 + 117)
            let hiddenFrameHeight = tvContentOffsetY + paddingToDisappear - cell.frame.origin.y
            if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                if let dailyTVC = cell as? DailyTVC {
                    dailyTVC.maskCell(fromTop: hiddenFrameHeight)
                }
                
                if let todayTVC = cell as? TodayTVC {
                    todayTVC.maskCell(fromTop: hiddenFrameHeight)
                }
                
                if let detailTVC = cell as? DetailTVC {
                    detailTVC.maskCell(fromTop: hiddenFrameHeight)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let tvContentOffsetY = (mainTV.contentOffset.y + 47)
        if tvContentOffsetY > -320 && tvContentOffsetY < 47 {
            UIView.animate(withDuration: 0.5) {
                self.mainTV.contentInset = UIEdgeInsets(top: 47, left: 0, bottom: 0, right: 0)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension MainCVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView()
        default:
            let secondHeaderView = TimeTempHeaderView()
            secondHeaderView.setData(weather: self.timeList)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return UITableViewCell()
        default:
            if indexPath.row < 8 {
                guard let dailyCell = tableView.dequeueReusableCell(withIdentifier: DailyTVC.identifier, for: indexPath) as? DailyTVC
                else { return UITableViewCell() }
                dailyCell.selectionStyle = .none
                dailyCell.setData(week: dailyList[indexPath.row].dt,
                                  image: dailyList[indexPath.row].weather[0].icon,
                                  rain: dailyList[indexPath.row].rain,
                                  high: dailyList[indexPath.row].temp.max,
                                  low: dailyList[indexPath.row].temp.min)
                return dailyCell
                
            } else if indexPath.row < 9 {
                guard let todayCell = tableView.dequeueReusableCell(withIdentifier: TodayTVC.identifier, for: indexPath) as? TodayTVC
                else { return UITableViewCell() }
                todayCell.selectionStyle = .none
                todayCell.todayLabel.text = "오늘: 현재 날씨 \(condition), 최고 기온은 \(max ?? 0)º이며 최저 기온은 \(min ?? 0)º입니다."
                return todayCell
                
            } else if indexPath.row < 14 {
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
                mapCell.localLabel.text = locationLabel.text! + " 날씨."
                return mapCell
            }
        }
    }
}

// MARK: - Network : fetchWeather
extension MainCVC{
    func fetchWeather(lat: Double, lon: Double, exclude: String) {
        let param = WeatherRequest.init(lat, lon, exclude)
        
        weatherProvider.request(.weather(param: param)) { response in
            switch response {
            case .success(let result):
                do {
                    self.weatherModel = try result.map(WeatherModel.self)
                    if let rain = self.weatherModel?.daily[0].rain,
                       let max = self.weatherModel?.daily[0].temp.max,
                       let min = self.weatherModel?.daily[0].temp.min,
                       let sunset = self.weatherModel?.current.sunset,
                       let sunrise = self.weatherModel?.current.sunrise,
                       let humidity = self.weatherModel?.current.humidity,
                       let wind = self.weatherModel?.current.windSpeed,
                       let feelLike = self.weatherModel?.current.feelsLike,
                       let pressure = self.weatherModel?.current.pressure,
                       let look = self.weatherModel?.current.visibility,
                       let uvi = self.weatherModel?.current.uvi,
                       let condition = self.weatherModel?.current.weather[0].weatherDescription {
                        self.rain = Int(rain)
                        self.max = Int(max)
                        self.min = Int(min)
                        self.sunset = sunset
                        self.sunrise = sunrise
                        self.humidity = humidity
                        self.wind = Int(wind)
                        self.feelLike = Int(feelLike)
                        self.pressure = pressure
                        self.look = Double(look)
                        self.uvi = Int(uvi)
                        self.condition = condition
                    }
                    self.timeList = self.weatherModel!.hourly
                    self.dailyList = self.weatherModel!.daily
                    self.detailList = [DetailModel(leftTitle: "일출", leftDetail: "\(self.sunrise)".stringToTime(formatter: "a hh:mm"),
                                                   rightTitle: "일몰", rightDetail: "\(self.sunset)".stringToTime(formatter: "a hh:mm")),
                                       DetailModel(leftTitle: "비 올 확률", leftDetail: "\(self.rain)%",
                                                   rightTitle: "습도", rightDetail: "\(self.humidity)%"),
                                       DetailModel(leftTitle: "바람", leftDetail: "\(self.wind)m/s",
                                                   rightTitle: "체감", rightDetail: "\(self.feelLike)º"),
                                       DetailModel(leftTitle: "강수량", leftDetail: "\(String(self.weatherModel?.current.rain?.the1H ?? 0))cm",
                                                   rightTitle: "기압", rightDetail: "\(self.pressure)hPa"),
                                       DetailModel(leftTitle: "가시거리", leftDetail: "\(self.look)km",
                                                   rightTitle: "자외선 지수", rightDetail: "\(self.uvi)")]
                    self.setupTableView()
                    self.mainTV.reloadData()
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
