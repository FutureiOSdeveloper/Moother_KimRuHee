//
//  ViewController.swift
//  Moother iOS
//
//  Created by Thisisme Hi on 2021/07/24.
//

import UIKit

import CoreLocation
import Lottie
import Moya
import SafariServices
import SnapKit
import Then

class ViewController: UIViewController {
    // MARK: - Network
    private let weatherProvider = MoyaProvider<WeatherService>(plugins: [NetworkLoggerPlugin(verbose: true)])
    var weatherModel: WeatherModel?
    
    // MARK: - Properties
    private var cityList = [ListModel(subTitle: "", title: "나의 위치", temp: "")]
        
    var isAddNewCityView: Bool = false
    var location: String = ""
    var myCurrentLocation: String = ""
    var temperature: Double = 0
    var condition: String = ""
    var max: Double = 0
    var min: Double = 0
    var currentTime: Int = 0
    var timezoneOffset: Int = 0
        
    /// locationManager 인스턴스 생성
    var locationManager: CLLocationManager! = CLLocationManager()
    
    /// 위도 및 경도
    var latitude: Double?
    var longtitude: Double?
    /// 검색 위도 및 경도
    var searchLatitude: Double?
    var searchLongtitude: Double?
    
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.addTarget(self, action: #selector(touchupCancelButton(_:)), for: .touchUpInside)
    }
    
    let addButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.addTarget(self, action: #selector(touchupAddButton(_:)), for: .touchUpInside)
    }
    
    let mainCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    let backgroundView = UIView()
    let animationView = AnimationView()
    
