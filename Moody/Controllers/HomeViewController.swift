//
//  HomeViewController.swift
//  Moody
//
//  Created by Диас Сайынов on 02.07.2024.
//

import UIKit

enum HomeSectionType {
    case topFiveTracks(viewModels: [TopFiveTracksViewModel])
    case recommendedTracks
    case newReleases
}

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
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
        view.addSubview(collectionView)
    }
    
    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        
        var topFiveTracks: TopTracksResponse?
        
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
        
        group.notify(queue: .main) {
            guard let topFiveTracks = topFiveTracks?.items else {
                return
            }
            
            self.configureModel(newAlbums: topFiveTracks)
        }
    }
    
    private func configureModel(newAlbums: [Track]){
        sections.append(.topFiveTracks(viewModels: newAlbums.compactMap({
            return TopFiveTracksViewModel(name: $0.name, artistName: $0.artists.first?.name ?? "", artworkURL: URL(string: $0.album.images.first?.url ?? ""))
        })))
    }
    
    private func createSectionLayout(index: Int) -> NSCollectionLayoutSection {
        switch index{
        case 0:
            // Create item size
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(250),
                                                  heightDimension: .absolute(250))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // Create group size
            let hGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(250),
                                                    heightDimension: .absolute(250))
            
            let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: hGroupSize, subitem: item, count: 1)

            
            // Create section
            let section = NSCollectionLayoutSection(group: hGroup)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        case 1:
            // Create item size
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(250),
                                                  heightDimension: .absolute(250))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // Create group size
            let hGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(250),
                                                    heightDimension: .absolute(250))
            
            let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: hGroupSize, subitem: item, count: 1)

            
            // Create section
            let section = NSCollectionLayoutSection(group: hGroup)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        case 2:
            // Create item size
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(250),
                                                  heightDimension: .absolute(250))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            // Create group size
            let hGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(250),
                                                    heightDimension: .absolute(250))
            
            let hGroup = NSCollectionLayoutGroup.horizontal(layoutSize: hGroupSize, subitem: item, count: 1)

            
            // Create section
            let section = NSCollectionLayoutSection(group: hGroup)
            section.orthogonalScrollingBehavior = .continuous
            
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
            return cell
        case .newReleases:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopFiveTracksCollectionViewCell.identifier, for: indexPath) as? TopFiveTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        case .recommendedTracks:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopFiveTracksCollectionViewCell.identifier, for: indexPath) as? TopFiveTracksCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
}
