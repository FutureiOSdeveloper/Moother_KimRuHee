//
//  ViewController.swift
//  Moother iOS
//
//  Created by Thisisme Hi on 2021/07/24.
//

import UIKit

import CoreLocation
import Lottie
import Then
import SafariServices
import SnapKit

class ViewController: UIViewController {
    // MARK: - Properties
    private let backColor: [UIColor] = [.clear, .clear, .clear, .clear]
    
    var isAddNewCityView: Bool = false
    var location: String = ""
    
    /// locationManager 인스턴스 생성
    var locationManager: CLLocationManager! = CLLocationManager()
    
    /// 위도 및 경도
    var latitude: Double?
    var longtitude: Double?
    
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
    
    let backgroundView = UIImageView().then {
        $0.image = UIImage(named: "backImage")
    }
    
    let animationView = AnimationView().then {
        //        $0.animation = Animation.named("16477-rain-background-animation")
        $0.contentMode = .scaleAspectFill
        $0.loopMode = .loop
        $0.play()
    }
    
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
        configUI()
        setupCollectionView()
        setupAutoLayout()
        setupPageControl()
        setupLocationManager()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePageControl(_:)),
                                               name: NSNotification.Name("pageControl"), object: nil)
    }
    
    // MARK: - Custom Method
    func configUI() {
        view.backgroundColor = .clear
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
            make.edges.equalToSuperview()
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
        }
    }
    
    func setupCollectionView() {
        mainCV.delegate = self
        mainCV.dataSource = self
        mainCV.register(MainCVC.self, forCellWithReuseIdentifier: "MainCVC")
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = backColor.count
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
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
        print("위도 = \(latitude!), 경도 = \(longtitude!)")
        
        /// 위도, 경도 기반으로 주소 가져오기
        let myLocation = CLLocation(latitude: latitude!, longitude: longtitude!)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") /// 한국어로 변환
        geocoder.reverseGeocodeLocation(myLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks, error == nil {
                print(address)
            } else {
                print(error as Any)
            }
            
            let cityName = placemarks?.first?.locality
            print(cityName!)
        })
    }
    
    // MARK: - @objc
    @objc func touchupCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func touchupAddButton(_ sender: UIButton) {
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true) {
            pvc.dismiss(animated: true, completion: nil)
            pvc.modalPresentationStyle = .overFullScreen
            pvc.present(ListViewController(), animated: true) {
                // 여기에 노티로 도시이름, 온도 추가해주는 거 쏴줘야 함. )
            }
        }
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
        present(nextVC, animated: true, completion: nil)
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
        return backColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCVC", for: indexPath) as? MainCVC
        else { return UICollectionViewCell() }
        cell.backgroundColor = backColor[indexPath.item]
        if isAddNewCityView {
            cell.locationLabel.text = location
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
