//
//  BottomView.swift
//  test
//
//  Created by Marianna Ivanova on 25.04.2023.
//
import UIKit
import DropDown

class BottomView : UIView {
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        makeButtons()
        setupViews()
        setupConstraints()
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeButtons () {
        fillButtonsArray()
        makeFractionsButtons (stack: buttonsStack1, array: fractionsButtonsArray1)
        makeFractionsButtons (stack: buttonsStack2, array: fractionsButtonsArray2)
    }
    
    func setupViews () {
        self.addSubview(label)
        self.addSubview(buttonsStack1)
        self.addSubview(buttonsStack2)
        self.addSubview(timeLabel)
        self.addSubview(timeDropDownLabel)
        self.addSubview(timeDropDownButton)
        self.addSubview(availableLabel)
        self.addSubview(availableDropDownLabel)
        self.addSubview(availableDropDownButton)

    }
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
        }
        
        buttonsStack1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
        }
        
        buttonsStack2.snp.makeConstraints { make in
            make.top.equalTo(buttonsStack1.snp.bottom).offset(10)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonsStack2.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(-70)
        }

        timeDropDownLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.left.equalTo(timeLabel)
        }

        timeDropDownButton.snp.makeConstraints { make in
            make.centerY.equalTo(timeDropDownLabel.snp.centerY)
            make.left.equalTo(timeDropDownLabel.snp.right).offset(5)
        }

        availableLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonsStack2.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(70)
        }

        availableDropDownLabel.snp.makeConstraints { make in
            make.top.equalTo(availableLabel.snp.bottom).offset(10)
            make.left.equalTo(availableLabel)
        }

        availableDropDownButton.snp.makeConstraints { make in
            make.centerY.equalTo(availableDropDownLabel.snp.centerY)
            make.left.equalTo(availableDropDownLabel.snp.right).offset(5)
        }

        timeDropDownMenu.anchorView = timeDropDownLabel
        availableDropDownMenu.anchorView = availableDropDownLabel
    }
    
    var buttonsStack1 : UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
       // stack.spacing = 2
        return stack
    }()
    var buttonsStack2 : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
       // stack.spacing = 2
        return stack
    }()
    
    var fractionsButtonsArray : [String] = []
    var fractionsButtonsArray1 : [String] = []
    var fractionsButtonsArray2 : [String] = []
    var fractionsNames1 = ["Бумага", "Пластик", "Стекло", "Металл", "Тетра-пак", "Одежда", "Лампочки", "Крышечки", "Техника", "Батарейки", "Шины", "Опасное", "Другое"]
    var fractions = ["paper", "plastic", "glass", "metal", "tetraPack", "clothes", "bulbs", "caps", "tecnique", "batteries", "tires", "danger", "other"]
    
    func fillButtonsArray () {
        for index in fractions {
            fractionsButtonsArray.append(index+"Button")
            
        }
        fractionsButtonsArray1 = Array(fractionsButtonsArray[0 ... 6])
        fractionsButtonsArray2 = Array(fractionsButtonsArray[7...fractionsButtonsArray.count-1])
    }
    
    func makeFractionsButtons (stack: UIStackView, array: Array<String>) {
        
        for element in array {
            let button : UIButton = {
                let index = fractionsButtonsArray.firstIndex(of: element)!
                let image = UIImage(named: fractions[index])
                let button = UIButton()
                button.setImage(image, for: .normal)
                button.tag = index
                button.addTarget(self, action: #selector(fractionButtonAction), for: .touchUpInside)
                return button
            } ()
            stack.addArrangedSubview(button)
        }
        
    }
    
    @objc func fractionButtonAction (sender: UIButton!) {
        print(" \(sender.tag) button tapped")
    }
    
    lazy var label: UILabel = {
        var view = UILabel()
        view.backgroundColor = .white

        view.textColor = UIColor(red: 0.141, green: 0.149, blue: 0.153, alpha: 1)
        view.font = UIFont(name: "Inter-SemiBold", size: 14)
 
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.94
        view.attributedText = NSMutableAttributedString(string: "Что вы хотите сдать?", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        return view
    }()
    
    private lazy var timeDropDownLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        view.backgroundColor = .white
        view.font = UIFont(name: "Inter-Regular", size: 12)
        view.textAlignment = .center
        view.text = "Не важно"
        
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        view.backgroundColor = .white
        view.font = UIFont(name: "Inter-Medium", size: 12)
        view.textAlignment = .center
        view.text = "Время работы"
        
        return view
    }()
    
    private lazy var availableLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        view.backgroundColor = .white
        view.font = UIFont(name: "Inter-Medium", size: 12)
        view.textAlignment = .center
        view.text = "Доступность"
        
        return view
    }()
    
    private lazy var timeDropDownButton: UIButton = {
        var time = UIButton()
        time.setImage(UIImage(named: "arrow"), for: .normal)
        time.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        time.backgroundColor = .white
        
        time.addTarget(self, action: #selector(timeDropDownButtonDidTap), for: .touchUpInside)
        return time
    }()
    
    
    private lazy var timeDropDownMenu: DropDown = {
        let menu = DropDown()
        let timeValuesArray = ["Не важно", "Открыто сейчас", "Круглосуточно"]
    
        menu.dataSource = timeValuesArray
        menu.selectionAction = { (index: Int, item: String) in
            self.timeDropDownLabel.text = timeValuesArray[index]
            self.timeDropDownLabel.textColor = .black
        }
        menu.textFont = UIFont(name: "Inter-Regular", size: 12) ?? UIFont(name: "Inter-Regular", size: 12)!
        
        return menu
    }()
    
    @objc private func timeDropDownButtonDidTap () {
        
        timeDropDownMenu.show()
        
        
    }
    
    private lazy var availableDropDownLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        view.backgroundColor = .white
        view.font = UIFont(name: "Inter-Regular", size: 12)
        // Line height: 12 pt
        // (identical to box height)
        view.textAlignment = .center
        view.text = "Все пункты"
        
        return view
    }()
    
    private lazy var availableDropDownButton: UIButton = {
        var available = UIButton()
        available.setImage(UIImage(named: "arrow"), for: .normal)
        available.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        available.backgroundColor = .white
        
        available.addTarget(self, action: #selector(availableDropDownButtonDidTap), for: .touchUpInside)
        return available
    }()
    
    private lazy var availableDropDownMenu: DropDown = {
        let menu = DropDown()
        let timeValuesArray = ["Все пункты", "Только общедоступные", "Только частные"]
        menu.textFont = UIFont(name: "Inter-Regular", size: 12) ?? UIFont(name: "Inter-Regular", size: 12)!
        menu.dataSource = timeValuesArray
        menu.selectionAction = { (index: Int, item: String) in
            self.availableDropDownLabel.text = timeValuesArray[index]
            self.availableDropDownLabel.textColor = .black
        }
        
        return menu
    }()
    
    @objc private func availableDropDownButtonDidTap () {
        availableDropDownMenu.show()
    }
}
