//
//  ASWGridViewController.m
//  IMG Gridview
//
//  Created by brett ohland on 2014-07-11.
//  Copyright (c) 2014 ampersandsoftworks. All rights reserved.
//

#import "ASWGridViewController.h"
#import "ASWImgCell.h"

@interface ASWGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@property (assign, nonatomic) CGFloat scale;
@property (strong, nonatomic) NSIndexPath *previouslySelectedIndexPath;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ASWGridViewController {
    NSBundle *mainBundle;
}

static NSString *CellIdentifier = @"ImgCell";

const CGFloat kScaleLowerBound = 2.0;
const CGFloat kScaleUpperBound = 5.0;
const NSInteger kCellMargin = 10;
const float kAnimationDuration = 0.25;

#pragma mark - Overrides

-(void)setScale:(CGFloat)scale {
    
    if (scale < kScaleLowerBound) {
        _scale = kScaleLowerBound;
    } else if (scale > kScaleUpperBound) {
        _scale = kScaleUpperBound;
    } else {
        _scale = scale;
    }
    
}

#pragma mark - UIView Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainBundle = [NSBundle mainBundle];
    
    self.scale = kScaleLowerBound;
    
    // Horrible, dirty data source
    self.dataSource = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20, @21, @22, @23, @24, @25]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASWImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSNumber *cellData = self.dataSource[indexPath.row];
    
    // Adding the image to the UIImageView is handeled in the cell.
    cell.imageName = [NSString stringWithFormat:@"img%@", [cellData stringValue]];
    cell.selectedIndicator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    cell.selectedIndicator.alpha = 0;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ASWImgCell *selectedCell = (ASWImgCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.previouslySelectedIndexPath) {
        // One has already been selected
        ASWImgCell *previouslySelectedCell = (ASWImgCell*)[self.collectionView cellForItemAtIndexPath:self.previouslySelectedIndexPath];
        
        [self animateToggleSelectedIndicatorOfCell:previouslySelectedCell];
        
        [self.collectionView performBatchUpdates:^{
            // Swap data source as well as visually
            [self.dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:self.previouslySelectedIndexPath.row];
            [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:self.previouslySelectedIndexPath];
            [self.collectionView moveItemAtIndexPath:self.previouslySelectedIndexPath toIndexPath:indexPath];
        } completion:nil];
        
        self.previouslySelectedIndexPath = nil;
        
    } else {
        // Hasn't been selected yet, set it
        self.previouslySelectedIndexPath = indexPath;
        [self animateToggleSelectedIndicatorOfCell:selectedCell];
    }
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    // Use the scale property to position everything as needed
    CGFloat scaledWidth = 50 * self.scale;
    NSInteger columns = floor(320 / scaledWidth);
    CGFloat totalSpacing = kCellMargin * (columns - 1);
    CGFloat finalWidth = (320 - totalSpacing) / columns;
    
    return CGSizeMake(finalWidth, finalWidth);
}

#pragma mark - Gesture

- (IBAction)didReceivePinchGesture:(UIPinchGestureRecognizer *)sender {
    
    static CGFloat initialScale;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialScale = self.scale;
        return;
    }
    
    if(sender.state == UIGestureRecognizerStateChanged) {
   
        self.scale = initialScale * sender.scale;
        [self.collectionView removeGestureRecognizer:self.pinchGestureRecognizer]; //Remove before animation to stop glitches
        UICollectionViewFlowLayout *updatedLayout = [[UICollectionViewFlowLayout alloc] init];
        updatedLayout.sectionInset = UIEdgeInsetsMake(40, 0, 0, 0);
        
        __weak typeof(self) weakSelf = self; // Weakself dance, avoid those retention cycles.
        [self.collectionView setCollectionViewLayout:updatedLayout animated:YES completion:^(BOOL finished) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf.collectionView addGestureRecognizer:strongSelf.pinchGestureRecognizer];
        }];
    }
}

#pragma mark - Utilities

-(void) animateToggleSelectedIndicatorOfCell:(ASWImgCell *)cell {
    [UIView animateWithDuration:kAnimationDuration animations:^{
       cell.selectedIndicator.alpha = (cell.selectedIndicator.alpha > 0) ? 0 : 1;
    }];
};

-(IBAction)formSheetWindowDoneButtonPressed:(UIStoryboardSegue *)sender {
    // Called after the modal disappears
    [self.collectionView reloadData];
}

@end
