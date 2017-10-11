//
//  DSViewController.m
//  DynamicStatistics
//
//  Created by 492334421@qq.com on 10/09/2017.
//  Copyright (c) 2017 492334421@qq.com. All rights reserved.
//

#import "DSViewController.h"

@interface DSViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *hookGestureRecongizeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_hookGestureRecongizeLabel setUserInteractionEnabled:YES];
    [_hookGestureRecongizeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetAction)]];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.layer.borderColor = [UIColor grayColor].CGColor;
    _tableView.layer.borderWidth = 1;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.layer.borderColor = [UIColor grayColor].CGColor;
    _collectionView.layer.borderWidth = 1;
}

-(void)targetAction
{
    NSLog(@"hookGestureRecongizeLabel");
}

- (IBAction)showAlertView:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert View" message:@"This is a alert view!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Button 1", @"Button 2", nil];
    [alert show];
}

- (IBAction)showActionSheet:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Action Sheet" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:@"Destructive" otherButtonTitles:@"Button 1", @"Button 2", nil];
    [sheet showInView:self.view];
}

- (IBAction)showAlertController:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert Controller" message:@"This is an alert controller!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"table cell: %d", indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"didSelectRowAtIndexPath: %@", indexPath);
//}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UIAlertViewDelegate, UIActionSheetDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertView:clickedButtonAtIndex: %d", buttonIndex);
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet:clickedButtonAtIndex: %d", buttonIndex);

}

@end
