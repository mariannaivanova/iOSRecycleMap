//
//  PointView.swift
//  test
//
//  Created by Marianna Ivanova on 25.04.2023.
//

import Foundation
import UIKit

class PointView : UIView {
    
    var id: String = "1"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        self.addSubview(NameLabel)
        self.addSubview(AddressLabel)
        self.addSubview(HoursLabel)
        self.addSubview(FractionsLabel)
    }
    
    func setupConstraints() {
        NameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.left.equalToSuperview().offset(20)
        }
        AddressLabel.snp.makeConstraints { make in
            make.top.equalTo(NameLabel.snp.bottom).offset(10)
            make.left.equalTo(NameLabel)
        }
        HoursLabel.snp.makeConstraints { make in
            make.top.equalTo(AddressLabel.snp.bottom).offset(10)
            make.left.equalTo(NameLabel)
        }
        FractionsLabel.snp.makeConstraints { make in
            make.top.equalTo(HoursLabel.snp.bottom).offset(10)
            make.left.equalTo(NameLabel)
        }
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var NameLabel : UILabel = {
        var label = UILabel()
        label.text = "Название точки"
        
        return label
    }()
    
    var AddressLabel : UILabel = {
        var label = UILabel()
        label.text = "Адрес"
        
        return label
    }()
    
    var HoursLabel : UILabel = {
        var label = UILabel()
        label.text = "Часы работы"
        
        return label
    }()
    
    var FractionsLabel : UILabel = {
        var label = UILabel()
        label.text = "Фракции"
        
        return label
    }()
    
}
