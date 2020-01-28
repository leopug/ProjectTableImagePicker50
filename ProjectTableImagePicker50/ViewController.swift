//
//  ViewController.swift
//  ProjectTableImagePicker50
//
//  Created by Ana Caroline de Souza on 27/01/20.
//  Copyright © 2020 Ana e Leo Corp. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // TODO: split data source into another swift files
    // TODO: Use UIViewController with a tableView as a sub view
    
    var photos = [Photo]()
    var actualPhoto : Photo!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(addNewPhoto))
        
        let defaults = UserDefaults.standard
        if let savedPhotos = defaults.object(forKey: "Photos") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                photos = try jsonDecoder.decode([Photo].self, from: savedPhotos)
            } catch {
                print("errrroooorr")
            }
        }
    }

    @objc func addNewPhoto() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        actualPhoto = Photo(name: "unknow", image: imageName, path: imagePath.path)
        
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Action Required", message: "Name your photo", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "ok", style: .default) {
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            self?.actualPhoto.name = newName
            guard let photo = self?.actualPhoto else { return }
            self?.photos.append(photo)
            self?.save()
            self?.tableView.reloadData()
        })

        present(ac, animated: true)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)
        cell.textLabel?.text = photos[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.photo = photos[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "Photos")
        } else {
            print("We failed to save the array")
        }
    }
    
    
}

