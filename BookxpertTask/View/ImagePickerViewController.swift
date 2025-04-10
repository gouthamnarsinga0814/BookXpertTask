//
//  ImagePickerViewController.swift
//  BookxpertTask
//
//  Created by Alyx on 10/04/25.
//

import UIKit
import Photos
import AVFoundation

class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let imageView = UIImageView()
    let captureButton = UIButton(type: .system)
    let galleryButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Select Image"
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        captureButton.setTitle("📷 Capture Image", for: .normal)
        captureButton.setTitleColor(.black, for: .normal)
        galleryButton.setTitle("🖼️ Pick from Gallery", for: .normal)
        galleryButton.setTitleColor(.black, for: .normal)
        
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        galleryButton.addTarget(self, action: #selector(pickFromGallery), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [imageView, captureButton, galleryButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc private func captureImage() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.openImagePicker(sourceType: .camera)
                } else {
                    self.showPermissionAlert(for: "Camera")
                }
            }
        }
    }
    
    @objc private func pickFromGallery() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self.openImagePicker(sourceType: .photoLibrary)
                default:
                    self.showPermissionAlert(for: "Photo Library")
                }
            }
        }
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            print("Source type not available")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // MARK: - Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func showPermissionAlert(for feature: String) {
        let alert = UIAlertController(title: "\(feature) Access Denied", message: "Please enable access to \(feature.lowercased()) in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
