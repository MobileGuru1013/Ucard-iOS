//
//  PostcardTextViewController.m
//  Ucard
//
//  Created by WuLeilei on 15/4/19.
//  Copyright (c) 2015年 Ucard. All rights reserved.
//

#import "PostcardTextViewController.h"
#import "ActionSheetCustomPicker.h"
#import "CardNewBackView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "NSString+Size.h"
#import "Toast+UIView.h"

@interface PostcardTextViewController () <ActionSheetCustomPickerDelegate>
{
    UITextView *_textView;
    ActionSheetCustomPicker *_picker;
    NSArray *_fontArray;
    NSArray *_sizeArray;
    NSInteger _fontIndex;
    NSInteger _sizeIndex;
    NSInteger _fontOrginIndex;
    NSInteger _sizeOrginIndex;
    UILabel *_tipsLabel;
    UILabel *_fontLabel;
    CGRect _textContentFrame;
    UIBarButtonItem *_fontItem;
    NSString *_errorString;
}
@end

@implementation PostcardTextViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width;
    if(kR35) width= 15;
    else if(kR40) width =10;
    else if(kR47) width= 0;
    else if(kR55) width= 0;
    _errorString = @"";
    self.title = NSLocalizedString(@"localized114", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"localized117", nil) style:UIBarButtonItemStylePlain target:self action:@selector(finished)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
//    self.view = [[TPKeyboardAvoidingScrollView alloc] init];
//    self.view.backgroundColor = [UIColor whiteColor];
    _fontIndex = [Singleton shareInstance].cardModel.fontIndex;
    _sizeIndex = [Singleton shareInstance].cardModel.sizeIndex;
    _fontOrginIndex = _fontIndex;
    _sizeOrginIndex = _sizeIndex;
    _fontArray = [Constants getFont];
    _sizeArray = [Constants getSize];
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 44)];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    _tipsLabel.minimumScaleFactor = 0.5;
    _tipsLabel.adjustsFontSizeToFitWidth = YES;
    _tipsLabel.textColor = kGreenColor;
    _tipsLabel.backgroundColor = [UIColor redColor];
    
    UIBarButtonItem *tipsItem = [[UIBarButtonItem alloc] initWithCustomView:_tipsLabel];
//    tipsItem.action = @selector(showFont);
//    [tipsItem setTarget:self];
//    [tipsItem setAction:@selector(showFont)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _fontItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"localized132", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showFont)];
    [_fontItem setTintColor:kGreenColor];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [toolbar setItems:@[flexibleSpace, _fontItem, flexibleSpace]];
    
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    _textView.inputAccessoryView = toolbar;
    _textView.text = [Singleton shareInstance].cardModel.text;
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
    [self applyTextStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textChanged:(NSNotification *)notification
{
    [self checkText];
}

- (void)goBack
{
    [Singleton shareInstance].cardModel.fontIndex = _fontOrginIndex;
    [Singleton shareInstance].cardModel.sizeIndex = _sizeOrginIndex;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finished
{
    if ([self checkText]) {
        return;
    } else {
        if (_sizeIndex < [_sizeArray count] - 1) {
            [self increaseFont];
        }
    }
    
    [Singleton shareInstance].cardModel.fontIndex = _fontIndex;
    [Singleton shareInstance].cardModel.sizeIndex = _sizeIndex;
    [Singleton shareInstance].cardModel.text = _textView.text;
    
    [Singleton shareInstance].cardModel.hasUploaded = NO;
    [[Singleton shareInstance].cardModel updateData];
    
    if (self.updateTextBlock) {
        self.updateTextBlock();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)applyTextStyle
{
    NSDictionary *dic = [_fontArray objectAtIndex:_fontIndex];
    NSString *fontName = [dic.allKeys firstObject];
    _textView.font = [UIFont fontWithName:[dic.allKeys firstObject] size:[[_sizeArray objectAtIndex:_sizeIndex] floatValue]];
    if (_errorString && _errorString.length > 0) {
        
        [_fontItem setTintColor:kRedColor];
        _fontItem.title = [NSString stringWithFormat:@"%@", _errorString ];
    } else {
        [_fontItem setTintColor:kGreenColor];
        _fontItem.title = [NSString stringWithFormat:@"[ %@ ]", fontName ];
    }
    [self checkText];
}

#pragma mark 字体与字号

- (void)showFont
{
    [_textView resignFirstResponder];
    
    NSArray *initialSelections =  @[[NSNumber numberWithInteger:_fontIndex], [NSNumber numberWithInteger:_sizeIndex]];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"localized073", nil) style:UIBarButtonItemStylePlain target:self action:nil];
    [cancel setTintColor:[UIColor grayColor]];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"localized012", nil) style:UIBarButtonItemStylePlain target:self action:nil];
    [done setTintColor:[UIColor grayColor]];
    
    _picker = [[ActionSheetCustomPicker alloc] initWithTitle:nil
                                                    delegate:self
                                            showCancelButton:YES
                                                      origin:self.view
                                           initialSelections:initialSelections];
    [_picker setCancelButton:cancel];
    [_picker setDoneButton:done];
    [_picker showActionSheetPicker];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - ActionSheetCustomPickerDelegate Optional's
