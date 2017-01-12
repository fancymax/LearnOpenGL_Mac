//
//  Scene.swift
//  Lesson3
//
//  Created by fancymax on 1/12/2017.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Foundation
import GLKit

class Scene {
    fileprivate var program: ShaderProgram
    var texture1: Texture?
    var texture2: Texture?
    fileprivate var VAO: GLuint = 0
    fileprivate var rotation: Float = 0.01
    fileprivate var transformLocation: GLint
    
    init() {
        program = ShaderProgram()
        program.attachShader("tutorial.vs", withType: GL_VERTEX_SHADER)
        program.attachShader("tutorial.fs", withType: GL_FRAGMENT_SHADER)
        program.link()
        
        texture1 = Texture.loadFromFile("texture1.png")
        texture2 = Texture.loadFromFile("texture2.png")
        
        transformLocation = program.getUniformLocation("transform")!
        
        self.buildRenderObject()
    }
    
    func buildRenderObject()  {
        glGenVertexArrays(1, &VAO)
        
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
    }
    
    func render()  {
        program.use()
        
        glActiveTexture(GLenum(GL_TEXTURE0))
        glBindTexture(GLenum(GL_TEXTURE_2D), texture1!.textureId)
        glUniform1i(program.getUniformLocation("ourTexture1")!, 0)
        
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), texture2!.textureId)
        glUniform1i(program.getUniformLocation("ourTexture2")!, 1)
        
        let angle = rotation *  M_PI_F
        let transform = Matrix4.rotationMatrix(angle: angle, x: 0, y: 0, z: 1)
        glUniformMatrix4fv(transformLocation, GLsizei(1), GLboolean(GL_FALSE), UnsafePointer<GLfloat>(transform.matrix))
        
        glBindVertexArray(VAO)
        glDrawElements(GLenum(GL_TRIANGLES), 6, GLenum(GL_UNSIGNED_INT), nil)
        glBindVertexArray(0)
        
        // Disable the program.
        glUseProgram(0)
    }
    
    func cycle(_ secondsElapsed: Float) {
        rotation += 0.001 *  M_PI_F
    }
    
    deinit {
        glDeleteBuffers(1, &VAO)
    }
}
