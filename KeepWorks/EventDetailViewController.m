//
//  EventDetailViewController.m
//  KeepWorks
//
//  Created by apple on 01/11/16.
//  Copyright © 2016 com.appcoda.GSignIn. All rights reserved.
//

#import "EventDetailViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "Event.h"

enum EventTrack
{
    kTitleUntrack,
    kTitleTrack
};

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventPlace;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventType;
@property (weak, nonatomic) IBOutlet UIButton *btnEventTrack;
- (IBAction)startTracking:(id)sender;
@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.selectedEvent == nil)
    {
        self.eventName.text = [self.selectedEventDict objectForKey:@"eventName"];
        self.eventPlace.text = [self.selectedEventDict objectForKey:@"eventPlace"];
        self.eventType.text = [[self.selectedEventDict objectForKey:@"eventType"] intValue] ? @"Paid" : @"Free";
        self.btnEventTrack.tag = kTitleUntrack;
        [self.btnEventTrack setTitle:@"Track" forState:UIControlStateNormal];
    }else
    {
        self.eventName.text = _selectedEvent.eventName;
        self.eventPlace.text = _selectedEvent.eventPlace;
        self.eventType.text = _selectedEvent.eventType;
        self.btnEventTrack.tag = kTitleTrack;
        [self.btnEventTrack setTitle:@"Untrack" forState:UIControlStateNormal];
    }
        // Do any additional setup after loading the view.
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

- (IBAction)startTracking:(id)sender
{
    if (_selectedEvent!= nil)
    {
        if ([self isEventExists: self.selectedEvent])
        {
            [self deleteEvent:self.selectedEvent];
        }
    }
    else if ([self isEventExists: self.selectedEventDict])
    {
        
    }else
    {
        [self addEvent:self.selectedEventDict];
    }
}

-(void)deleteEvent:(Event*)aEvent
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",self.currentUser];
    fetchRequest.predicate = predicate;
    NSError *error;
    NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
    User *user = [users lastObject];
    NSLog(@"user %@ events %@",user.name, user.trackedEvents);
    for (Event *e in user.trackedEvents)
    {
        NSLog(@"event %@",e.eventName);
    }
    
    NSPredicate *eventPredicate = [NSPredicate predicateWithFormat:@"eventName=%@", aEvent.eventName];

    NSOrderedSet *events = [[(User*)[users lastObject] trackedEvents] filteredOrderedSetUsingPredicate:eventPredicate];
    [context deleteObject:(Event*)[events lastObject]];
    if ([context save:nil])
    {
        NSLog(@"Object Deleted");
        self.btnEventTrack.enabled = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Deletion" message:@"Event has been removed from track list" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(BOOL)isEventExists:(id)event
{
    if (self.selectedEvent)
    {
        Event *aEvent = (Event*)event;
        NSManagedObjectContext *context = [self getManagedObjectContext];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",self.currentUser];
        fetchRequest.predicate = predicate;
        NSError *error;
        NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
        NSPredicate *eventPredicate = [NSPredicate predicateWithFormat:@"eventName=%@", aEvent.eventName];
        NSOrderedSet *events = [[(User*)[users lastObject] trackedEvents] filteredOrderedSetUsingPredicate:eventPredicate];
        return events.count;
    }
    else
    {
        NSManagedObjectContext *context = [self getManagedObjectContext];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",self.currentUser];
        fetchRequest.predicate = predicate;
        NSError *error;
        NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
        NSPredicate *eventPredicate = [NSPredicate predicateWithFormat:@"eventName=%@", [event objectForKey:@"eventName"]];
        NSOrderedSet *events = [[(User*)[users lastObject] trackedEvents] filteredOrderedSetUsingPredicate:eventPredicate];
           return events.count;
    }
}

-(void)addEvent:(NSDictionary*)event
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",self.currentUser];
    fetchRequest.predicate = predicate;
    NSError *error;
    NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
    User *currentUser = [users lastObject];
    Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    newEvent.eventName = [event objectForKey:@"eventName"];
    newEvent.eventPlace = [event objectForKey:@"eventPlace"];
    newEvent.eventType = [event objectForKey:@"eventType"];
    newEvent.user = currentUser;
    
    if([context save:nil])
    {
        NSLog(@"Event saved");
        
        NSLog(@"Object Deleted");
        self.btnEventTrack.enabled = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Track" message:@"Event has been added to track list" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(NSManagedObjectContext*)getManagedObjectContext
{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
