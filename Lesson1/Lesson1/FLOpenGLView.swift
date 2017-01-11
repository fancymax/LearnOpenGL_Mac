//
//  FLOpenGLView.swift
//  CocoaOpenGl
//
//  Created by fancymax on 12/22/2016.
//  Copyright © 2016年 fancy. All rights reserved.
//

import Cocoa


class FLOpenGLView: NSOpenGLView {
    
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
    }
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        self.openGLContext?.makeCurrentContext()
        
        self.render()
        
        self.openGLContext?.flushBuffer()
    }
    
    
    override func prepareOpenGL() {
        super.prepareOpenGL()
        //设置定时器 定时刷新 就变成动画了
    }
    
    func render() {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        var VAO:GLuint = 0
        glGenVertexArrays(1, &VAO)
        
        var VBO:GLuint =  0
        glGenBuffers(1, &VBO)
        
        let vertices:[GLfloat] = [
            -0.5, -0.5, 0.0,
            0.5, -0.5, 0.0,
            0.0,  0.5, 0.0
        ]
        
        glBindVertexArray(VAO)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
            glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * vertices.count ,vertices, GLenum(GL_STATIC_DRAW))
            glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
            glEnableVertexAttribArray(0)
        glBindVertexArray(0)
        
        let glProgram = ShaderLoader.sharedInstance.programWithVertexShader("tutorial.vs", fragmentShader: "tutorial.fs")
        glUseProgram(glProgram)
        glBindVertexArray(VAO)
        
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        glBindVertexArray(0)
    }
    
}
