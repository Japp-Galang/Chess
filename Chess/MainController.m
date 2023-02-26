//
//  ViewController.m
//  Chess
//
//  Created by Japp Galang on 2/21/23.
//

#import "MainController.h"


@interface MainController ()

@property (strong, nonatomic) NSDictionary* fileToComputerFile;
@property (nonatomic) CGFloat squareLength;

@end


@implementation MainController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.squareLength = self.view.frame.size.width / 8;
    
    [self prefillDisplayGrid];
    
    // Creates the board
    CGFloat squarePositionX = 0;
    CGFloat squarePositionY = self.view.frame.size.height / 10 * 3;
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
            [self.view addSubview:square];
            
        }
        isDarkSquare = !isDarkSquare;
        squarePositionX = 0;
        squarePositionY += self.squareLength;
    }
    
    

    self.fileToComputerFile = @{@"a": @0, @"b": @1, @"c": @2, @"d": @3, @"e": @4, @"f": @5, @"g": @6, @"h": @7};
    self.pieceGrid = [NSMutableArray array];
                                                            //  a   b   c   d   e    f   g   h
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @-1, @0, @0, @0, nil]];// 8
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil]];
    [self.pieceGrid addObject:[NSMutableArray arrayWithObjects:@0, @0, @0, @0, @1, @0, @0, @0, nil]]; // 1
    
    [self checkGridToDisplayPieces];
}

- (void)checkGridToDisplayPieces
{
    for(int rank = 0; rank < 8; rank++){
        for(int file = 0; file < 8; file++){
            if([self.pieceGrid[rank][file]  isEqual: @1]){
                [self addChessIconToSquare:@"WhiteKing" file:@"e" rank:@"1" pieceIdentifier:1];
                
            }
            if([self.pieceGrid[rank][file]  isEqual: @-1]){
                [self addChessIconToSquare:@"BlackKing" file:@"e" rank:@"8" pieceIdentifier:1];
            }
        }
    }
    
}


- (void)addChessIconToSquare:(NSString*)imageName file:(NSString*)file rank:(NSString*)rank pieceIdentifier:(NSInteger)pieceIdentifier
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat coordinateX = [[self.displayCoordinateX objectForKey:file] floatValue];
    CGFloat coordinateY = [[self.displayCoordinateY objectForKey:rank] floatValue];
    
    myImageView.frame = CGRectMake(coordinateX, coordinateY, image.size.width / 22, image.size.height / 22);
    
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(coordinateX, coordinateY, image.size.width / 22, image.size.height / 22);
    myButton.backgroundColor = [UIColor clearColor];
    NSString *rowRankString = [NSString stringWithFormat:@"%@%@", file, rank];
    [myButton setTitle:rowRankString forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(pieceTapped:) forControlEvents:UIControlEventTouchUpInside];
    myButton.titleLabel.shadowColor = [UIColor clearColor];
    myButton.tag = pieceIdentifier;
    [self.view addSubview:myImageView];
    [self.view addSubview:myButton];
    
}


- (void)pieceTapped:(UIButton *)sender
{
    NSString *title = [sender titleForState:UIControlStateNormal];
    //NSLog(@"Button title: %@ \nPieceIDentifier: %ld", title, (long)sender.tag);
    
    // Show available squares based on piece type and position of the board
    if(sender.tag == 1) {
        [self kingMoves:[title characterAtIndex:0] rank:[title substringWithRange:NSMakeRange(1, 1)]];
    }
    
    // Make those squares available to click
    
}


/*
 fills the dictionary items displayCoordinateX and displayCoordinateY in order to
 */
- (void)prefillDisplayGrid
{
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
    
    NSLog(@"%@", self.displayCoordinateX);
    // fill dictionary of coordinates Y (rank)
    self.displayCoordinateY = [NSMutableDictionary dictionary];
    NSInteger rank = 8;
    for(int iterator = 0; iterator < 8; iterator++){
        CGFloat coordinatesYTopLeftOfSquare = iterator * self.squareLength + (self.view.frame.size.height / 10 * 3);
        CGFloat coordinateY = coordinatesYTopLeftOfSquare - imageSize.height / 44 + self.squareLength / 2;
        [self.displayCoordinateY setValue: [NSNumber numberWithFloat:coordinateY] forKey:[NSString stringWithFormat:@"%ld", (long)rank]];
        rank = rank - 1;
    }
    NSLog(@"%@", self.displayCoordinateY);
}


#pragma - Each method displays how each piece can move given a position
- (void)kingMoves:(char)file rank:(NSString*)rank
{
    
    
    // checks if there are positions available on its rank
    if(file == 'a') {
        
        
    } else if (file == 'h') {
        
        
    } else {
        if([self checkIfSquareIsAvailable:file - 1 rank:rank]) {
            UIButton *availableMove1 = [UIButton buttonWithType:UIButtonTypeSystem];
            
        }
        
        
    }
    
}


- (BOOL)checkIfSquareIsAvailable:(char)file rank:(NSString*)rank
{
    NSInteger computerRank = [rank intValue] - 1;
    NSInteger computerFile = [self.fileToComputerFile[[NSString stringWithFormat:@"%c", file]] intValue];
    
    if(self.pieceGrid[computerRank][computerFile] == 0){
        return YES;
    } else {
        return NO;
    }
    
}



@end