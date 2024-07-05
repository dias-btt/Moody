//
//  LibraryViewController.swift
//  Moody
//
//  Created by Диас Сайынов on 02.07.2024.
//

import UIKit
import SnapKit

class LibraryViewController: UIViewController {
    
    let profileView = ProfileViewController(frame: CGRect(x: 0, y: 0, width: 390, height: 120))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        fetchProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupUI(){
        view.addSubview(profileView)
    }
    
    private func setupConstraints(){
        profileView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(140)
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
            // Handle case where URL cannot be created from string
            profileView.configure(imageURL: nil, title: model.display_name)
        }
    }
}
