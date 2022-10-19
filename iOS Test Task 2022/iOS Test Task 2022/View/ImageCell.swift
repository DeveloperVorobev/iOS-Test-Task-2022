//
//  CollectionCellCollectionViewCell.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 12.10.2022.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    
    static let identifire = "MySell"

    private enum Constants {
        // MARK: contentView layout constants
        static let contentViewCornerRadius: CGFloat = 4.0

        // MARK: profileImageView layout constants
        static let imageHeight: CGFloat = 180.0

        // MARK: Generic layout constants
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let profileDescriptionVerticalPadding: CGFloat = 8.0
    }

    private let myImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()


    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupLayouts()
    }

    private func setupView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.backgroundColor = .white

        contentView.addSubview(myImageView)
    }

    private func setupLayouts() {
        myImageView.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            myImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            myImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with image: UIImage) {
        myImageView.image = image
    }
}

//https://serpapi.com/search.json?q=Apple&tbs=itp:photos&tbm=isch&ijn=0&device=mobile&ijn=0
