//
//  FullScrennImageVC.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 16.10.2022.
//

import Foundation
import UIKit

class FullScrennImageVC: UIViewController{
    var images = [ImageForUseModel]()
    var index = 0{
        didSet{
            chekButtons()
            imageView.image = images[index].image
        }
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.forward.circle")
        button.tag = 1
        button.addTarget(self, action: #selector(imageMoveButtonPressed(_:)), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.backward.circle")
        button.tag = -1
        button.addTarget(self, action: #selector(imageMoveButtonPressed(_:)), for: .touchUpInside)
        
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        let currentImage = images[index]
        imageView.image = currentImage.image
        view.backgroundColor = .systemGray3
        setUpNavigation()
        
        view.addSubview(imageView)
        view.addSubview(forwardButton)
        view.addSubview(backButton)
        chekButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: navigationController?.navigationBar.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            forwardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            forwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            forwardButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            forwardButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            backButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 50)
        ])
    }
    
    func setUpNavigation(){      
        let rightItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(barButtonPressed))
        navigationItem.rightBarButtonItem = rightItem
    }
    @objc func barButtonPressed(){
        let vc = WebVC(adress: images[index].URL)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func imageMoveButtonPressed (_ sender: UIButton){
        let nextIndex = index + sender.tag
        
        switch nextIndex {
        case 0 :
            index = nextIndex
            backButton.isHidden = true
        case images.count - 1:
            index = nextIndex
            forwardButton.isHidden = true
        default:
            index = nextIndex
            backButton.isHidden = false
            forwardButton.isHidden = false
        }
    }
    
    func chekButtons() {
        let nextFowardIndex = index + 1
        let nextBackIndex = index - 1
        let countIndex = images.count - 1
        
        if nextBackIndex < 0 {
            backButton.isHidden = true
        }
        if nextFowardIndex > countIndex{
            forwardButton.isHidden = true
        }
        
    }
}
