//
//  HomeViewController.swift
//  Moody
//
//  Created by Диас Сайынов on 02.07.2024.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getTopFiveTracks { res in
            switch res{
            case .success(let model) : break
            case .failure(let error) : break
            }
        }
    }

}
