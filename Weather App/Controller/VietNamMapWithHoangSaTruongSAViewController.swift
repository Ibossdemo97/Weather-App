//
//  VietNamMapWithHoangSaTruongSAViewController.swift
//  Weather App
//
//  Created by Luyện Hà Luyện on 11/07/2023.
//

import UIKit

class VietNamMapWithHoangSaTruongSAViewController: UIViewController, UIScrollViewDelegate {

    let scrollView = UIScrollView()
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the scroll view
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // Set up the image view
        imageView.frame = scrollView.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "VietNamMap") // Replace with your desired image
        
        // Add the image view to the scroll view
        scrollView.addSubview(imageView)
        
        // Add the scroll view to the view controller's view
        view.addSubview(scrollView)
        
        // Set the initial zoom scale and content offset
        scrollView.zoomScale = 1.0
        scrollView.contentSize = imageView.bounds.size
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // Update the content inset to center the image view when zoomed out
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
}
