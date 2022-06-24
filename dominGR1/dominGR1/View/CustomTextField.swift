//
//  CustomTextField.swift
//  dominGR1
//
//  Created by Macbook on 14/06/2022.
//

import UIKit

class CustomTextField: UITextField {
     init(placeholder: String) {
        super.init(frame: .zero)
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
         
        borderStyle = .none
        layer.cornerRadius = 10.0
        textColor = .white
        keyboardAppearance = .dark
        keyboardType = .emailAddress
        setHeight(50)
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
