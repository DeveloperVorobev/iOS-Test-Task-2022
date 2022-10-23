//
//  Views.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 22.10.2022.
//

import Foundation
import UIKit

extension MainVC{
    
    private enum Constants {
        static let rigthConstraint: CGFloat = -15
        static let leftConstraint: CGFloat = 15
        static let tfHeight: CGFloat = 34
        static let labelHeight: CGFloat = 31
        static let cegmentHeight: CGFloat = 34
    }
    
    func getTextField() -> UITextField{
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = .systemBackground
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .go
        textField.autocapitalizationType = .sentences
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.delegate = self
        return textField
    }
    
    func getTopLabel() -> UILabel{
        let label = UILabel()
        label.text = "Sorting uploaded images by size"
        label.font.withSize(17)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        return label
    }
    
    func getBottomLabel() -> UILabel{
        let label = UILabel()
        label.text = "Region for the next search"
        label.font.withSize(17)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
    
        return label
    }
    
    func getTopSegmentControl() -> UISegmentedControl{
        let itemsForSegmentComtrol: [Any] = ["None", UIImage(systemName: "arrowtriangle.down")!, UIImage(systemName: "arrowtriangle.up")!]
        let segment = UISegmentedControl(items: itemsForSegmentComtrol)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5.0
        segment.backgroundColor = .systemGray3
        segment.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segment)
        segment.addTarget(self, action: #selector(segmentTopButtonPressed), for: .valueChanged)
        
        return segment
    }
    
    func getBottomSegmentControl() -> UISegmentedControl{
        let itemsForSegmentComtrol = ["Default", "France", "Germany", "Russia", "Italy"]
        let segment = UISegmentedControl(items: itemsForSegmentComtrol)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5.0
        segment.backgroundColor = .systemGray3
        segment.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segment)
        segment.addTarget(self, action: #selector(segmentBottomButtonPressed), for: .valueChanged)
        
        return segment
    }
    
    func getColletionView() -> UICollectionView{
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray3
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifire)
        
        return collectionView
    }
    
    func setUpNavigation(){
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.topItem?.title = "iOS Test Task 2022"
        navigationController?.navigationBar.backgroundColor = .systemGray3
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(barButtonPressed))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func segmentBottomButtonPressed (){
        let index = bottomSegmentControl.selectedSegmentIndex
        let region = ["nil", "fr", "de", "ru", "it"]
        imageNetworkManager.region = region[index]
    }
    
    @objc func barButtonPressed(){
        let vc = WebVC(adress: imageNetworkManager.imagesDataURL)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUplayout(){
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: navigationController?.navigationBar.bottomAnchor ?? view.topAnchor),
            textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.leftConstraint),
            textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: Constants.rigthConstraint),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.tfHeight)
        ])
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            topLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.leftConstraint),
            topLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: Constants.rigthConstraint),
            topLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.labelHeight)
        ])
        NSLayoutConstraint.activate([
            topSegmentControl.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            topSegmentControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: Constants.rigthConstraint),
            topSegmentControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.leftConstraint),
            topSegmentControl.bottomAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: Constants.cegmentHeight)
        ])
        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: topSegmentControl.bottomAnchor),
            bottomLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.leftConstraint),
            bottomLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: Constants.rigthConstraint),
            bottomLabel.bottomAnchor.constraint(equalTo: topSegmentControl.bottomAnchor, constant: Constants.labelHeight)
        ])
        NSLayoutConstraint.activate([
            bottomSegmentControl.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor),
            bottomSegmentControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.leftConstraint),
            bottomSegmentControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: Constants.rigthConstraint),
            bottomSegmentControl.bottomAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: Constants.cegmentHeight)
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: bottomSegmentControl.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

