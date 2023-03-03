//
//  ModelViewController.m
//  Chess
//
//  Created by Japp Galang on 2/27/23.
//

#import <Foundation/Foundation.h>
#import "ViewModelController.h"
#import "ViewController.h"


@interface ViewModelController ()

@property (strong, nonatomic) ViewController* viewController;

@property (strong, nonatomic) NSMutableArray* pieceGrid;

@property (strong, nonatomic) NSDictionary* fileToComputerFile;
@property (strong, nonatomic) NSDictionary* displayCoordinateX;
@property (strong, nonatomic) NSDictionary* displayCoordinateY;

@property (nonatomic) CGFloat squareLength;
@property (nonatomic) CGSize viewSize;

@property (strong, nonatomic) NSMutableSet* availableMoves;
@property (strong, nonatomic) NSMutableSet* currentPiecesOnTheBoard;

@end


@implementation ViewModelController

- (instancetype)initWithViewSize:(CGSize)size viewController:(ViewController*)viewController
{
    self = [super init];
        if (self) {
            self.squareLength = size.width / 8;
            self.viewSize = size;
            self.fileToComputerFile = @{@"a": @0, @"b": @1, @"c": @2, @"d": @3, @"e": @4, @"f": @5, @"g": @6, @"h": @7};
            CGSize imageSize = [UIImage imageNamed:@"BlackKing"].size;
            
            // fill dictionary of coordinates X (file)
            self.displayCoordinateX = [NSMutableDictionary dictionary];
            NSInteger fileNumber = 0;
            for(char file = 'a'; file <= 'h'; file++){
                CGFloat coordinatesXTopLeftOfSquare = fileNumber * self.squareLength;
                CGFloat coordinateX = coordinatesXTopLeftOfSquare - imageSize.width / 44 + self.squareLength / 2;
                [self.displayCoordinateX setValue: [NSNumber numberWithFloat:coordinateX] forKey:[NSString stringWithFormat:@"%c", file]];
                fileNumber = fileNumber + 1;
            }
            
            // fill dictionary of coordinates Y (rank)
            self.displayCoordinateY = [NSMutableDictionary dictionary];
            NSInteger rank = 8;
            for(int iterator = 0; iterator < 8; iterator++){
                CGFloat coordinatesYTopLeftOfSquare = iterator * self.squareLength + (size.height / 10 * 3);
                CGFloat coordinateY = coordinatesYTopLeftOfSquare - imageSize.height / 44 + self.squareLength / 2;
                [self.displayCoordinateY setValue: [NSNumber numberWithFloat:coordinateY] forKey:[NSString stringWithFormat:@"%ld", (long)rank]];
                rank = rank - 1;
            }
            self.availableMoves = [NSMutableSet set];
            self.currentPiecesOnTheBoard = [NSMutableSet set];
            self.pieceGrid = [NSMutableArray array];
            self.viewController = viewController;
        }
        return self;
}

- (void)prefillBoardPieces
{
    self.pieceGrid = [NSMutableArray array];
                                                       //  a   b   c   d   e   f   g   h
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @1, @0, nil]];// 8
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @-1, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @1, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @1, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @1, @0, @0, @0, @0, @0, @1, nil]]; // 1
    
   
}


/*
 Creates the board design
 */
- (void)createBoard
{

    // Creates the board
    CGFloat squarePositionX = 0;
    CGFloat squarePositionY = self.viewSize.height / 10 * 3;
    
    Boolean isDarkSquare = NO;
    for(int row = 0; row < 8; row++) {
        
        for(int rank = 0; rank < 8; rank++) {
            UIView *square = [[UIView alloc] initWithFrame: CGRectMake(squarePositionX, squarePositionY, self.squareLength, self.squareLength)];
            squarePositionX = squarePositionX + self.squareLength;
            
            if(isDarkSquare){
                square.backgroundColor = [UIColor brownColor];
            } else {
                square.backgroundColor = [UIColor whiteColor];
            }
            
            isDarkSquare = !isDarkSquare;
            [self.viewController.view addSubview:square];
            
        }
        isDarkSquare = !isDarkSquare;
        squarePositionX = 0;
        squarePositionY += self.squareLength;
    }
    
    
}

