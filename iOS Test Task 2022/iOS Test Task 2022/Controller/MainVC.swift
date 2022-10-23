//
//  ViewController.swift
//  iOS Test Task 2022
//
//  Created by Владислав Воробьев on 11.10.2022.
//

import UIKit

class MainVC: UIViewController {
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 16.0
        static let itemHeight: CGFloat = 300.0
    }
    
    var imageNetworkManager = ImagesNetworkManager()
    var startArray = [ImageForUseModel]()
    var imageData = [OneImageData]()
    var images = [ImageForUseModel](){
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var requestNum = 1
    var imgesInRequest = 20
    var requestsCount = 0
    
    lazy var textField = getTextField()
    lazy var topLabel = getTopLabel()
    lazy var bottomLabel = getBottomLabel()
    lazy var topSegmentControl = getTopSegmentControl()
    lazy var bottomSegmentControl = getBottomSegmentControl()
    lazy var collectionView = getColletionView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        
        self.hideKeyboardWhenTappedAround()
        setUpNavigation()
        imageNetworkManager.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUplayout()
    }
    
    @objc func segmentTopButtonPressed() {
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
                
                while images.count < requestNum * imgesInRequest && index < imageData.count {
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
        
        if let request = textField.text{
            DispatchQueue.global().sync {
                requestNum = 1
                imageData = []
                images = []
                imageNetworkManager.feachImage(q: request)
                requestsCount += 1
            }
            
        }
        textField.text = ""
        return true
    }
}

// MARK: - ImageNetworkDelagate
extension MainVC: ImageNetworkDelagate {
    func didUpdateImages(_ imagesNetworkManager: ImagesNetworkManager, images imagesForNet: [OneImageData]) {
        
        imageData = imagesForNet
        var index = images.count
        let requestCheck = requestsCount
        
        while images.count < requestNum * imgesInRequest{
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

// MARK: - HideKeyboard
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
