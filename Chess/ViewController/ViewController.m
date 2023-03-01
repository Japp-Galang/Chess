//
//  ViewController.m
//  Chess
//
//  Created by Japp Galang on 2/21/23.
//

#import "ViewController.h"
#import "ViewModelController.h"

@interface ViewController ()


@property (strong, nonatomic) NSDictionary* fileToComputerFile;


@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewModelController = [[ViewModelController alloc] initWithViewSize:self.view.frame.size viewController:self];
    self.fileToComputerFile = @{@"a": @0, @"b": @1, @"c": @2, @"d": @3, @"e": @4, @"f": @5, @"g": @6, @"h": @7};
  
    self.pieceGrid = [NSMutableArray array];
    self.pieceGrid = [self.viewModelController prefillBoardPieces:self.pieceGrid];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearAvailableMoves)];
    [self.view addGestureRecognizer:tapGesture];

    
    
    // Creates the board
    UIView *chessBoard = [self.viewModelController createBoard];
    [self.view addSubview:chessBoard];
    
    // Puts pieces on the board
    UIView* pieceOverlay = [self.viewModelController checkGridToDisplayPiecesWithpieceGrid:self.pieceGrid];
    [self.view addSubview:pieceOverlay];
}

- (void)clearAvailableMoves
{
    [self.viewModelController clearAvailableMoves];
}

@end
