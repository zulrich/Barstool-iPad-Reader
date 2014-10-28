//
//  BlogCollectionViewCell.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 9/23/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit

class BlogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var blogByLabel: UILabel!
    @IBOutlet var blogHeadlineTextView: UITextView!
    @IBOutlet var blogThumbnailImageView: UIImageView!
    func setupCell(blogInfo:Blog)
    {
        self.blogHeadlineTextView.text = blogInfo.blogTitle
        self.blogByLabel.text = blogInfo.author
        
        
        var url = NSURL(string: blogInfo.thumbNail)
        
        var color:UIColor = BlogColors.getColor(blogInfo.blogId)
        
        self.backgroundColor = color
        self.blogHeadlineTextView.backgroundColor = color
        self.blogHeadlineTextView.textColor = UIColor.whiteColor()
        self.blogByLabel.textColor = UIColor.whiteColor()
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            var error:NSError?
            
            var imageData:NSData? = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingUncached, error:&error)
            
            dispatch_async(dispatch_get_main_queue(), {
            
                if(imageData != nil)
                {
                    self.blogThumbnailImageView.image = UIImage(data: imageData!)

                }
                
            })
            
        })
        
    }
    
    func colorCell(blog_id:NSNumber) -> String
    {
        
        return blogColors[blog_id.stringValue]!
        
        
    }
    
}
