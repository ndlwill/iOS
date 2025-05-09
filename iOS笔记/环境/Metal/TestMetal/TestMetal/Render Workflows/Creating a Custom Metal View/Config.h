//
//  Config.h
//  TestMetal
//
//  Created by youdun on 2023/9/21.
//


// MARK: - Configure the Sample Code Project
/**
 This sample provides a number of options you can enable when building the app, such as whether to animate the view’s contents or handle updates through system events. You control these options by changing the preprocessor definitions in the AAPLConfig.h file.
 */

/**
 When enabled, rendering occurs on the main application thread.
 This can make responding to UI events during redraw simpler to manage because UI calls usually must occur on the main thread.
 When disabled, rendering occurs on a background thread, allowing the UI to respond more quickly in some cases because events can be processed asynchronously from potentially CPU-intensive rendering code.
 */
#define RENDER_ON_MAIN_THREAD 1

/**
 When enabled, the view continually animates and renders frames 60 times a second.
 When disabled, rendering is event based, occurring when a UI event requests a redraw.
 */
#define ANIMATION_RENDERING   1

/**
 When enabled, the drawable's size is updated automatically whenever the view is resized.
 When disabled, you can update the drawable's size explicitly outside the view class.
 */
#define AUTOMATICALLY_RESIZE  1

/**
 When enabled, the renderer creates a depth target (i.e. depth buffer) and attaches with the render pass descritpr along with the drawable texture for rendering.
 This enables the app properly perform depth testing.
 */
#define CREATE_DEPTH_BUFFER   1
