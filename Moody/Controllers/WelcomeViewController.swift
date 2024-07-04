//
//  WelcomeViewController.swift
//  Moody
//
//  Created by Диас Сайынов on 02.07.2024.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont(name: "Gotham-Bold", size: 32)
        title.text = "Connect with Spotify"
        return title
    }()
    
    private let subTitleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont(name: "Gotham-Light", size: 22)
        title.text = "We need your account to personalize recommendations"
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    private let connectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Connect", for: .normal)
        button.setTitleColor(UIColor(named: "PrimaryGreen"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapConnect), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "PrimaryGreen")
        setupViews()
        setupConstraints()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func setupViews(){
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(connectButton)
    }
    
    private func setupConstraints(){
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        connectButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.height.equalTo(50)
        }
    }
    
    @objc func didTapConnect(){
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async{
                self?.handleConnection(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleConnection(success: Bool){
        guard success else{
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signed in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
