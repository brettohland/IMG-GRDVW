//
//  ASWImgCell.m
//  IMG Gridview
//
//  Created by brett ohland on 2014-07-11.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

#import "ASWImgCell.h"

@implementation ASWImgCell

-(void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        _imageName = imageName;
    }
    [self addImageToView];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)didTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    [self addImageToView];
}

-(void) addImageToView {
    // Figures out the size of image and adds it to the view.
    // Can be 100, 155 or 320
    CGFloat currentSize = self.contentView.frame.size.height;
    NSString *finalImageName = [NSString stringWithFormat:@"%@.%d", self.imageName, (int) roundf(currentSize)];
    NSString *finalImagePath = [[NSBundle mainBundle] pathForResource:finalImageName ofType:@"jpg"];

    self.imgView.image = [UIImage imageWithContentsOfFile:finalImagePath];
}

@end
