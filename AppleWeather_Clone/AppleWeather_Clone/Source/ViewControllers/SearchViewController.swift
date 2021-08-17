//
//  SearchViewController.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/08/02.
//

import UIKit

import MapKit
import Then
import SnapKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    private var searchCompleter = MKLocalSearchCompleter() /// 검색을 도와주는 변수
    private var searchResults = [MKLocalSearchCompletion]() /// 검색 결과를 담는 변수
    
    let topView = UIView().then {
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "도시, 우편번호 또는 공항 위치 입력"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    let searchBar = UISearchBar().then {
        $0.becomeFirstResponder()
        $0.keyboardAppearance = .dark
        $0.showsCancelButton = false
        $0.searchBarStyle = .minimal
        $0.searchTextField.leftView?.tintColor = UIColor.white.withAlphaComponent(0.5)
        $0.searchTextField.backgroundColor = .lightGray
        $0.searchTextField.textColor = .white
        $0.searchTextField.tintColor = .white
        $0.searchTextField.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색",
                                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
    }
    
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.addTarget(self, action: #selector(touchupCancelButton(_:)), for: .touchUpInside)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let searchTV = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupBlurEffect()
        setupAutoLayout()
        setupSearchBar()
        setupSearchCompleter()
        setupTableView()
    }
    
    // MARK: - Custom Method
    func configUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        topView.addSubview(visualEffectView)
    }
    
    func setupAutoLayout() {
        view.addSubviews([topView, searchTV])
        topView.addSubviews([titleLabel, searchBar, cancelButton, lineView])
        
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(6)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-2)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar.snp.centerY)
            make.trailing.equalToSuperview().inset(10)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        searchTV.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func setupTableView() {
        searchTV.delegate = self
        searchTV.dataSource = self
        searchTV.register(SearchTVC.self, forCellReuseIdentifier: "SearchTVC")
        searchTV.separatorStyle = .none
    }
    
    func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address /// resultTypes은 검색 유형인데 address는 주소를 의미
    }
    
    // MARK: - @objc
    @objc func touchupCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    /// 검색 결과 선택 시에 (취소/추가)버튼이 있는 VC이 보여야 함
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let searchReqeust = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchReqeust)
        search.start { (response, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            guard let placeMark = response?.mapItems[0].placemark else {
                return
            }
            let searchLatitude = placeMark.coordinate.latitude
            let searchLongtitude = placeMark.coordinate.longitude
            let vc = ViewController()
            vc.isAddNewCityView = true
            vc.location = (placeMark.locality ?? placeMark.title!)
            vc.searchLatitude = searchLatitude
            vc.searchLongtitude = searchLongtitude
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVC", for: indexPath) as? SearchTVC
        else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if let highlightText = searchBar.text {
            cell.countryLabel.setHighlighted(searchResults[indexPath.row].title, with: highlightText)
        }
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    // 검색창의 text가 변하는 경우에 searchBar가 delegate에게 알리는데 사용하는 함수
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchText를 queryFragment로 넘겨준다.
        searchCompleter.queryFragment = searchText
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension SearchViewController: MKLocalSearchCompleterDelegate {
    // 자동완성 완료 시에 결과를 받는 함수
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // completer.results를 통해 검색한 결과를 searchResults에 담아줍니다
        searchResults = completer.results
        searchTV.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // 에러 확인
        print(error.localizedDescription)
    }
}
