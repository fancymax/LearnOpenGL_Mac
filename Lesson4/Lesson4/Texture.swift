//
//  Texture.swift
//  CocoaOpenGl
//
//  Created by fancymax on 12/29/2016.
//  Copyright © 2016年 fancy. All rights reserved.
//

import Foundation
import GLKit

class Texture {
    fileprivate(set) var textureId:GLuint
    fileprivate(set) var width:UInt
    fileprivate(set) var height:UInt
    
    init(textureId:GLuint, width:UInt, height:UInt) {
        self.textureId = textureId
        self.width = width
        self.height = height
    }
    
    deinit {
        glDeleteTextures(1, &textureId)
    }
    
    static func loadFromFile(_ filePath:String) -> Texture? {
        let fullPath = Bundle.main.resourcePath! + "/" + filePath
        let dataProvider = CGDataProvider(filename: fullPath)
        
        if dataProvider == nil {
            return nil
        }
        
        let image = CGImage(pngDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        let imageData = image?.dataProvider?.data
        
        let data = CFDataGetBytePtr(imageData)
        let width = UInt((image?.width)!)
        let height = UInt((image?.height)!)
        let numComponents = (image?.bitsPerPixel)! / 8
        
        var format:GLint
        switch numComponents {
        case 1:
            format = GL_RED
        case 3:
            format = GL_RGB
        case 4:
            format = GL_RGBA
        default:
            return nil
        }
        
        var textureId:GLuint = 0
        glGenTextures(1, &textureId)
        // Generate and bind texture.
        print(textureId)
        
        glBindTexture(GLenum(GL_TEXTURE_2D), textureId)

        // Set parameters.
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_REPEAT)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_REPEAT)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)

        // Set the texture data.
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, format, GLsizei(width), GLsizei(height), 0, GLenum(format), GLenum(GL_UNSIGNED_BYTE), data)
        
        glGenerateMipmap(GLenum(GL_TEXTURE_2D))
        
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        
        return Texture(textureId: textureId, width: width, height: height)
    }
}
