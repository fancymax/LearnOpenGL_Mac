//
//  FLOpenGLView.swift
//  CocoaOpenGl
//
//  Created by fancymax on 12/22/2016.
//  Copyright © 2016年 fancy. All rights reserved.
//

import Cocoa


class FLOpenGLView: NSOpenGLView {
    
    var projectionMatrix = Matrix4()
    
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
        
        let aspectRatio = Float(frame.size.width) / Float(frame.size.height)
        projectionMatrix = Matrix4.perspectiveMatrix(fov: M_PI_F / 4.0, aspect: aspectRatio, near: 0.1, far: 200.0)
    }
    
    func flush() {
        self.openGLContext?.flushBuffer()
    }
}
