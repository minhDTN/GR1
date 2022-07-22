//
//  TextViewExtension.swift
//  dominGR1
//
//  Created by Macbook on 12/07/2022.
//

import UIKit

class CustomTextView: UITextView {
    
    //MARK: Properties
    var placeHolder : String? {
        didSet {
            lblPlaceHolder.text = placeHolder
        }
    }
    private let lblPlaceHolder: UILabel = {
        let lblPlaceHolder = UILabel()
        lblPlaceHolder.font = UIFont.systemFont(ofSize: 16)
        lblPlaceHolder.sizeToFit()
        lblPlaceHolder.textColor = UIColor.lightGray
        return lblPlaceHolder
    }()
    //MARK: Lifecycles
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(lblPlaceHolder)
        lblPlaceHolder.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textDidChange() {
        lblPlaceHolder.isHidden = !text.isEmpty
    }
}