/*
 Scans piecegrid to know what pieces to display
 */
- (void)checkGridToDisplayPiecesWithpieceGrid
{
    for(int rank = 1; rank <= 8; rank++){
        for(char file = 'a'; file <= 'h'; file++){
            NSInteger computerFile = [self.fileToComputerFile[[NSString stringWithFormat:@"%c", file]] intValue];
            NSInteger computerRank = abs(8 - rank);
            if([self.pieceGrid[computerRank][computerFile]  isEqual: @1]){
                UIView* whiteKing = [self addChessIconToSquare:@"WhiteKing" file:[NSString stringWithFormat:@"%c", file] rank:[NSString stringWithFormat:@"%d", rank] pieceIdentifier:1];
                [self.viewController.view addSubview:whiteKing];
                [self.currentPiecesOnTheBoard addObject:whiteKing];
            }
            if([self.pieceGrid[computerRank][computerFile]  isEqual: @-1]){
                UIView* blackKing = [self addChessIconToSquare:@"BlackKing" file:[NSString stringWithFormat:@"%c", file] rank:[NSString stringWithFormat:@"%d", rank] pieceIdentifier:1];
                [self.viewController.view addSubview:blackKing];
                [self.currentPiecesOnTheBoard addObject:blackKing];
            }
        }
    }
}


- (UIButton*)addChessIconToSquare:(NSString*)imageName file:(NSString*)file rank:(NSString*)rank pieceIdentifier:(NSInteger)pieceIdentifier
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGFloat coordinateX = [[self.displayCoordinateX objectForKey:file] floatValue];
    CGFloat coordinateY = [[self.displayCoordinateY objectForKey:rank] floatValue];
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(coordinateX, coordinateY, image.size.width / 22, image.size.height / 22);
    myButton.backgroundColor = [UIColor clearColor];
    NSString *rowRankString = [NSString stringWithFormat:@"%@%@", file, rank];
    [myButton setTitle:rowRankString forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(pieceTapped:) forControlEvents:UIControlEventTouchUpInside];
    myButton.titleLabel.shadowColor = [UIColor clearColor];
    myButton.tag = pieceIdentifier;
    [myButton setBackgroundImage:image forState:UIControlStateNormal];
    
    return myButton;
}

#pragma - movement

- (void)pieceTapped:(UIButton *)sender
{
    NSString *title = [sender titleForState:UIControlStateNormal];
    [self clearAvailableMoves];
  
    // Show available squares based on piece type and position of the board
    if(sender.tag == 1) {
       
       [self kingMoves:[title characterAtIndex:0] rank:[title substringWithRange:NSMakeRange(1, 1)]];
    }
    
    
}


- (void)kingMoves:(char)file rank:(NSString*)rank
{
    NSInteger rankInteger = [rank intValue];
    
    
    // checks if there are positions available on its rank
    if(file == 'a') {
        [self checkIfSquareIsAvailable:file + 1 rank:rank currentFile:file currentRank:rank];
        
        if([rank  isEqual: @"1"]){
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file + 1 rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
        } else if([rank  isEqual: @"8"]){
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file + 1 rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
        } else {
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file + 1 rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file + 1 rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
        }
        
    } else if (file == 'h') {
        [self checkIfSquareIsAvailable:file - 1 rank:rank currentFile:file currentRank:rank];
        
        if([rank  isEqual: @"1"]){
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file - 1 rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
        } else if([rank  isEqual: @"8"]){
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file - 1 rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
        } else {
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file - 1 rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file - 1 rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
        }
        
    } else {
        [self checkIfSquareIsAvailable:file - 1 rank:rank currentFile:file currentRank:rank];
        [self checkIfSquareIsAvailable:file + 1 rank:rank currentFile:file currentRank:rank];
        
        if([rank  isEqual: @"1"]){
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file + 1 rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file - 1 rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
        } else if([rank  isEqual: @"8"]){
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file + 1 rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file - 1 rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            
        } else {
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file + 1 rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file + 1 rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file - 1 rank:[NSString stringWithFormat:@"%ld", rankInteger - 1] currentFile:file currentRank:rank];
            [self checkIfSquareIsAvailable:file - 1 rank:[NSString stringWithFormat:@"%ld", rankInteger + 1] currentFile:file currentRank:rank];
        }
    }
}


