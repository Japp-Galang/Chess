//
//  ViewController.m
//  Chess
//
//  Created by Japp Galang on 2/21/23.
//

#import "ViewController.h"
#import "ViewModelController.h"

@interface ViewController ()


@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewModelController = [[ViewModelController alloc] initWithViewSize:self.view.frame.size viewController:self];
  
    
    [self.viewModelController prefillBoardPieces];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearAvailableMoves)];
    [self.view addGestureRecognizer:tapGesture];

    // Creates the board
    [self.viewModelController createBoard];

    // Puts initial pieces on the board
    [self.viewModelController checkGridToDisplayPiecesWithpieceGrid];
}

- (void)clearAvailableMoves
{
    [self.viewModelController clearAvailableMoves];
}

@end
