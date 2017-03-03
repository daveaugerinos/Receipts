//
//  ReceiptViewController.m
//  Receipts
//
//  Created by Dave Augerinos on 2017-03-02.
//  Copyright © 2017 Dave Augerinos. All rights reserved.
//

#import "ReceiptViewController.h"
#import "ReceiptTableViewCell.h"
#import "Receipts+CoreDataModel.h"

@interface ReceiptViewController ()

@property (weak, nonatomic) IBOutlet UITableView *receiptTableView;
@property (strong, nonatomic) NSMutableArray *receiptsByTagsArray;

@end

@implementation ReceiptViewController

static NSString *const reuseIdentifier = @"receiptCell";
static NSString *const addReceiptVCSegueIdentifier = @"addReceiptVC";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.coreDataManager = [CoreDataManager sharedInstance];
    self.receiptsByTagsArray = [[NSMutableArray alloc] init];
}


- (void)viewWillAppear:(BOOL)animated {
    
    NSArray *tagsArray = [self.coreDataManager fetchTags];
    
    for (Tag *myTag in tagsArray) {
        
        NSSet *receiptsSet = myTag.tagToReceipt;
        NSMutableArray *receiptsArray = [[receiptsSet allObjects] mutableCopy];
        
        NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:YES];
        [receiptsArray sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
        
        [self.receiptsByTagsArray addObject:receiptsArray];
    }
    
    
    [self.receiptTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addReceiptButtonPressed:(UIButton *)sender {

    [self performSegueWithIdentifier:addReceiptVCSegueIdentifier sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSLog(@"number of section");
    NSLog(@"%lu", (unsigned long)[[self.coreDataManager fetchTags] count]);
    
    return [[self.coreDataManager fetchTags] count];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"number of row");
    NSLog(@"%lu", (unsigned long)[self.receiptsByTagsArray[section] count]);
    
    return [self.receiptsByTagsArray[section] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *tags = [self.coreDataManager fetchTags];
    Tag *tag = tags[section];
    return tag.tagName;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
 
    NSArray *receiptsArray = self.receiptsByTagsArray[indexPath.section];
 
    Receipt *myReceipt = receiptsArray[indexPath.row];
    
    [cell configureReceiptCell:myReceipt];
    
    return cell;
}

@end
