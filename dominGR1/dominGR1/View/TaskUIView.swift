//
//  TaskUIView.swift
//  dominGR1
//
//  Created by minhdtn on 19/07/2022.
//


import UIKit

class TaskUIView: UIView {
    //MARK: Properties
    //weak var delegate: DidTapProjectCell?
    var projectTitle: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: 16)
        return lb
    }()
    
    var descriptionText: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .left
        lb.font = .systemFont(ofSize: 12)
        lb.textColor = .lightGray
        return lb
    }()
    //MARK: Helpers
    
    //MARK: Actions
    //MARK: Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        let borderView = UIView()
        //        borderView.frame = bounds
        //        borderView.layer.cornerRadius = 10
        //        borderView.layer.borderColor = UIColor.black.cgColor
        //        borderView.layer.borderWidth = 2.0
        //        borderView.layer.masksToBounds = true
        //        borderView.layer.shadowColor = UIColor.black.cgColor
        //        borderView.layer.shadowOpacity = 0.7
        //        borderView.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        //        borderView.layer.shadowRadius = 4.0
        //        addSubview(borderView)
        //        borderView.anchor(top: topAnchor, left: leftAnchor,right: rightAnchor, paddingTop: 2, paddingLeft: 4,paddingRight: 4,width: 400, height: 108)
        contentMode = .scaleToFill
        gradientBorder(colors: [UIColor.red , UIColor.blue], isVertical: false)
        //        layer.shadowColor = UIColor.black.cgColor
        //        layer.shadowOpacity = 0.5
        //        layer.shadowOffset = CGSize.init(width: 3, height: 3)
        //        layer.shadowRadius = 10.0
        addSubview(projectTitle)
        projectTitle.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        addSubview(descriptionText)
        descriptionText.anchor(top: projectTitle.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8, width: 375)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Actions

}

