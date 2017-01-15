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
    
    func render(_ projection:Matrix4)  {
        program.use()
        
        glActiveTexture(GLenum(GL_TEXTURE0))
        glBindTexture(GLenum(GL_TEXTURE_2D), texture1!.textureId)
        glUniform1i(program.getUniformLocation("ourTexture1")!, 0)
        
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), texture2!.textureId)
        glUniform1i(program.getUniformLocation("ourTexture2")!, 1)
        
        var cameraPosition:[Float] = [0.0,0.0,8.0]
        var cameraTarget:[Float] = [0.0,0.0,0.0]
        var cameraUp:[Float] = [0.0,1.0,0.0]
        let view = FLglmWrapper.look(at:&cameraPosition, target: &cameraTarget, upVector: &cameraUp)
        glUniformMatrix4fv(viewLocation, GLsizei(1), GLboolean(GL_FALSE), view)
        
        glUniformMatrix4fv(projectionLocation, GLsizei(1), GLboolean(GL_FALSE), UnsafePointer<GLfloat>(projection.matrix))
        
        let cubePositions:[[Float]] = [
            [0.0,0.0,0.0],
            [2.0,5.0,-15.0],
            [-3.8,-2.0,-12.3],
            [2.4,-0.4,-3.5],
            [-1.7,3.0,-7.5],
            [1.3,-2.0,-2.5],
            [1.5,2.0,-2.5],
            [-1.3,1.0,-1.5]
        ]
        glBindVertexArray(VAO)
        for i in 0...cubePositions.count - 1 {
            let angle = rotation *  M_PI_F + (Float)(i) * 0.1 * M_PI_F
            let model = Matrix4.translationMatrix(x: cubePositions[i][0], y:cubePositions[i][1] , z:cubePositions[i][2]) *  Matrix4.rotationMatrix(angle: angle, x: 0, y: 1, z: 0)
            glUniformMatrix4fv(modelLocation, GLsizei(1), GLboolean(GL_FALSE), UnsafePointer<GLfloat>(model.matrix))
            glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)
            
        }
        glBindVertexArray(0)
        
        glUseProgram(0)
    }
    
    func cycle(_ secondsElapsed: Float) {
        rotation += 0.0005 *  M_PI_F
    }
    
    deinit {
        glDeleteBuffers(1, &VAO)
    }
}
