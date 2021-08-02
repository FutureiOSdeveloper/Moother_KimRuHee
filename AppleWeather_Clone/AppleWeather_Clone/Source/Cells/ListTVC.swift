//
//  ListTVC.swift
//  AppleWeather_Clone
//
//  Created by Thisisme Hi on 2021/07/28.
//

import UIKit

class ListTVC: UITableViewCell {
    static let identifier = "ListTVC"
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Custom Method
    func configUI() {
        
    }
    
    func setupAutoLayout() {
        
    }
}
