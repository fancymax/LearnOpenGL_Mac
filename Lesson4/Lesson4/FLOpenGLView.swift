//
//  FLOpenGLView.swift
//  CocoaOpenGl
//
//  Created by fancymax on 12/22/2016.
//  Copyright © 2016年 fancy. All rights reserved.
//

import Cocoa


class FLOpenGLView: NSOpenGLView {
    
    var texture1: Texture?
    var texture2: Texture?
    
    override func awakeFromNib()
    {
        let attr = [
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAOpenGLProfile),
            NSOpenGLPixelFormatAttribute(NSOpenGLProfileVersion3_2Core),
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAColorSize), 24,
            NSOpenGLPixelFormatAttribute(NSOpenGLPFAAlphaSize), 8,
            NSOpenGLPixelFormatAttribute(NSOpenGLPFADoubleBuffer),
            NSOpenGLPixelFormatAttribute(NSOpenGLPFADepthSize), 32,
            0
        ]
        
        let format = NSOpenGLPixelFormat(attributes: attr)
        let context = NSOpenGLContext(format: format!, share: nil)
        
        self.openGLContext = context
        self.openGLContext?.makeCurrentContext()
    }

    override func reshape() {
        let frame = self.frame
        glViewport(0, 0, GLsizei(frame.width), GLsizei(frame.height))
    }
    
    func flush() {
        self.openGLContext?.flushBuffer()
    }
}
