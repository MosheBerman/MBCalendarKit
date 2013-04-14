//
//  CKViewController.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKViewController.h"

#import "CKCakeView.h"

@interface CKViewController ()

@property (nonatomic, strong) CKCakeView *cakeView;

@end

@implementation CKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[self view] setBackgroundColor:[UIColor orangeColor]];
    
    [self setCakeView:[CKCakeView new]];
    [[self view] addSubview:[self cakeView]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
