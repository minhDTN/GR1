//
//  PostController.swift
//  dominGR1
//
//  Created by Macbook on 28/06/2022.
//

import UIKit
protocol DidFinishUploadingPostDelegate: AnyObject {
    func updateFeedAfterUploadingPost()
}
class PostController: UIViewController{
    //MARK: Properties
    weak var delegate: DidFinishUploadingPostDelegate?
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    private lazy var captionTextView: CustomTextView = {
        let tv = CustomTextView()
        tv.delegate = self
        tv.placeHolder = "Enter caption"
        return tv
    }()
    private let wordCountLabel: UILabel = {
        let lb = UILabel()
        lb.text = "0/\(MAX_LENGTH_POST)"
        lb.textColor = .lightGray
        lb.font = .systemFont(ofSize: 14)
        return lb
    }()
    
    //MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.delegate = self.navigationController?.tabBarController as? MainTabController
        configureUI()
    }
    //MARK: Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.title = "Upload Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapShare))
        navigationItem.rightBarButtonItem?.tintColor = .black
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.topAnchor, paddingTop: 100)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        view.addSubview(wordCountLabel)
        wordCountLabel.anchor(top: captionTextView.bottomAnchor, right: view.rightAnchor,paddingTop: 8, paddingRight: 12)
    }
    
    func checkMaxLength(textView: UITextView) {
        if textView.text.count > MAX_LENGTH_POST {
            textView.deleteBackward()
        }
    }
    //MARK: Actions
    @objc func didTapCancel(){
        self.dismiss(animated: true)
    }
    @objc func didTapShare(){
        print("DEBUG: Begin share post\n")
        guard let selectedImage = photoImageView.image else { return }
        guard let caption = captionTextView.text else { return }
        showLoader(true)
        PostService.uploadPost(caption: caption, image: selectedImage) { error in
            self.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to upload post \(error.localizedDescription)")
                return
            }
            self.delegate?.updateFeedAfterUploadingPost()
        }
        //self.dismiss(animated: true)
        print("DEBUG: After share post\n")
    }
    
}

//MARK: UITextViewDelegate
extension PostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textView: textView)
        let count = textView.text.count
        wordCountLabel.text = "\(count)/\(MAX_LENGTH_POST)"
    }
}
