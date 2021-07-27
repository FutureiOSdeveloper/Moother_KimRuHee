//
//  ViewController.swift
//  Moother iOS
//
//  Created by Thisisme Hi on 2021/07/24.
//

import UIKit

import Then
import SnapKit

class ViewController: UIViewController {
    // MARK: - Properties
    private let backColor: [UIColor] = [.black, .blue, .gray, .darkGray]
    
    let mainCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let topLocationView = TopLocationView()
    
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
    }
    
    // MARK: - Custom Method
    func configUI() {
        view.backgroundColor = .clear
    }
    
    func setupAutoLayout() {
        view.addSubviews([mainCV, lineView, bottomBarView])
        bottomBarView.addSubviews([leftBarButton, pageControl, rightBarButton])
        
        mainCV.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(770)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomBarView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        bottomBarView.snp.makeConstraints { make in
            make.top.equalTo(mainCV.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
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
    
    // MARK: - @objc
    @objc func touchupLeftBarButton(_ sender: UIButton) {
        
    }
    
    @objc func touchupRightBarButton(_ sender: UIButton) {
        let nextVC = WeatherListViewController()
        nextVC.modalPresentationStyle = .fullScreen
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
