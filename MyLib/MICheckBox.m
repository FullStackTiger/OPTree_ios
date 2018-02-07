//
//  MICheckBox.m
//  O&P Tree
//
//  Created by Doronin on 28/1/2018.
//  Copyright © 2018 Mobile Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MICheckBox.h"

@implementation MICheckBox;
@synthesize isChecked;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        
        self.contentHorizontalAlignment =
        UIControlContentHorizontalAlignmentLeft;
        
        [self checkBoxClicked];
        
        [self addTarget:self action:
         @selector(checkBoxClicked)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(IBAction) checkBoxClicked{
    if(self.isChecked ==NO){
        self.isChecked =YES;
        [self setImage:[UIImage imageNamed: @"savechek"]
              forState:UIControlStateNormal];
        
    }else{
        self.isChecked =NO;
        [self setImage:[UIImage imageNamed:
                        @"emptycheck"]
              forState:UIControlStateNormal];
        
    }
}

@end
