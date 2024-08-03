//
//  MoodyTrack.swift
//  Moody
//
//  Created by Диас Сайынов on 03.08.2024.
//

import Foundation
import UIKit
import SnapKit

class MoodyTrackView: UIView {
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
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
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        addSubview(coverImage)
        addSubview(trackLabel)
        addSubview(artistLabel)
    }
}
