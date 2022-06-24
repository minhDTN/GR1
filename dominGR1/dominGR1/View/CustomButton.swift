//
//  CustomButton.swift
//  dominGR1
//
//  Created by Macbook on 14/06/2022.
//

import UIKit
class CustomButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
        layer.cornerRadius = 10.0
        backgroundColor =  .systemPurple.withAlphaComponent(0.5)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        setHeight(50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
