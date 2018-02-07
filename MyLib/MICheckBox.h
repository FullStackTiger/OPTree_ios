//
//  MICheckBox.h
//  O&P Tree
//
//  Created by Doronin on 28/1/2018.
//  Copyright © 2018 Mobile Developer. All rights reserved.
//

#ifndef MICheckBox_h
#define MICheckBox_h

#import <UIKit/UIKit.h>

@interface MICheckBox : UIButton {
    BOOL isChecked;
}
@property (nonatomic,assign) BOOL isChecked;
-(IBAction) checkBoxClicked;

@end

#endif /* MICheckBox_h */
