//
//  ProfileCell.swift
//  dominGR1
//
//  Created by Macbook on 21/06/2022.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let postImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "venom-7")
        return iv
    }()
    //MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .white
        addSubview(postImage)
        postImage.fillSuperview()
    }
}
