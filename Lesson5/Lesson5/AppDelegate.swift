//
//  AppDelegate.swift
//  Lesson5
//
//  Created by fancymax on 1/13/2017.
//  Copyright © 2017年 fancy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var view: FLOpenGLView!
    
    fileprivate var timer: Timer!
    fileprivate var scene: Scene!
    
    fileprivate var ticks: UInt64 = AppDelegate.getTicks()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Do some GL setup.
        glEnable(GLenum(GL_DEPTH_TEST))
        
        scene = Scene()
        
        // Create a timer to render.
        timer = Timer(timeInterval: 1.0 / 60.0,
                      target: self,
                      selector: #selector(AppDelegate.timerFireMethod(_:)),
                      userInfo: nil,
                      repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func timerFireMethod(_ sender: Timer!) {
        // Render the scene.
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        scene.render(view.projectionMatrix)
        glFlush()
        view.flush()
        
        // Cycle the scene.
        let newTicks = AppDelegate.getTicks()
        let secondsElapsed = Float(newTicks - ticks) / 1000.0
        ticks = newTicks
        scene.cycle(secondsElapsed)
    }
    
    fileprivate class func getTicks() -> UInt64 {
        var t = timeval()
        gettimeofday(&t, nil)
        return UInt64(t.tv_sec * 1000) + UInt64(t.tv_usec / 1000)
    }


}

