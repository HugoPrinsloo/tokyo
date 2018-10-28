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
        layout.itemSize = CGSize(width: collectionView.frame.width - 32, height: 400)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        layout.minimumLineSpacing = 16
        collectionView.collectionViewLayout = layout
        
        fileManager.fetchItems { (success) in
            if success {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        title = "Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    @IBAction func handleAddButtonTap(_ sender: Any) {
        let selectionMenu = UIAlertController(title: "New item", message: nil, preferredStyle: .actionSheet)
        
        selectionMenu.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (_) in
            self.presentPhotoPicker()
        }))
        
        selectionMenu.addAction(UIAlertAction(title: "URL", style: .default, handler: { (_) in
            self.presentURLAdder(completion: { (url) in
                if let url = url {
                    let item = SharedItem(type: .url, title: "Some URL", thumbnail: nil, url: url)
                    self.fileManager.add(item, completion: { (success) in
                        if success {
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    })
                }
            })
        }))
        
        present(selectionMenu, animated: true)
    }
    
    private func presentPhotoPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func presentURLAdder(completion: @escaping (_ url: String?) -> Void) {
        let alert = UIAlertController(title: "Add url", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "URL"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            completion(alert.textFields?.first?.text)
        }))
        present(alert, animated: true)
    }
    
    private func didSelectImage(_ image: UIImage) {
        let item = SharedItem(type: .image, title: "Some image", thumbnail: image.pngData(), url: nil)
        fileManager.add(item) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
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

