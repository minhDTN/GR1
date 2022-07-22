//
//  CustomTextField.swift
//  dominGR1
//
//  Created by Macbook on 14/06/2022.
//

import UIKit

class CustomTextFieldAuthentication: UITextField {
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

class CustomTextFieldProject: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        //borderStyle = .line
        
        //tintColor = .black
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        textColor = .black
        keyboardAppearance = .light
        keyboardType = .default
        setHeight(50)
        //backgroundColor = UIColor(white: 1, alpha: 0.1)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 0.5, alpha: 0.7)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

