//
//  ClassifyingImagesWithVision_CoreMLViewController.swift
//  TestAR
//
//  Created by youdun on 2025/1/7.
//

import UIKit
import PhotosUI

// MARK: - Classifying Images with Vision and Core ML
/**
 Crop and scale photos using the Vision framework and classify them with a Core ML model.
 
 Each time a user selects a photo from the library or takes a photo with a camera, the app passes it to a Vision image classification request.
 Vision resizes and crops the photo to meet the MobileNet model’s constraints for its image input, and then passes the photo to the model using the Core ML framework behind the scenes.
 Once the model generates a prediction, Vision relays it back to the app, which presents the results to the user.
 
 Core ML model gallery:
 https://developer.apple.com/machine-learning/models/
 
 Before you integrate a third-party model to solve a problem — which may increase the size of your app — consider using an API in the SDK.
 For example, the Vision framework’s VNClassifyImageRequest class offers the same functionality as MobileNet, but with potentially better performance and without increasing the size of your app (see Classifying images for categorization and search).
 
 Note:
 You can make a custom image classifier that identifies your choice of object types with Create ML.
 See Creating an Image Classifier Model to learn how to create a custom image classifier that can replace the MobileNet model in this sample.
 
 Creating an Image Classifier Model:
 https://developer.apple.com/documentation/createml/creating-an-image-classifier-model
 
 Create ML:
 https://developer.apple.com/documentation/createml
 
 
 Core ML:
 Integrate machine learning models into your app.
 Use Core ML to integrate machine learning models into your app.
 Core ML provides a unified representation for all models.
 Your app uses Core ML APIs and user data to make predictions, and to train or fine-tune models, all on a person’s device.
 
 
 The sample targets iOS 14 or later, but the MobileNet model in the project works with:
 iOS 11 or later
 
 Note:
 Add your own photos to the photo library in Simulator by dragging photos onto its window.
 */
class ClassifyingImagesWithVision_CoreMLViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var promptStackView: UIStackView!
    
    var firstRun = true
    
    // A predictor instance that uses Vision and Core ML to generate prediction strings from a photo.
    let imagePredictor = ImagePredictor()
    
    // The largest number of predictions the view controller displays the user.
    let predictionsToShow = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @available(iOS 14, *)
    @IBAction func singleTap(_ sender: UITapGestureRecognizer) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            present(photoPicker, animated: false)
            return
        }
        
        present(cameraPicker, animated: false)
    }
    
    @available(iOS 14, *)
    @IBAction func doubleTap(_ sender: UITapGestureRecognizer) {
        present(photoPicker, animated: false)
    }
    
    func userSelectedPhoto(_ photo: UIImage) {
        print(#function, "Thread.current = \(Thread.current)")
        
        updateImage(photo)
        updatePredictionLabel("Making predictions for the photo...")

        /**
         Important:
         Keep your app’s UI responsive by making predictions with Core ML models off of the main thread.
         */
        DispatchQueue.global(qos: .userInitiated).async {
            self.classifyImage(photo)
        }
    }
    
    func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func updatePredictionLabel(_ message: String) {
        DispatchQueue.main.async {
            self.predictionLabel.text = message
        }

        if firstRun {
            DispatchQueue.main.async {
                self.firstRun = false
                self.predictionLabel.superview?.isHidden = false
                self.promptStackView.isHidden = true
            }
        }
    }
    
    // Sends a photo to the Image Predictor to get a prediction of its content.
    private func classifyImage(_ image: UIImage) {
        do {
            try self.imagePredictor.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }
    
    /**
     The method the Image Predictor calls when its image classifier model generates a prediction.
     */
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        print(#function, "Thread.current = \(Thread.current)")
        
        guard let imagePredictions = predictions else {
            updatePredictionLabel("No predictions. (Check console log.)")
            return
        }
        
        let formattedPredictions = formatPredictions(imagePredictions)
        let predictionString = formattedPredictions.joined(separator: "\n")
        updatePredictionLabel(predictionString)
    }
    
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification
            // For classifications with more than one name, keep the one before the first comma.
            if let firstCommaIndex = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstCommaIndex))
            }
            
            return "\(name) - \(prediction.confidencePercentage)%"
        }
        
        return topPredictions
    }
    
}


// MARK: - CameraPicker
extension ClassifyingImagesWithVision_CoreMLViewController: UIImagePickerControllerDelegate,
                                                            UINavigationControllerDelegate {
    var cameraPicker: UIImagePickerController {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        return cameraPicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false)
        
        // Always return the original image.
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] else {
            fatalError("Picker didn't have an original image.")
        }
        
        guard let photo = originalImage as? UIImage else {
            fatalError("The (Camera) Image Picker's image isn't a/n \(UIImage.self) instance.")
        }
        
        userSelectedPhoto(photo)
    }
    
}

// MARK: - PhotoPicker
@available(iOS 14, *)
extension ClassifyingImagesWithVision_CoreMLViewController: PHPickerViewControllerDelegate {
    
    var photoPicker: PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images

        let photoPicker = PHPickerViewController(configuration: config)
        photoPicker.delegate = self

        return photoPicker
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false)
        
        guard let result = results.first else {
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            print(#function, "Thread.current = \(Thread.current)")
            
            if let err = error {
                print("Photo picker error: \(err)")
                return
            }

            guard let photo = object as? UIImage else {
                fatalError("The Photo Picker's image isn't a/n \(UIImage.self) instance.")
            }

            self.userSelectedPhoto(photo)
        }
    }
    
}
