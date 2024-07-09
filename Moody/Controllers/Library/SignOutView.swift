//
//  SignOutView.swift
//  Moody
//
//  Created by Диас Сайынов on 09.07.2024.
//

import UIKit
import SnapKit
import Kingfisher

class SignOutView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "signOut")
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Gotham-Bold", size: 18)
        label.textColor = .white
        label.text = "Sign Out"
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
            make.width.height.equalTo(30)
        }

        // Add titleLabel
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(20)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signOutTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func signOutTapped() {
        // Notify the delegate or handle sign-out directly
        NotificationCenter.default.post(name: Notification.Name("SignOutNotification"), object: nil)
    }
}
