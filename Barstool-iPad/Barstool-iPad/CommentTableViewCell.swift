//
//  CommentTableViewCell.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/4/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var usernameLBL: UILabel!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var postDateLBL: UILabel!
    @IBOutlet var upLBL: UILabel!
    @IBOutlet var downLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(commentInfo:Comment)
    {
        self.usernameLBL.text = commentInfo.commenterName
        self.commentTextView.text = commentInfo.commentContent
        self.postDateLBL.text = commentInfo.commentDate
        self.upLBL.text = commentInfo.upCount.stringValue
        self.downLBL.text = commentInfo.downCount.stringValue
    }

}
