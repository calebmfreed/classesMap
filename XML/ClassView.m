//
//  ClassView.m
//  XML
//
//  Created by Caleb Freed on 12/22/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "ClassView.h"
#import <GoogleMaps/GoogleMaps.h>

//EWS Lab Use Json url:https://my.engr.illinois.edu/labtrack/util_data_json.asp?callback=?

@interface ClassView ()

@end

@implementation ClassView
@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //scrollView.translatesAutoresizingMaskIntoConstraints = NO;
//    CGFloat topOffset = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
//    scrollView.contentInset = UIEdgeInsetsMake(-topOffset, 0.0, 0.0, 0.0);
    
//    CGRect mapf;
//    mapf.origin.x = 0;
//    mapf.origin.y = self.scrollView.frame.size.height;
//    mapf.size = self.scrollView.frame.size;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                              target:self
                                              action:@selector(detailsButtonPressed)];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[_passedClass.details.lat floatValue]
                                                            longitude:[_passedClass.details.lon floatValue]
                                                                 zoom:20];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    marker.snippet = @"The Quad";
    marker.map = mapView;
    NSLog(@"All Class: %@, lat: %@ long:%@", _passedClass, _passedClass.details.lat, _passedClass.details.lon);
//    NSString * str = _passedClass.details.building;
//    str=[str stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//
//    NSString *detailUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyCEP4uquUU9lj4m_VejblBg69eZgaTKneQ&query=%@&sensor=true", str];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    [manager GET:detailUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary * tempDict = (NSDictionary *)responseObject;
//        NSLog(@"Response: %@", tempDict[@"results"][0][@"geometry"][@"location"][@"lat"]);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
//    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor grayColor], [UIColor blueColor], nil];
//    for (int i = 0; i < colors.count; i++) {
//        CGRect frame;
//        frame.origin.x = 0;
//        frame.origin.y = self.scrollView.frame.size.height * i;
//        frame.size = self.scrollView.frame.size;
//        NSLog(@"frame size H: %f Y:%f Window: %f", frame.size.height, frame.origin.y, scrollView.frame.origin.y);
//        
//        UIView *subview = [[UIView alloc] initWithFrame:frame];
//        subview.backgroundColor = [colors objectAtIndex:i];
//        if(i == 0)
//        {
//            NSLog(@"Should add map");
//            [subview addSubview:mapView];
//        }
//        CGRect labelf;
//        labelf.origin.x = 0.0f;
//        labelf.origin.y = 5.0f;
//        labelf.size.height = 10.0f;
//        labelf.size.width = 320.0f;
//        UILabel * test = [[UILabel alloc] initWithFrame:labelf];
//        test.text = @"HAHAHAHA";
//        test.textColor = [UIColor yellowColor];
//        test.textAlignment = NSTextAlignmentCenter;
//        [subview addSubview:test];
        //[self.scrollView addSubview:subview];
    //}
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height* colors.count);
    self.view = mapView;
	// Do any additional setup after loading the view.
}

- (void) detailsButtonPressed
{
    [self performSegueWithIdentifier:@"details" sender:self];
}
- (void)viewDidLayoutSubviews
{
    //self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height * 3);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"details"])
    {
        [segue.destinationViewController setCurrClass:_passedClass];
    }
}

@end
