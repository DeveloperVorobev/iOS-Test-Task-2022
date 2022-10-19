//
//  ViewController.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 11.10.2022.
//

import UIKit

class MainVC: UIViewController {
    
    var requestNum = 1
    var imgesInRequest = 12
    var isCurrentRequest = true
    var requestsCount = 0
    

    
    var imageData = [OneImageData]()
    var images = [ImageForUseModel](){
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var startArray = [ImageForUseModel]()
    
    var imageNetworkManager = ImagesNetworkManager()
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 16.0
        static let itemHeight: CGFloat = 300.0
    }
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = .systemBackground
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .go
        textField.autocapitalizationType = .sentences
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Sorting uploaded images by size"
        label.font.withSize(17)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "Region for the next search"
        label.font.withSize(17)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var topSegmentControl: UISegmentedControl = {
        let itemsForSegmentComtrol: [Any] = ["None", UIImage(systemName: "arrowtriangle.down")!, UIImage(systemName: "arrowtriangle.up")!]
        let segment = UISegmentedControl(items: itemsForSegmentComtrol)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5.0
        segment.backgroundColor = .systemGray3
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        return segment
    }()
    
   
    
    var bottomSegmentControl: UISegmentedControl = {
        let itemsForSegmentComtrol = ["Default", "France", "Germany", "Russia", "Italy"]
        let segment = UISegmentedControl(items: itemsForSegmentComtrol)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5.0
        segment.backgroundColor = .systemGray3
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        return segment
    }()
    
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray3
        return collectionView
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .systemGray3
        setUpNavigation()
        
        textField.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        imageNetworkManager.delegate = self
        topSegmentControl.addTarget(self, action: #selector(segmentTopButtonPressed), for: .valueChanged)
        bottomSegmentControl.addTarget(self, action: #selector(segmentBottomButtonPressed), for: .valueChanged)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifire)
        view.addSubview(textField)
        view.addSubview(topLabel)
        view.addSubview(topSegmentControl)
        view.addSubview(bottomLabel)
        view.addSubview(bottomSegmentControl)
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUplayout()
        
    }
    
    @objc func segmentTopButtonPressed (){
        let index = topSegmentControl.selectedSegmentIndex
        var resultArray = [ImageForUseModel]()
        if index == 1{
             resultArray = images.sorted(by: {$0.size > $1.size})
        } else if index == 2{
            resultArray = images.sorted(by: {$0.size < $1.size})
        } else{
            resultArray = startArray
        }
        images = resultArray
        
    }
    
    @objc func segmentBottomButtonPressed (){
        let index = bottomSegmentControl.selectedSegmentIndex
        let region = ["nil", "fr", "de", "ru", "it"]
        imageNetworkManager.region = region[index]
    }
    
    func setUpNavigation(){
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.topItem?.title = "iOS Test Task 2022"
        navigationController?.navigationBar.backgroundColor = .systemGray3
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(barButtonPressed))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func barButtonPressed(){
        let vc = WebVC(adress: imageNetworkManager.imagesDataURL)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setUplayout(){
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: navigationController?.navigationBar.bottomAnchor ?? view.topAnchor),
            textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
        ])
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            topLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            topLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            topLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 31)
        ])
        NSLayoutConstraint.activate([
            topSegmentControl.topAnchor.constraint(equalTo: topLabel.bottomAnchor),
            topSegmentControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            topSegmentControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            topSegmentControl.bottomAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 34)
        ])
        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: topSegmentControl.bottomAnchor),
            bottomLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            bottomLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            bottomLabel.bottomAnchor.constraint(equalTo: topSegmentControl.bottomAnchor, constant: 31)
        ])
        NSLayoutConstraint.activate([
            bottomSegmentControl.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor),
            bottomSegmentControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            bottomSegmentControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            bottomSegmentControl.bottomAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: 34)
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: bottomSegmentControl.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifire, for: indexPath) as! ImageCell
        let image = images[indexPath.row]
        cell.setup(with: image.image)
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == images.count - 1 && images.count == requestNum * imgesInRequest{
            var index = images.count
            requestNum += 1

            DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                let requestCheck = requestsCount
                while images.count < requestNum * imgesInRequest && isCurrentRequest{
                    if let safeImage = imageNetworkManager.requestForImage(imagesForNet: imageData[index]){
                        guard requestCheck == requestsCount else {break}
                        let size = imageData[index].original_height * imageData[index].original_width
                        let url = imageData[index].original
                        let newElenent = ImageForUseModel(image: safeImage, size: size, URL: url)
                        self.images.append(newElenent)
                        self.startArray.append(newElenent)
                        index += 1
                    } else {
                        imageData.remove(at: index)
                    }
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = FullScrennImageVC()
        vc.images = images
        vc.index = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = itemWidth(for: view.frame.width, spacing: LayoutConstant.spacing)
        
        return CGSize(width: width, height: width)
    }
    
    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 2
        
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        
        return floor(finalWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.spacing, left: LayoutConstant.spacing, bottom: LayoutConstant.spacing, right: LayoutConstant.spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.spacing
    }
}

// MARK: - UITextFieldDelegate

extension MainVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        DispatchQueue.global().sync {
            self.isCurrentRequest = false
        }
        
        if let request = textField.text{
            DispatchQueue.global().sync {
                requestNum = 1
                imageData = []
                images = []
                imageNetworkManager.feachImage(q: request)
                isCurrentRequest = true
                requestsCount += 1
            }
            
        }
        textField.text = ""
        return true
    }
}

extension MainVC: ImageNetworkDelagate {
    func didUpdateImages(_ imagesNetworkManager: ImagesNetworkManager, images imagesForNet: [OneImageData]) {
        
        imageData = imagesForNet
        var index = images.count
        let requestCheck = requestsCount
        while images.count < requestNum * imgesInRequest && isCurrentRequest{
            if let safeImage = imagesNetworkManager.requestForImage(imagesForNet: imageData[index]){
                guard requestCheck == requestsCount else {break}
                DispatchQueue.global(qos: .userInteractive).sync {
                    let size = imageData[index].original_height * imageData[index].original_width
                    let url = imageData[index].original
                    let newElenent = ImageForUseModel(image: safeImage, size: size, URL: url)
                    self.images.append(newElenent)
                    self.startArray.append(newElenent)
                    index += 1
                }
            } else {
                imageData.remove(at: index)
            }
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

extension MainVC {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
