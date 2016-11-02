//
//  EventsViewController.m
//  KeepWorks
//
//  Created by apple on 01/11/16.
//  Copyright © 2016 com.appcoda.GSignIn. All rights reserved.
//

#import "EventsViewController.h"
#import "EventCell.h"
#import "EventDetailViewController.h"
#import "AppDelegate.h"

@interface EventsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    BOOL shouldTrackedEvents;
}

@property (nonatomic, assign) NSInteger *selectedIndex;
@property (weak, nonatomic) IBOutlet UISegmentedControl *optionSegmentedControl;
- (IBAction)modeSelector:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;

@property (nonatomic, strong) NSArray *eventsArray, *trackedEvents;
@end

@implementation EventsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = self.currentUesr;
    self.eventsArray = [[NSArray alloc] init];
    self.trackedEvents  = [[NSArray alloc] init];
    [self readListOfEvents];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (shouldTrackedEvents)
    {
        [self fetchTrackeEvents];
        [_eventsCollectionView reloadData];
    }
    
}

-(void)fetchTrackeEvents
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",self.currentUesr];
    fetchRequest.predicate = predicate;
    NSError *error;
    NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
    User *user=[users lastObject];
    NSLog(@"user %@ events %@",user.name,user.trackedEvents);
    for (Event *e in user.trackedEvents)
    {
        NSLog(@"event %@",e.eventName);
    }
    
    self.trackedEvents = [NSArray arrayWithArray:[[user trackedEvents] array]];
}

-(void)swipeDetected:(UISwipeGestureRecognizer*)swipeGesture
{
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.eventsCollectionView.layer addAnimation:transition forKey:nil];
        shouldTrackedEvents = YES;
        [self fetchTrackeEvents];
    }
    else
    {
        shouldTrackedEvents = NO;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.eventsCollectionView.layer addAnimation:transition forKey:nil];
    }
    [_eventsCollectionView reloadData];
}

-(void)readListOfEvents
{    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Events" ofType:@"json"];
    NSData *eventsData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    self.eventsArray = [NSJSONSerialization JSONObjectWithData:eventsData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"%@", _eventsArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UICollectionView callbacks 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (shouldTrackedEvents)
    {
        return _trackedEvents.count;
    }else
    {
        return _eventsArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell *cell;
    if (shouldTrackedEvents)
    {
         Event *aEvent = [self.trackedEvents objectAtIndex:indexPath.row];
        if (self.optionSegmentedControl.selectedSegmentIndex)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
        }
        else{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
            cell.eventPlace.text = [NSString stringWithFormat:@"Event Place: %@", aEvent.eventPlace];
            cell.eventType.text = [NSString stringWithFormat:@"Event Type: %@", (aEvent.eventType)?@"Free" : @"Paid"];
        }
        cell.eventName.text = aEvent.eventName;
    }
    else
    {
        NSDictionary* aEvent = [self.eventsArray objectAtIndex:indexPath.row];        
        if (self.optionSegmentedControl.selectedSegmentIndex)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
        }
        else{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
            cell.eventPlace.text = [NSString stringWithFormat:@"Event Place: %@", [aEvent objectForKey:@"eventPlace"]];
            cell.eventType.text = [NSString stringWithFormat:@"Event Place: %@", [[aEvent objectForKey:@"eventType"] intValue] ? @"Paid" : @"Free"];
        }
        cell.eventName.text = [NSString stringWithFormat:@"Event Place: %@", [aEvent objectForKey:@"eventName"]];

    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_optionSegmentedControl.selectedSegmentIndex)
    {
        return  CGSizeMake(self.eventsCollectionView.frame.size.width/4, 120);
    }
    else
    {
        return  CGSizeMake(self.eventsCollectionView.frame.size.width, 120);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", [self.eventsArray objectAtIndex:indexPath.row]);
}

- (IBAction)modeSelector:(id)sender
{
    [_eventsCollectionView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (shouldTrackedEvents)
    {
        NSIndexPath *indexPath = [self.eventsCollectionView indexPathForCell:sender];
        Event *selectedEvent = [self.trackedEvents objectAtIndex:indexPath.row];
        EventDetailViewController *eventDetailViewController = (EventDetailViewController*)segue.destinationViewController;
        eventDetailViewController.selectedEvent = selectedEvent;
        eventDetailViewController.currentUser = self.currentUesr;
    }else
    {
        NSIndexPath *indexPath = [self.eventsCollectionView indexPathForCell:sender];
        NSDictionary *selectedEventDict = [self.eventsArray objectAtIndex:indexPath.row];
        
        EventDetailViewController *eventDetailViewController = (EventDetailViewController*)segue.destinationViewController;
        eventDetailViewController.selectedEventDict = selectedEventDict;
        eventDetailViewController.currentUser = self.currentUesr;
    }
}

-(NSManagedObjectContext*)getManagedObjectContext
{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

@end
