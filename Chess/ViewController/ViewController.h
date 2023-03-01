//
//  ViewController.h
//  Chess
//
//  Created by Japp Galang on 2/21/23.
//

#import <UIKit/UIKit.h>
#import "ViewModelController.h"

#import <UIKit/UIKit.h>

@class ViewModelController;

@interface ViewController : UIViewController

@property (strong, nonatomic) NSMutableArray* pieceGrid;
@property (strong, nonatomic) NSDictionary* displayCoordinateX;
@property (strong, nonatomic) NSDictionary* displayCoordinateY;
@property (strong, nonatomic) ViewModelController *viewModelController;



@end

