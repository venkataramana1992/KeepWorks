//
//  ViewController.m
//  KeepWorks
//
//  Created by apple on 31/10/16.
//  Copyright © 2016 com.appcoda.GSignIn. All rights reserved.
//

#import "ViewController.h"
#import "EventsViewController.h"
#import "User.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameInputField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moveToHome:(id)sender
{
    NSString *name = _nameInputField.text;
    if (name.length && [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length)
    {
        if ([self isUserExistsWithName: name])
        {
            [self performSegueWithIdentifier:@"MoveToHome" sender:nil];
        }
        else
        {
            [self addUser:name];
            [self performSegueWithIdentifier:@"MoveToHome" sender:nil];
        }
    }
}

-(BOOL)isUserExistsWithName:(NSString*)userName
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",userName];
    fetchRequest.predicate = predicate;
    NSError *error;
    NSArray *users = [context executeFetchRequest:fetchRequest error:&error];
    return users.count;
}

-(void)addUser:(NSString*)userName
{
    NSManagedObjectContext *context = [self getManagedObjectContext];
    User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
    newUser.name = userName;
    if([context save:nil])
    {
        
    }
}

-(NSManagedObjectContext*)getManagedObjectContext
{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EventsViewController *eventViewController = segue.destinationViewController;
    eventViewController.currentUesr = _nameInputField.text;
}

@end
