//
//  CurrencyPickerViewController.m
//  CurrencyConverter
//
//  Created by Nandini  Sundara Raman on 11/26/13.
//  Copyright (c) 2013 Nandini Sundara Raman. All rights reserved.
//

#import "CurrencyPickerViewController.h"
#import "AFNetworking.h"
#import "ViewController.h"
#define kCurrencyListURL @"http://openexchangerates.org/api/currencies.json"


@interface CurrencyPickerViewController ()

@end

@implementation CurrencyPickerViewController
@synthesize currencyPicker;
@synthesize delegate;

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
    [self getCurrencyListFromWeb];
    self.currencyPicker.isAccessibilityElement = YES;
    self.currencyPicker.accessibilityTraits = UIAccessibilityTraitAdjustable;
    self.doneButton.isAccessibilityElement = YES;
    self.doneButton.accessibilityLabel = @"Done choosing. Back to main menu";
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.currencyPicker);
}

-(void)getCurrencyListFromWeb
{
    NSURL *urlCurrencyList = [NSURL URLWithString:kCurrencyListURL];
    NSURLRequest *requestCurrencyList = [NSURLRequest requestWithURL:urlCurrencyList];
    AFJSONRequestOperation *operationCurrencyList = [AFJSONRequestOperation JSONRequestOperationWithRequest:requestCurrencyList
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                           
                                                                                            NSLog(@"%@",JSON);
                                                                
                                                                                            NSDictionary *dict = (NSDictionary *)JSON;
                                                                                    self.listOfCurrencies = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
                                                                              //              self.listOfCurrencies = JSON;
                                                                                            self.listOfCurrencyNames = [dict objectsForKeys:self.listOfCurrencies notFoundMarker:[NSNull null]];
                                                                        
                                                                                            NSLog(@"%@",self.listOfCurrencies);
                                                                                            
                                                                                            [self.currencyPicker reloadAllComponents];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Request Failed : %@, %@",error,error.userInfo);
                                                                                        }];
    [operationCurrencyList start];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0) {
        return [self.listOfCurrencies count];
    }
    return [self.listOfCurrencies count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *output = [[NSString alloc] initWithFormat:@"%@ (%@)",[self.listOfCurrencies objectAtIndex:row],[self.listOfCurrencyNames objectAtIndex:row]];
 //   NSString *output = [[NSString alloc] initWithFormat:@"%@",(NSString *)[self.listOfCurrencies objectAtIndex:row]];
    output.isAccessibilityElement = YES;
    output.accessibilityLabel = [self.listOfCurrencyNames objectAtIndex:row];
    if(component==0)
        return output;
    return output;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%@",[self.listOfCurrencies objectAtIndex:row]);
    if([self.fromOrTo isEqualToString:@"from"])
    {
         NSLog(@"Here at CC from");
        [self.delegate sendCurrencyToConverter:self didFinishChoosingCurrency:[self.listOfCurrencies objectAtIndex:row] name:[self.listOfCurrencyNames objectAtIndex:row] type:@"from"];
    }
    else if([self.fromOrTo isEqualToString:@"to"])
    {
         NSLog(@"Here at CC to");
        [self.delegate sendCurrencyToConverter:self didFinishChoosingCurrency:[self.listOfCurrencies objectAtIndex:row] name:[self.listOfCurrencyNames objectAtIndex:row] type:@"to"];
    }
}

-(IBAction)Done:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)pickerView:(UIPickerView *)pickerView accessibilityLabelForComponent:(NSInteger)component
{
    return @"Choose currency values";
}


@end
