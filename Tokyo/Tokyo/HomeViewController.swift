//
//  HomeViewController.swift
//  Tokyo
//
//  Created by Hugo Prinsloo on 2018/10/09.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit
import CloudKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let fileManager = FileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 400)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        
        fileManager.fetch { (success) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func handleAddButtonTap(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func didSelectImage(_ image: UIImage) {
        let item = Image(image: image, title: "Some title")
        fileManager.add(item) { (success) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fileManager.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FeedCollectionViewCell
        cell.configure(for: fileManager.item(at: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            didSelectImage(chosenImage)
        }
        dismiss(animated:true, completion: nil)
    }
}

