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
    
    private let recommendedTracksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 120, height: 180)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: TrackCollectionViewCell.identifier)
        return collectionView
    }()

    private var recommendedTracks: [AudioTrack] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        setupConstraints()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }
    
    private func setupViews(){
        view.addSubview(topLabel)
        view.addSubview(currentTrackName)
        view.addSubview(currentTrackImage)
        view.addSubview(recommendedTracksCollectionView)
        recommendedTracksCollectionView.delegate = self
        recommendedTracksCollectionView.dataSource = self
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
        
        recommendedTracksCollectionView.snp.makeConstraints { make in
            make.top.equalTo(currentTrackImage.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(180)
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
                                                self?.recommendedTracks = model.tracks
                                                self?.recommendedTracksCollectionView.reloadData()
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


extension MyMoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedTracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCollectionViewCell.identifier, for: indexPath) as? TrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        let track = recommendedTracks[indexPath.row]
        cell.configure(with: track)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle track selection
        print("Selected track: \(recommendedTracks[indexPath.row].name)")
    }
}
