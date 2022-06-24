//
//  UserCell.swift
//  dominGR1
//
//  Created by Macbook on 21/06/2022.
//


import UIKit
import SDWebImage
class UserCell: UITableViewCell {
    //MARK: - Properties
    
    var viewModel: UserCellViewModel? {
        didSet {
           updateViewModel()
        }
    }
    private let profileImage: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "venom-7")
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        lb.text = "venom"
        return lb
    }()
    
    private let fullnameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.textColor = .lightGray
        lb.text = "Eddie Brock"
        return lb
    }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func configureUI() {
        addSubview(profileImage)
        profileImage.layer.cornerRadius = 48 / 2
        profileImage.setDimensions(height: 48, width: 48)
        profileImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        addSubview(stack)
        stack.centerY(inView: profileImage, leftAnchor: profileImage.rightAnchor, paddingLeft: 8)
    }
    func updateViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
        profileImage.sd_setImage(with: viewModel.profileImage, completed: nil)
    }
}


