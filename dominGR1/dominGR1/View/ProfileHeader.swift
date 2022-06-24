//
//  ProfileHeader.swift
//  dominGR1
//
//  Created by Macbook on 21/06/2022.
//


import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}
class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    weak var delegate: ProfileHeaderDelegate?
    var viewModel: ProfileHeaderViewModel? {
        didSet { updateViewModel() }
    }
    private let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    private lazy var editProfileFollowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Loading", for: .normal)
        btn.layer.cornerRadius = 3
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(handleEditProfileTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var postsLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    private lazy var followersLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    private lazy var followingLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
    private let gridButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "grid"), for: .normal)
        return btn
    }()
    private let listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "list"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    private let bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "ribbon"), for: .normal)
        btn.tintColor = UIColor(white: 0, alpha: 0.2)
        return btn
    }()
    //MARK: - Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers]
    func updateViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        nameLabel.text = viewModel.fullname
        profileImage.sd_setImage(with: viewModel.profileImage, completed: nil)
        followersLabel.attributedText =  viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
        postsLabel.attributedText = viewModel.numberOfPosts
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonColor
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
    func configureUI() {
        backgroundColor = .white
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileImage.setDimensions(height: 80, width: 80)
        profileImage.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImage.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 24,paddingRight: 24)
        
        setUpLabelStack()
        setUpButtonStack()
    }
    func setUpLabelStack() {
        let stack = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        stack.distribution  = .fillEqually
        addSubview(stack)
        stack.centerY(inView: profileImage)
        stack.anchor(left: profileImage.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
    }
    func setUpButtonStack() {
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStack.distribution = .fillEqually
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        addSubview(buttonStack)
        buttonStack.anchor(left: leftAnchor,bottom: bottomAnchor, right: rightAnchor, height: 50)
        addSubview(topDivider)
        topDivider.anchor(left: leftAnchor, bottom: buttonStack.topAnchor, right: rightAnchor, height:  0.5)
        addSubview(bottomDivider)
        bottomDivider.anchor(top: buttonStack.bottomAnchor,left: leftAnchor, right: rightAnchor, height:  0.5)
    }
    //MARK: - Actions
    @objc func handleEditProfileTapped() {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
}

