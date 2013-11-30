//
//  CurrencyPickerViewController.h
//  CurrencyConverter
//
//  Created by Nandini  Sundara Raman on 11/26/13.
//  Copyright (c) 2013 Nandini Sundara Raman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrencyConverterDelegate <NSObject>
-(void)sendCurrencyToConverter:(id)controller didFinishChoosingCurrency:(NSString *)currency name:(NSString *)currencyName type:(NSString *)fromOrTo;
@end

@interface CurrencyPickerViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewAccessibilityDelegate>
@property (strong, nonatomic) IBOutlet UILabel *Scene2Label;
@property (strong, nonatomic) IBOutlet UIPickerView *currencyPicker;
- (IBAction)Done:(id)sender;
@property (strong,nonatomic) NSArray *listOfCurrencies;
@property (strong,nonatomic) NSArray *listOfCurrencyNames;

@property (strong,nonatomic) NSString *fromOrTo;
@property (weak,nonatomic) id <CurrencyConverterDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@end
