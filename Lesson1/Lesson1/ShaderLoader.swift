//
//  ShaderLoader.swift
//  CocoaOpenGl
//
//  Created by fancymax on 12/22/2016.
//  Copyright © 2016年 fancy. All rights reserved.
//

import Cocoa
import OpenGL
import GLKit

class ShaderLoader: NSObject {
    static let sharedInstance = ShaderLoader()
    
    private override init() { }
    
    func programWithVertexShader(_ vertexShaderFilePath:String,fragmentShader fragmentShaderFilePath:String) -> GLuint {
        let vsPath = Bundle.main.resourcePath! + "/" + vertexShaderFilePath
        let fsPath = Bundle.main.resourcePath! + "/" + fragmentShaderFilePath
        
        let vsContent = try? String(contentsOfFile: vsPath, encoding: String.Encoding.utf8)
        let fsContent = try? String(contentsOfFile: fsPath, encoding: String.Encoding.utf8)
        
        return programWithVertexShader(vsContent: vsContent!, fragmentShaderContent: fsContent!)
    }
    
    func programWithVertexShader(vsContent:String,fragmentShaderContent:String) -> GLuint {
        let vertexShader = glCreateShader(GLenum(GL_VERTEX_SHADER))
        let fragmentShader = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        
        let cVsSource = vsContent.cString(using: String.Encoding.ascii)
        var glcVsSource = UnsafePointer<GLchar>? (cVsSource!)
        
        glShaderSource(vertexShader, 1, &glcVsSource, nil)
        glCompileShader(vertexShader)
        //todo 检查编译结果
        
        let cFsSource = fragmentShaderContent.cString(using: String.Encoding.ascii)
        var glcFsSource = UnsafePointer<GLchar>? (cFsSource!)
        
        glShaderSource(fragmentShader, 1, &glcFsSource, nil)
        glCompileShader(fragmentShader)
        //todo 检查编译结果
        
        let program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        glLinkProgram(program)
        
        glDeleteShader(vertexShader)
        glDeleteShader(fragmentShader)
        
        return program
    }
}
