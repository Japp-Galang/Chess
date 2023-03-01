//
//  ModelViewController.h
//  Chess
//
//  Created by Japp Galang on 2/27/23.
//
#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;

@interface ViewModelController : NSObject

- (instancetype)initWithViewSize:(CGSize)size viewController:(ViewController*)viewController;

- (UIView*)createBoard;
- (NSMutableArray*)prefillBoardPieces:(NSMutableArray*)pieceGrid;
- (UIView*)addChessIconToSquare:(NSString*)imageName file:(NSString*)file rank:(NSString*)rank pieceIdentifier:(NSInteger)pieceIdentifier;
- (UIView*)checkGridToDisplayPiecesWithpieceGrid:(NSMutableArray*)pieceGrid;

- (void)clearAvailableMoves;

@end
