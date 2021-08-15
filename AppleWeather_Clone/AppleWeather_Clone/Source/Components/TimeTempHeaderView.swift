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
    // MARK: - Properties
    var timeList = [Current]()
    
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
    
    // MARK: - setData
    func setData(weather: [Current]) {
        self.timeList = weather
    }
}

// MARK: - UICollectionViewDelegate
extension TimeTempHeaderView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension TimeTempHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 27
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeTempCVC.identifier, for: indexPath) as? TimeTempCVC
        else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.timeLabel.text = "지금"
            cell.weatherImageView.image = UIImage(named: timeList[0].weather[0].icon)
            cell.tempLabel.text = String(Int(timeList[0].temp)) + "º"
        } else {
            cell.setData(time: timeList[indexPath.row].dt,
                         image: timeList[indexPath.row].weather[0].icon,
                         temp: timeList[indexPath.row].temp)
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
