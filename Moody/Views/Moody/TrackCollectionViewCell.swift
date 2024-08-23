//
//  TrackCollectionViewCell.swift
//  Moody
//
//  Created by Диас Сайынов on 12.08.2024.
//

import UIKit
import SnapKit
import Kingfisher

class TrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackCollectionViewCell"
    
    private let trackImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Bold", size: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(trackImageView)
        contentView.addSubview(trackNameLabel)
        
        trackImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.frame.width)
        }
        
        trackNameLabel.snp.makeConstraints { make in
            make.top.equalTo(trackImageView.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview().inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with track: AudioTrack) {
        trackNameLabel.text = track.name
        if let imageURL = track.album.images.first?.url {
            trackImageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"))
        } else {
            trackImageView.image = UIImage(named: "placeholder_image")
        }
    }
}
