//
//  TrackDetailViewController.swift
//  Moody
//
//  Created by Диас Сайынов on 26.07.2024.
//

import Foundation
import UIKit
import Kingfisher

class TrackDetailViewController: UIViewController {
    
    private let viewModel: TopFiveTracksViewModel
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let trackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Bold", size: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Bold", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: TopFiveTracksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupSubviews()
        setupConstraints()
        configureView()
    }
    
    private func setupSubviews() {
        view.addSubview(coverImageView)
        view.addSubview(trackLabel)
        view.addSubview(artistLabel)
    }
    
    private func setupConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        trackLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(trackLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func configureView() {
        if let url = viewModel.artworkURL {
            coverImageView.kf.setImage(with: url)
        } else {
            coverImageView.image = UIImage(named: "placeholder")
        }
        trackLabel.text = viewModel.name
        artistLabel.text = viewModel.artistName
    }
}