- (void)checkIfSquareIsAvailable:(char)file rank:(NSString*)rank currentFile:(char)currentFile currentRank:(NSString*)currentRank
{
    NSInteger computerRank = abs(8 - [rank intValue]);
    
    NSInteger computerFile = [self.fileToComputerFile[[NSString stringWithFormat:@"%c", file]] intValue];
    CGSize imageSize = [UIImage imageNamed:@"BlackKing"].size;
    //NSLog(@"Checking if move is available at %c%@", file, rank);
    
    // adds button if move is available
    if([self.pieceGrid[computerRank][computerFile]  isEqual: @0]){
        
        UIButton *availableMove = [UIButton buttonWithType:UIButtonTypeSystem];
        
        CGFloat coordinateX = [[self.displayCoordinateX objectForKey:[NSString stringWithFormat:@"%c", file]] floatValue];
        CGFloat coordinateY = [[self.displayCoordinateY objectForKey:rank] floatValue];
        availableMove.frame = CGRectMake(coordinateX,coordinateY, imageSize.width / 22, imageSize.height / 22);
        availableMove.backgroundColor = [UIColor redColor];
        
        NSString* moveFromAndTo = [[NSString stringWithFormat:@"%c", currentFile] stringByAppendingString:[currentRank stringByAppendingString:[[NSString stringWithFormat:@"%c", file] stringByAppendingString:rank]]];
        [availableMove setTitle:moveFromAndTo forState:UIControlStateNormal];
        [availableMove setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [availableMove addTarget:self action:@selector(movePiece:) forControlEvents:UIControlEventTouchUpInside];
        [self.availableMoves addObject:availableMove];
        [self.viewController.view addSubview:availableMove];
    }
    
}


- (void)movePiece:(UIButton *)sender
{
    NSString *moveFromAndTo = [sender titleForState:UIControlStateNormal];
    
    NSString *currentfile = [moveFromAndTo substringWithRange:NSMakeRange(0, 1)];
    NSString *currentRank = [moveFromAndTo substringWithRange:NSMakeRange(1, 1)];
    NSString *newFile = [moveFromAndTo substringWithRange:NSMakeRange(2, 1)];
    NSString *newRank =[moveFromAndTo substringWithRange:NSMakeRange(3, 1)];
    
    NSInteger computerCurrentFile = [self.fileToComputerFile[[NSString stringWithFormat:@"%@", currentfile]] intValue];
    NSInteger computerCurrentRank = abs(8 - [currentRank intValue]);
    NSInteger computerNewFile = [self.fileToComputerFile[[NSString stringWithFormat:@"%@", newFile]] intValue];
    NSInteger computerNewRank = abs(8 - [newRank intValue]);
    
    NSNumber *pieceIdentifier = self.pieceGrid[computerCurrentRank][computerCurrentFile];
    
    self.pieceGrid[computerCurrentRank][computerCurrentFile] = @0;
    self.pieceGrid[computerNewRank][computerNewFile] = pieceIdentifier;
    [self clearCurrentPieces];
    [self clearAvailableMoves];
    [self checkGridToDisplayPiecesWithpieceGrid];
}

/*
 When background is tapped or if another piece is selected, "deselects" the current piece that is tapped to remove its available moves to the player
 */
- (void)clearAvailableMoves
{
    for(UIButton *move in self.availableMoves){
        
        [move removeFromSuperview];
    }
    [self.availableMoves removeAllObjects];
   
}

- (void)clearCurrentPieces
{
    for(UIView *view in self.currentPiecesOnTheBoard){
        [view removeFromSuperview];
    }
    [self.currentPiecesOnTheBoard removeAllObjects];
}
@end
