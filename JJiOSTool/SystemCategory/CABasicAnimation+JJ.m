//
//  CABasicAnimation+JJ.m
//  JJObjCTool
//
//  Created by gongjian03 on 9/30/15.
//  Copyright © 2015 gongjian. All rights reserved.
//

#import "CABasicAnimation+JJ.h"

@implementation CABasicAnimation (JJ)

- (void)jj_applyToLayer:(CALayer *)layer_
{
    /*
     我们需要从呈现图层那里去获得fromValue，而不是模型图层。另外，由于这里的图层并不是UIView关联的图层，我们需要用CATransaction来禁用隐式动画行为，否则默认的图层行为会干扰我们的显式动画（实际上，显式动画通常会覆盖隐式动画，但在文章中并没有提到，所以为了安全最好这么做）。
     */
    
    //set the from value (using presentation layer if available)
    self.fromValue = [layer_.presentationLayer ? layer_.presentationLayer : layer_ valueForKeyPath:self.keyPath];
    //update the property in advance
    //note: this approach will only work if toValue != nil
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer_ setValue:self.toValue forKeyPath:self.keyPath];
    [CATransaction commit];
    //apply animation to layer
    [layer_ addAnimation:self forKey:nil];
}

@end
