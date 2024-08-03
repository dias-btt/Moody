//
//  MyMoodViewController.swift
//  Moody
//
//  Created by Диас Сайынов on 02.07.2024.
//

import UIKit
import SnapKit
import Kingfisher

class MyMoodViewController: UIViewController {
    
    private let topLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Gotham-Bold", size: 30)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "You are listening to"
        return label
    }()
    
    private let currentTrackName: UILabel = {
        let label = UILabel()
         label.font = UIFont(name: "Gotham-Bold", size: 24)
         label.textAlignment = .center
         label.textColor = .white
         return label
     }()
    
    private let currentTrackImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        setupConstraints()
        fetchData()
    }
    
    private func setupViews(){
        view.addSubview(topLabel)
        view.addSubview(currentTrackName)
        view.addSubview(currentTrackImage)
    }
    
    private func setupConstraints(){
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        currentTrackName.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        currentTrackImage.snp.makeConstraints { make in
            make.top.equalTo(currentTrackName.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
    }
    
    private func fetchData(){
        AuthManager.shared.getCurrentTrack { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.currentTrackName.text = model.item.name
                                    
                    if let imageURL = model.item.album.images.first?.url {
                        self?.currentTrackImage.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"))
                    } else {
                        self?.currentTrackImage.image = UIImage(named: "placeholder_image")
                    }
                    AuthManager.shared.getTrackFeatures(id: model.item.id) { [weak self] result in
                        switch result {
                        case .success(let model):
                            APICaller.shared.getRecommendedGenres { result in
                                switch result{
                                case .success(let model2):
                                    let genres = model2.genres
                                    var seeds = Set<String>()
                                    while seeds.count < 5 {
                                        if let random = genres.randomElement(){
                                            seeds.insert(random)
                                        }
                                    }
                                    APICaller.shared.getRecommendations(genres: seeds, acousticness: model.acousticness, danceability: model.danceability, energy: model.energy, instrumentalness: model.instrumentalness, liveness: model.liveness, loudness: model.loudness, speechiness: model.speechiness, tempo: model.tempo, time_signature: model.time_signature, valence: model.valence) { [weak self] result in
                                        DispatchQueue.main.async {
                                            switch result {
                                            case .success(let model):
                                                print("Here is recommendations \(model)")
                                            case .failure(let error):
                                                let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                                                self?.present(alert, animated: true)
                                            }
                                        }
                                    }
                                case .failure(let error): break
                                }
                            }
                        case .failure(let error): break
                        }
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
}
