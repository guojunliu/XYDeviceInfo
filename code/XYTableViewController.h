//
//  XYTableViewController.h
//  XYDeviceInfo
//
//  Created by steve on 2020/7/23.
//

#import <UIKit/UIKit.h>


@interface XYTableViewController : UIViewController

@end

@interface XYTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setCheckShow:(BOOL)b;

- (void)setCheck:(BOOL)b;

@end

