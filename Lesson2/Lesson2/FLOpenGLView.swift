//
//  FLOpenGLView.swift
//  CocoaOpenGl
//
//  Created by fancymax on 12/22/2016.
//  Copyright © 2016年 fancy. All rights reserved.
//

import Cocoa


class FLOpenGLView: NSOpenGLView {
    
    var normalmap: Texture?
    
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
        defer {
            glDeleteBuffers(1, &VAO)
        }
        
        var VBO:GLuint =  0
        glGenBuffers(1, &VBO)
        defer {
            glDeleteBuffers(1, &VBO)
        }
        
        var EBO:GLuint = 0
        glGenBuffers(1, &EBO)
        defer {
            glDeleteBuffers(1, &EBO)
        }
        
        let vertices:[GLfloat] = [
            // Positions       // Colors        // Texture Coords
            0.5,  0.5, 0.0,   1.0, 0.0, 0.0,   1.0, 1.0, // Top Right
            0.5, -0.5, 0.0,   0.0, 1.0, 0.0,   1.0, 0.0, // Bottom Right
            -0.5, -0.5, 0.0,   0.0, 0.0, 1.0,   0.0, 0.0, // Bottom Left
            -0.5,  0.5, 0.0,   1.0, 1.0, 0.0,   0.0, 1.0  // Top Left
        ]
        
        let indices:[GLuint] = [  // Note that we start from 0!
            0, 1, 3,  // First Triangle
            1, 2, 3   // Second Triangle
        ]
        
        glBindVertexArray(VAO)
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
            glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * vertices.count ,vertices, GLenum(GL_STATIC_DRAW))
            
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO)
            glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), MemoryLayout<GLuint>.size * indices.count, indices, GLenum(GL_STATIC_DRAW))
            
            glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 8), nil)
            glEnableVertexAttribArray(0)
            
            let point2offset = UnsafeRawPointer(bitPattern: MemoryLayout<GLfloat>.size * 6)
            glVertexAttribPointer(2, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 8), point2offset)
            glEnableVertexAttribArray(2)
        glBindVertexArray(0)
        
        let glProgram = ShaderProgram()
        glProgram.attachShader("tutorial.vs", withType: GL_VERTEX_SHADER)
        glProgram.attachShader("tutorial.fs", withType: GL_FRAGMENT_SHADER)
        glProgram.link()
        glProgram.use()
        
        normalmap = Texture.loadFromFile("image.png")
        glBindVertexArray(VAO)
        glDrawElements(GLenum(GL_TRIANGLES), 6, GLenum(GL_UNSIGNED_INT), nil)
        glBindVertexArray(0)
    }
    
}