/////////////////////////////////////////////////////////////////////////
- (void)configurePickerView:(UIPickerView *)pickerView
{
    // Override default and hide selection indicator
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    [Singleton shareInstance].cardModel.fontIndex = _fontIndex;
    [Singleton shareInstance].cardModel.sizeIndex = _sizeIndex;
    
    [_textView becomeFirstResponder];
}

- (void)actionSheetPickerDidCancel:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    _fontIndex = [Singleton shareInstance].cardModel.fontIndex;
    _sizeIndex = [Singleton shareInstance].cardModel.sizeIndex;
    [self applyTextStyle];
    
    [_textView becomeFirstResponder];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerViewDataSource Implementation
/////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0: return [_fontArray count];
        case 1: return [_sizeArray count];
        default:break;
    }
    return 0;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: return kScreenWidth - 80;
        case 1: return 80.0f;
        default:break;
    }
    
    return 0;
}
/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
 {
 return
 }
 */
// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: {
            NSDictionary *font = [_fontArray objectAtIndex:row];
            return font.allValues.firstObject;
            
            break;
        }
            
        case 1: {
            return [_sizeArray objectAtIndex:row];
            
            break;
        }
            
        default:
            break;
    }
    return nil;
}

/////////////////////////////////////////////////////////////////////////

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            _fontIndex = row;
            break;
            
        case 1:
            _sizeIndex = row;
            break;
            
        default:
            break;
    }
    [self applyTextStyle];
}

- (BOOL)checkText
{
    NSString *text = _textView.text;
    BOOL more = [self isTextMore:text font:_textView.font];
    if (more) {

//        
//
        if (_sizeIndex > 0) {
            [self decreaseFont];
        } else {
            NSInteger count = 0;
            for (NSUInteger i = 0; i < text.length; i++) {
                NSString *subSting = [text substringToIndex:text.length - (i + 1)];
                BOOL pass = ![self isTextMore:subSting font:_textView.font];
                if (pass) {
                    count = i + 1;
                    break;
                }
            }
            _errorString = [NSString stringWithFormat:@"%@ %ld %@", NSLocalizedString(@"localized134", nil), (long)count, NSLocalizedString(@"localized135", nil)];
//            [self.view makeToast:[NSString stringWithFormat:@"%@ %ld %@", NSLocalizedString(@"localized134", nil), (long)count, NSLocalizedString(@"localized135", nil)]toastColor:[UIColor redColor]];
        }
    } else {
        _errorString = @"";
//        [self increaseFont];
    }
    NSDictionary *dic = [_fontArray objectAtIndex:_fontIndex];
    NSString *fontName = [dic.allKeys firstObject];
    if (_errorString && _errorString.length > 0) {
        [_fontItem setTintColor:kRedColor];
        _fontItem.title = [NSString stringWithFormat:@"%@", _errorString ];
    } else {
        [_fontItem setTintColor:kGreenColor];
        _fontItem.title = [NSString stringWithFormat:@"[ %@ ]", fontName ];
    }
    return [self isTextMore:text font:_textView.font];
}
- (void) decreaseFont{
    NSString *text = _textView.text;
    NSDictionary *dic = [_fontArray objectAtIndex:_fontIndex];
    while ([self isTextMore:text font:_textView.font] && _sizeIndex > 0) {
        _sizeIndex -= 1;
        
        _textView.font = [UIFont fontWithName:[dic.allKeys firstObject] size:[[_sizeArray objectAtIndex:_sizeIndex] floatValue]];
    }
    
}
- (void) increaseFont{
    NSString *text = _textView.text;
    NSDictionary *dic = [_fontArray objectAtIndex:_fontIndex];
    while (![self isTextMore:text font:_textView.font] && (_sizeIndex < [_sizeArray count] -1 )) {
        _sizeIndex += 1;
        _textView.font = [UIFont fontWithName:[dic.allKeys firstObject] size:[[_sizeArray objectAtIndex:_sizeIndex] floatValue]];
    }
    if ([self isTextMore:text font:_textView.font]) {
        [self decreaseFont];
    }
    
}
- (BOOL)isTextMore:(NSString *)string font:(UIFont *)font
{
    CGFloat height = [string getHeightOfFont:font width:CGRectGetWidth(_textContentFrame)];
    if (height > CGRectGetHeight(_textContentFrame)) {
        return YES;
    }
    return NO;
    //    return YES;
}
-(void) setTextContentFrame: (CGRect) frame {
    _textContentFrame = frame;
}
@end
