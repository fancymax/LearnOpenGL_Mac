//
//  Scene.swift
//  Lesson3
//
//  Created by fancymax on 1/12/2017.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Foundation
import GLKit

let M_PI_F = Float(M_PI)

class Scene {
    fileprivate var program: ShaderProgram
    var texture1: Texture?
    var texture2: Texture?
    fileprivate var VAO: GLuint = 0
    fileprivate var rotation: Float = 0.01
    fileprivate var modelLocation: GLint
    fileprivate var viewLocation: GLint
    fileprivate var projectionLocation: GLint
    
    init() {
        program = ShaderProgram()
        program.attachShader("tutorial.vs", withType: GL_VERTEX_SHADER)
        program.attachShader("tutorial.fs", withType: GL_FRAGMENT_SHADER)
        program.link()
        
        texture1 = Texture.loadFromFile("texture1.png")
        texture2 = Texture.loadFromFile("texture2.png")
        
        modelLocation = program.getUniformLocation("model")!
        viewLocation = program.getUniformLocation("view")!
        projectionLocation = program.getUniformLocation("projection")!
        
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
            -0.5, -0.5, -0.5,  0.0, 0.0,
            0.5, -0.5, -0.5,  1.0, 0.0,
            0.5,  0.5, -0.5,  1.0, 1.0,
            0.5,  0.5, -0.5,  1.0, 1.0,
            -0.5,  0.5, -0.5,  0.0, 1.0,
            -0.5, -0.5, -0.5,  0.0, 0.0,
            
            -0.5, -0.5,  0.5,  0.0, 0.0,
            0.5, -0.5,  0.5,  1.0, 0.0,
            0.5,  0.5,  0.5,  1.0, 1.0,
            0.5,  0.5,  0.5,  1.0, 1.0,
            -0.5,  0.5,  0.5,  0.0, 1.0,
            -0.5, -0.5,  0.5,  0.0, 0.0,
            
            -0.5,  0.5,  0.5,  1.0, 0.0,
            -0.5,  0.5, -0.5,  1.0, 1.0,
            -0.5, -0.5, -0.5,  0.0, 1.0,
            -0.5, -0.5, -0.5,  0.0, 1.0,
            -0.5, -0.5,  0.5,  0.0, 0.0,
            -0.5,  0.5,  0.5,  1.0, 0.0,
            
            0.5,  0.5,  0.5,  1.0, 0.0,
            0.5,  0.5, -0.5,  1.0, 1.0,
            0.5, -0.5, -0.5,  0.0, 1.0,
            0.5, -0.5, -0.5,  0.0, 1.0,
            0.5, -0.5,  0.5,  0.0, 0.0,
            0.5,  0.5,  0.5,  1.0, 0.0,
            
            -0.5, -0.5, -0.5,  0.0, 1.0,
            0.5, -0.5, -0.5,  1.0, 1.0,
            0.5, -0.5,  0.5,  1.0, 0.0,
            0.5, -0.5,  0.5,  1.0, 0.0,
            -0.5, -0.5,  0.5,  0.0, 0.0,
            -0.5, -0.5, -0.5,  0.0, 1.0,
            
            -0.5,  0.5, -0.5,  0.0, 1.0,
            0.5,  0.5, -0.5,  1.0, 1.0,
            0.5,  0.5,  0.5,  1.0, 0.0,
            0.5,  0.5,  0.5,  1.0, 0.0,
            -0.5,  0.5,  0.5,  0.0, 0.0,
            -0.5,  0.5, -0.5,  0.0, 1.0
        ]
        
        glBindVertexArray(VAO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * vertices.count ,vertices, GLenum(GL_STATIC_DRAW))
        
        glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 5), nil)
        glEnableVertexAttribArray(0)
        
        let point2offset = UnsafeRawPointer(bitPattern: MemoryLayout<GLfloat>.size * 3)
        glVertexAttribPointer(2, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 5), point2offset)
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
        let model = Matrix4.rotationMatrix(angle: angle, x: 1, y: 0, z: 0) * Matrix4.rotationMatrix(angle: angle, x: 0, y: 0, z: 1) * Matrix4.rotationMatrix(angle: angle, x: 0, y: 1, z: 0)
        glUniformMatrix4fv(modelLocation, GLsizei(1), GLboolean(GL_FALSE), UnsafePointer<GLfloat>(model.matrix))
        
        let view = Matrix4.translationMatrix(x: 0, y: 0, z: -4)
        glUniformMatrix4fv(viewLocation, GLsizei(1), GLboolean(GL_FALSE), UnsafePointer<GLfloat>(view.matrix))

        let projection = Matrix4.perspectiveMatrix(fov: 45, aspect: 480/360, near: 0.1, far: 100)
        glUniformMatrix4fv(projectionLocation, GLsizei(1), GLboolean(GL_FALSE), UnsafePointer<GLfloat>(projection.matrix))
        
        glBindVertexArray(VAO)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)
        glBindVertexArray(0)
        
        // Disable the program.
        glUseProgram(0)
    }
    
    func cycle(_ secondsElapsed: Float) {
        rotation += 0.0005 *  M_PI_F
    }
    
    deinit {
        glDeleteBuffers(1, &VAO)
    }
}
