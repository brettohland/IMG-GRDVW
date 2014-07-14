//
//  ASWImgCell.h
//  IMG Gridview
//
//  Created by brett ohland on 2014-07-11.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASWImgCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *selectedIndicator;
@property (strong, nonatomic) NSString *imageName;

@end
