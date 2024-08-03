//
//  TopFiveTracksCollectionViewCell.swift
//  Moody
//
//  Created by Диас Сайынов on 10.07.2024.
//

import UIKit
import Kingfisher
import SnapKit

class TopFiveTracksCollectionViewCell: UICollectionViewCell {
    static let identifier = "TopFiveTracksCollectionViewCell"
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let trackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Bold", size: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Bold", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "Back")
        contentView.layer.cornerRadius = 20
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(coverImage)
        contentView.addSubview(trackLabel)
        contentView.addSubview(artistLabel)
    }
    
    private func setupConstraints() {
        coverImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(contentView.height / 2)
        }
        
        trackLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImage.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(trackLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackLabel.text = nil
        artistLabel.text = nil
        coverImage.image = UIImage(named: "placeholder")
    }
    
    func configure(with model: TopFiveTracksViewModel) {
        if let url = model.artworkURL {
            coverImage.kf.setImage(with: url)
        } else {
            coverImage.image = UIImage(named: "placeholder")
        }
        
        trackLabel.text = model.name
        artistLabel.text = model.artistName
    }
}
