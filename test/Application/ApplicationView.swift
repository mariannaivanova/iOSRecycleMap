//
//  ApplicationView.swift
//  test
//
//  Created by Marianna Ivanova on 26.04.2023.
//

import Foundation
import UIKit
import DropDown

class ApplicationView: UIView {
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var firstLabel: UILabel = {
        var view = UILabel()
       // view.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        view.backgroundColor = .white
        view.font = UIFont(name: "Inter-Regular", size: 20)
        view.textAlignment = .center
        view.text = "Заявка на добавление нового пункта"
        
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Название пункта"
        field.font = UIFont(name: "Inter-Medium", size: 15)
        field.backgroundColor = .white
        field.layer.cornerRadius = 8
        return field
    }()
    
    lazy var addressTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Адрес"
        field.font = UIFont(name: "Inter-Medium", size: 15)
        field.backgroundColor = .white
        field.layer.cornerRadius = 8
        return field
    }()
    
    private lazy var typeLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        view.backgroundColor = .white
        view.font = UIFont(name: "Inter-Medium", size: 15)
        view.textAlignment = .center
        view.text = "Выберите тип фракций"
        
        return view
    }()
    
    private lazy var typeDropDownButton: UIButton = {
        var time = UIButton()
        time.setImage(UIImage(named: "arrow"), for: .normal)
        time.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        time.backgroundColor = .white
        
        time.addTarget(self, action: #selector(typeDropDownButtonDidTap), for: .touchUpInside)
        return time
    }()
    
    private lazy var typeDropDownLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        view.backgroundColor = .white
        view.font = UIFont(name: "Inter-Regular", size: 15)
        view.textAlignment = .center
        view.text = "Бумага"
        
        return view
    }()
    
    private lazy var typeDropDownMenu: DropDown = {
        let menu = DropDown()
        let timeValuesArray = ["Бумага", "Пластик", "Стекло", "Металл", "Тетра-пак", "Одежда", "Лампочки", "Крышечки", "Техника", "Батарейки", "Шины", "Опасное", "Другое"]
    
        menu.dataSource = timeValuesArray
        menu.selectionAction = { (index: Int, item: String) in
            self.typeDropDownLabel.text = timeValuesArray[index]
            self.typeDropDownLabel.textColor = .black
        }
        menu.textFont = UIFont(name: "Inter-Regular", size: 15) ?? UIFont(name: "Inter-Regular", size: 15)!
        
        return menu
    }()
    
    @objc private func typeDropDownButtonDidTap () {
        
        typeDropDownMenu.show()
        
        
    }
    
    private lazy var sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("Отправить", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 15)
        button.backgroundColor = .systemGreen
        return button
    }()
    
    func addViews() {
        self.addSubview(firstLabel)
        self.addSubview(nameTextField)
        self.addSubview(addressTextField)
        self.addSubview(typeLabel)
        self.addSubview(typeDropDownMenu)
        self.addSubview(typeDropDownLabel)
        self.addSubview(typeDropDownButton)
        self.addSubview(sendButton)
    }
    
    func setConstraints () {
        
        firstLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).offset(20)
            make.left.equalTo(firstLabel)
        }
        
        addressTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.left.equalTo(firstLabel)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(addressTextField.snp.bottom).offset(20)
            make.left.equalTo(firstLabel)
        }

        typeDropDownLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(10)
            make.left.equalTo(typeLabel)
        }

        typeDropDownButton.snp.makeConstraints { make in
            make.centerY.equalTo(typeDropDownLabel.snp.centerY)
            make.left.equalTo(typeDropDownLabel.snp.right).offset(5)
        }
        
        typeDropDownMenu.anchorView = typeDropDownLabel
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(50)
            make.left.equalTo(firstLabel)
        }
    }
    
    
}
