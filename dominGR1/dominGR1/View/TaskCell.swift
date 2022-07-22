//
//  TaskCell.swift
//  dominGR1
//
//  Created by minhdtn on 19/07/2022.
//


import UIKit

class TaskCell: UICollectionViewCell {
    // MARK: Properties
    var taskViewModel: TaskViewModel? {
        didSet {
            updateViewModel()
        }
    }
    private lazy var projectCell: TaskUIView = {
        let uv = TaskUIView()
        return uv
    }()
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

//        layer.borderWidth = 3
//        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 10.0
        //setGradientBorder(width: 0.5, colors: [UIColor.red , UIColor.blue])
        gradientBorder(colors: [UIColor.purple , UIColor.blue, UIColor.orange], isVertical: false)
        addSubview(projectCell)
        projectCell.setDimensions(height: 104, width: 400)
        projectCell.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Actions

    // MARK: Helpers
    func updateViewModel() {
        guard let viewModel = taskViewModel else { return }
        projectCell.projectTitle.text = viewModel.taskTitle
        projectCell.descriptionText.text = viewModel.descriptionLabel()
    }
}

