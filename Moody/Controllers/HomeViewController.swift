//
//  HomeViewController.swift
//  Moody
//
//  Created by Диас Сайынов on 02.07.2024.
//

import UIKit

enum HomeSectionType {
    case topFiveTracks(viewModels: [TopFiveTracksViewModel])
    case recommendedTracks(viewModels: [RecommendedTracksViewModel])
    case newReleases
}

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let sectionHeaderIdentifier = "SectionHeader"
    
    private let topTracksLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Gotham-Bold", size: 30)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private var tracks: [TopTracksResponse]?
    
    private var sections = [HomeSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
        
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            return self?.createSectionLayout(index: sectionIndex)
        }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TopFiveTracksCollectionViewCell.self, forCellWithReuseIdentifier: TopFiveTracksCollectionViewCell.identifier)
        collectionView.register(RecommendedTracksCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTracksCollectionViewCell.identifier)

        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderIdentifier)
        view.addSubview(collectionView)
    }
    
    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        
        var topFiveTracks: TopTracksResponse?
        var recommendations: RecommendedTracks?
        
        APICaller.shared.getTopFiveTracks { [weak self] result in
            defer {
                group.leave()
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    topFiveTracks = model
                case .failure(let error):
                    let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
        
        group.enter()
        APICaller.shared.getRecommendations { [weak self] result in
            defer {
                group.leave()
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    recommendations = model
                case .failure(let error):
                    let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }

        group.notify(queue: .main) {
            guard let topFiveTracks = topFiveTracks?.items else {
                return
            }
            
            guard let recommendations = recommendations?.tracks else {
                return
            }
            
            self.configureModel(newAlbums: topFiveTracks, recommendations: recommendations)
        }
    }
    
    private func configureModel(newAlbums: [Track], recommendations: [AudioTrack]){
        sections.append(.topFiveTracks(viewModels: newAlbums.compactMap({
            return TopFiveTracksViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "", artworkURL: URL(string: $0.album.images.first?.url ?? ""))
        })))
        sections.append(.recommendedTracks(viewModels: recommendations.compactMap({
            return RecommendedTracksViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "", artworkURL: URL(string: $0.album.images.first?.url ?? ""))
        })))
        collectionView.reloadData()
    }
    
    private func createSectionLayout(index: Int) -> NSCollectionLayoutSection {
        switch index{
        case 0, 1, 2:
            // Create item size
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(250),
                                                  heightDimension: .absolute(250))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
            
            // Create group size
            let hGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(175),
                                                    heightDimension: .absolute(250))
            
            let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: hGroupSize, subitem: item, count: 1)

            
            // Create section
            let section = NSCollectionLayoutSection(group: hGroup)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        default:
            // Create item size
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // Create group size
            let vGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .absolute(360))
            
            let vGroup = NSCollectionLayoutGroup.vertical(layoutSize: vGroupSize, subitem: item, count: 1)

            
            // Create section
            let section = NSCollectionLayoutSection(group: vGroup)
            return section
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type{
        case .topFiveTracks(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .topFiveTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopFiveTracksCollectionViewCell.identifier, for: indexPath) as? TopFiveTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        case .newReleases:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopFiveTracksCollectionViewCell.identifier, for: indexPath) as? TopFiveTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTracksCollectionViewCell.identifier, for: indexPath) as? RecommendedTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderIdentifier, for: indexPath) as! SectionHeader
        
        switch sections[indexPath.section] {
        case .topFiveTracks:
            headerView.titleLabel.text = "Your Top Tracks"
        case .recommendedTracks:
            headerView.titleLabel.text = "Recommended Tracks"
        case .newReleases:
            headerView.titleLabel.text = "New Releases"
        }
        
        return headerView
    }
}
