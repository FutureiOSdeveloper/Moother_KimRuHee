//
//  SecondHeaderView.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/26.
//

import UIKit

import Moya
import Then
import SnapKit

class TimeTempHeaderView: UIView {
    // MARK: - Network
    private let weatherProvider = MoyaProvider<WeatherService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    var weatherModel: WeatherModel?
    
    // MARK: - Properties
    var timeList: [HourlyWeather]?
    var exclude: String = "hourly"
    
    var time: Int = 0
    var rain: Double = 0
    var image: String = ""
    var temp: Double = 0
    
    var vc = ViewController()
    var latitude: Double?
    var longtitude: Double?
    
    let topLineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let timeTempCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let bottomLineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        setupAutoLayout()
        setupCollectionView()
        timeTempCV.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    func configUI() {
        
    }
    
    func setupAutoLayout() {
        addSubviews([timeTempCV, topLineView, bottomLineView])
        
        topLineView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        timeTempCV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(117)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func setupCollectionView() {
        timeTempCV.delegate = self
        timeTempCV.dataSource = self
        timeTempCV.register(TimeTempCVC.self, forCellWithReuseIdentifier: "TimeTempCVC")
    }
    
    func setData(weather: [HourlyWeather]) {
        self.timeList = weather
    }
}

// MARK: - UICollectionViewDelegate
extension TimeTempHeaderView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension TimeTempHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeList?.count ?? 27
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeTempCVC.identifier, for: indexPath) as? TimeTempCVC
        else { return UICollectionViewCell() }

        if let weather = timeList {
            cell.generateCell(weather: weather[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TimeTempHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}

//// MARK: - Network : fetchWeather
//extension TimeTempHeaderView {
//    func fetchWeather(lat: Double, lon: Double, exclude: String) {
//        let param = WeatherRequest.init(lat, lon, exclude)
//
//        weatherProvider.request(.weather(param: param)) { response in
//            switch response {
//            case .success(let result):
//                do {
//                    self.weatherModel = try result.map(WeatherModel.self)
//
//                    if let time = self.weatherModel?.hourly,
//                       let rain = self.weatherModel?.daily[0].rain,
//                       let icon = self.weatherModel?.hourly[0].weather[0].icon,
//                       let temp = self.weatherModel?.hourly[0].temp {
//                        self.time = time
//                        self.rain = rain
//                        self.image = icon
//                        self.temp = temp
//                    }
//                    self.timeList = [HourlyWeather(time: self.time, rain: self.rain, image: self.image, temp: self.temp)]
//                    self.timeList
//                    self.timeTempCV.reloadData()
//
//                } catch(let err) {
//                    print(err.localizedDescription)
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
//}
