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
        
        let cubeVertices:[GLfloat] = [
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
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * cubeVertices.count ,cubeVertices, GLenum(GL_STATIC_DRAW))
        
        glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 5), nil)
        glEnableVertexAttribArray(0)
        
        let point2offset = UnsafeRawPointer(bitPattern: MemoryLayout<GLfloat>.size * 3)
        glVertexAttribPointer(2, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<GLfloat>.size * 5), point2offset)
        glEnableVertexAttribArray(2)
        glBindVertexArray(0)
    }
    
    func render(_ projection:UnsafeMutablePointer<Float>)  {
        program.use()
        
        glActiveTexture(GLenum(GL_TEXTURE0))
        glBindTexture(GLenum(GL_TEXTURE_2D), texture1!.textureId)
        glUniform1i(program.getUniformLocation("ourTexture1")!, 0)
        
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), texture2!.textureId)
        glUniform1i(program.getUniformLocation("ourTexture2")!, 1)
        
        //view
        var cameraPosition:[Float] = [0,0.0,4]
        var cameraTarget:[Float] = [0,0.0,0.0]
        var cameraUp:[Float] = [0.0,1.0,0.0]
        let view = FLglmWrapper.look(atPosition:&cameraPosition, target: &cameraTarget, upVector: &cameraUp)
        glUniformMatrix4fv(viewLocation, GLsizei(1), GLboolean(GL_FALSE), view)
        //need to free pointers from C
        //free(view)
        //https://sketchytech.blogspot.com/2014/09/unsafe-pointers-in-swift-how-to-build.html
        FLglmWrapper.freeMatrix(view)
        
        //projection
        glUniformMatrix4fv(projectionLocation, GLsizei(1), GLboolean(GL_FALSE), UnsafePointer<GLfloat>(projection))
        
        let cubePositions:[[Float]] = [
            [0.0,0.0,0.0],
            [2.0,2.0,-3.0],
            [-2.0,-2.0,-2.3],
        ]
        
        //model
        glBindVertexArray(VAO)
        for i in 0...cubePositions.count - 1 {
            var model = FLglmWrapper.translateAt(x: cubePositions[i][0], y: cubePositions[i][1], z: cubePositions[i][2])
            model = FLglmWrapper.rotate(from: model, angle: rotation, x: 1, y: 0, z: 1)
            glUniformMatrix4fv(modelLocation, GLsizei(1), GLboolean(GL_FALSE), model)
            FLglmWrapper.freeMatrix(model)
            glDrawArrays(GLenum(GL_TRIANGLES), 0, 36)
        }
        glBindVertexArray(0)
        
        glUseProgram(0)
    }
    
    func cycle(_ secondsElapsed: Float) {
        rotation += 0.01
    }
    
    deinit {
        glDeleteBuffers(1, &VAO)
    }
}
