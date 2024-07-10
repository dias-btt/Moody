//
//  LibraryViewController.swift
//  Moody
//
//  Created by Диас Сайынов on 02.07.2024.
//

import UIKit
import SnapKit

class LibraryViewController: UIViewController {
    
    private let profileView = ProfileView(frame: CGRect(x: 0, y: 0, width: 390, height: 120))
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 145)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Back")
        collectionView.layer.cornerRadius = 20
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let imageNames = ["image1", "image2", "image3", "image4"]
    
    private let playlistTitle: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont(name: "Gotham-Bold", size: 26)
        title.text = "Your playlists"
        title.numberOfLines = 0
        title.textAlignment = .left
        return title
    }()
    
    private let signOutView = SignOutView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupConstraints()
        fetchProfile()
        setupSignOutNotification()
        
        collectionView.dataSource = self
        collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupUI(){
        view.addSubview(profileView)
        view.addSubview(collectionView)
        view.addSubview(playlistTitle)
        view.addSubview(signOutView)
    }
    
    private func setupConstraints(){
        profileView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(130)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(playlistTitle.snp.bottom).offset(20)
            make.height.equalTo(170)
        }
        
        playlistTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(profileView.snp.bottom).offset(20)
        }
        
        signOutView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(53)
        }
    }
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile { [weak self] user in
            DispatchQueue.main.async{
                switch user{
                case .success(let model):
                    self?.updateUI(with: model)
                case .failure(let error):
                    let alert = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    private func updateUI(with model: UserProfile) {
        if let firstImageURL = URL(string: model.images.first?.url ?? "") {
            profileView.configure(imageURL: firstImageURL, title: model.display_name)
        } else {
            profileView.configure(imageURL: nil, title: model.display_name)
        }
    }
    
    private func setupSignOutNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(signOut), name: Notification.Name("SignOutNotification"), object: nil)
    }
    
    @objc private func signOut() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut {[weak self] signedOut in
                if signedOut {
                    DispatchQueue.main.async{
                        let navVC = UINavigationController(rootViewController: WelcomeViewController())
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
}

extension LibraryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionViewCell", for: indexPath) as! PlaylistCollectionViewCell
        
        let imageName = imageNames[indexPath.item]
        cell.imageView.image = UIImage(named: imageName)
        
        return cell
    }
}