    let lineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let bottomBarView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let leftBarButton = UIButton().then {
        $0.setImage(UIImage(systemName: "die.face.4.fill"), for: .normal)
        $0.tintColor = .white
        $0.alpha = 0.5
        $0.addTarget(self, action: #selector(touchupLeftBarButton(_:)), for: .touchUpInside)
    }
    
    let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .white
        $0.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5)
    }
    
    let rightBarButton = UIButton().then {
        $0.setImage(UIImage(systemName: "list.dash"), for: .normal)
        $0.tintColor = .white
        $0.alpha = 0.5
        $0.addTarget(self, action: #selector(touchupRightBarButton(_:)), for: .touchUpInside)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        configUI()
        setupAutoLayout()
        setupPageControl()
        registerNotification()
    }
    
    // MARK: - Custom Method
    func configUI() {
        view.backgroundColor = .white
        if isAddNewCityView {
            mainCV.isScrollEnabled = false
        }
    }
    
    func setupAutoLayout() {
        view.addSubviews([backgroundView, mainCV, cancelButton,
                          addButton, lineView, bottomBarView])
        backgroundView.addSubview(animationView)
        bottomBarView.addSubviews([leftBarButton, pageControl, rightBarButton])
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
        }
        
        mainCV.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBarView.snp.top)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomBarView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        bottomBarView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        
        leftBarButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        rightBarButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(15)
        }
        
        if isAddNewCityView {
            cancelButton.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
                make.leading.equalToSuperview().inset(20)
            }
            
            addButton.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
                make.trailing.equalToSuperview().inset(20)
            }
            
            mainCV.snp.makeConstraints { make in
                make.top.leading.bottom.trailing.equalToSuperview()
            }
            
            lineView.isHidden = true
        }
    }
    
    func setupCollectionView() {
        mainCV.delegate = self
        mainCV.dataSource = self
        mainCV.register(MainCVC.self, forCellWithReuseIdentifier: "MainCVC")
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = cityList.count
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
    }
    
    func setBackgroundView(time: Int) {
        let timeToString = String(time).toTime("H", timezoneOffset)
        backgroundView.backgroundColor = (timeToString >= "20" && timeToString <= "5" ?
                                            UIColor.init(red: 0/255, green: 51/255, blue: 102/255, alpha: 1) :
                                            UIColor.init(red: 102/255, green: 178/255, blue: 255/255, alpha: 1))
    }
    
    func setAnimationView(condition: String) {
        animationView.animation = Animation.named(condition.convertLottie())
        animationView.alpha = 0.9
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 사용자에게 위치 추적 권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 배터리에 맞게 위치 정확도 설정
        locationManager.startUpdatingLocation() // 위치 업데이트
        
        /// 위도, 경도 가져오기
        let coor = locationManager.location?.coordinate
        latitude = coor?.latitude
        longtitude = coor?.longitude
        
        fetchWeather(lat: latitude ?? 37.56061111, lon: longtitude ?? 127.039, exclude: "")
        if isAddNewCityView {
            fetchWeather(lat: searchLatitude ?? 37.56061111, lon: searchLongtitude ?? 127.039, exclude: "")
        }
        
        /// 위도, 경도 기반으로 주소 가져오기
        let myLocation = CLLocation(latitude: latitude ?? 37.56061111, longitude: longtitude ?? 127.039)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") /// 한국어로 변환
        geocoder.reverseGeocodeLocation(myLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks, error == nil {
                print(address)
            } else {
                print(error as Any)
            }
            self.myCurrentLocation = (placemarks?.first?.locality ?? "성동구")
            self.mainCV.reloadData()
        })
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(changePageControl(_:)),
                                               name: NSNotification.Name("pageControl"), object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addCity(_:)),
                                               name: NSNotification.Name("appendCity"),
                                               object: nil)
    }
    
    // MARK: - @objc
    @objc func touchupCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func touchupAddButton(_ sender: UIButton) {
        cityList.removeFirst()
        cityList.append(ListModel(subTitle: String(self.currentTime).toTime("a h:mm", self.timezoneOffset),
                                  title: self.location,
                                  temp: String(Int(self.temperature)) + "º"))
        NotificationCenter.default.post(name: NSNotification.Name("appendCity"), object: cityList, userInfo: nil)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func changePageControl(_ notification: Notification) {
        if let number = notification.object as? Int {
            pageControl.currentPage = number
        }
    }
    
    @objc func touchupLeftBarButton(_ sender: UIButton) {
        let application = UIApplication.shared
        let weatherURL = URL(string: "https://weather.com/ko-KR/weather/today/")!
        if application.canOpenURL(weatherURL) {
            application.open(weatherURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func touchupRightBarButton(_ sender: UIButton) {
        let nextVC = ListViewController()
        nextVC.modalPresentationStyle = .currentContext
        nextVC.cityList[0].subTitle = self.myCurrentLocation
        nextVC.cityList[0].title = "나의 위치"
        nextVC.cityList[0].temp = String(Int(self.temperature)) + "º"
        nextVC.setData(cityList: cityList)
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc func addCity(_ notification: Notification) {
        print(cityList, "addCity", "vc")
        if let list = notification.object as? [ListModel] {
            cityList.append(contentsOf: list)
        }
        mainCV.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /// page control selected page 바꾸는 코드
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(page)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + cityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCVC", for: indexPath) as? MainCVC
        else { return UICollectionViewCell() }
        cell.fetchWeather(lat: latitude ?? 37.56061111, lon: longtitude ?? 127.039, exclude: "")
        cell.setData(location: myCurrentLocation,
                     temp: "\(Int(temperature))º",
                     condition: condition,
                     max: "최고: \(Int(max))º",
                     min: "최저: \(Int(min))º")
        setBackgroundView(time: currentTime)
        setAnimationView(condition: condition)
        print(currentTime)
        if isAddNewCityView {
            cell.fetchWeather(lat: searchLatitude!, lon: searchLongtitude!, exclude: "")
            cell.setData(location: location,
                         temp: "\(Int(temperature))º",
                         condition: condition,
                         max: "최고: \(Int(max))º",
                         min: "최저: \(Int(min))º")
//            setBackgroundView(time: currentTime)
//            setAnimationView(condition: condition)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
}

// MARK: - Network : fetchWeather
extension ViewController {
    func fetchWeather(lat: Double, lon: Double, exclude: String) {
        let param = WeatherRequest.init(lat, lon, exclude)
        
        weatherProvider.request(.weather(param: param)) { response in
            switch response {
            case .success(let result):
                do {
                    self.weatherModel = try result.map(WeatherModel.self)
                    if let temp = self.weatherModel?.current.temp,
                       let condition = self.weatherModel?.current.weather[0].weatherDescription,
                       let max = self.weatherModel?.daily[0].temp.max,
                       let min = self.weatherModel?.daily[0].temp.min,
                       let currentTime = self.weatherModel?.current.dt,
                       let timezoneOffset = self.weatherModel?.timezoneOffset {
                        self.temperature = temp
                        self.condition = condition
                        self.max = max
                        self.min = min
                        self.currentTime = currentTime
                        self.timezoneOffset = timezoneOffset
                    }
                    self.cityList = [ListModel(subTitle: self.myCurrentLocation, title: "나의 위치", temp: "\(Int(self.temperature))º")]
                    self.setupCollectionView()
                    self.mainCV.reloadData()
                    
                } catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
