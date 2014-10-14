//
//  String+MD5.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/5/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import Foundation

extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
            let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            let digestLen = Int(CC_MD5_DIGEST_LENGTH)
            let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
            
            CC_MD5(str!, strLen, result)
            
            var hash = NSMutableString()
            for i in 0..<digestLen {
                hash.appendFormat("%02x", result[i])
            }
            
            result.destroy()
            
            return String(format: hash)
    }
}