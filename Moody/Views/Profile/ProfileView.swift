//
//  ProfileViewController.swift
//  Moody
//
//  Created by Диас Сайынов on 05.07.2024.
//

import UIKit
import SnapKit
import Kingfisher

class ProfileView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Gotham-Bold", size: 26)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = UIColor(named: "Back")
        layer.cornerRadius = 20

        // Add imageView
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(80)
        }

        // Add titleLabel
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(20)
        }
    }

    func configure(imageURL: URL?, title: String) {
        if let imageURL = imageURL {
            imageView.kf.setImage(with: imageURL)
        } else {
            imageView.image = UIImage(named: "placeholder_image")
        }
        titleLabel.text = "Hello, \(title)!"
    }
}

