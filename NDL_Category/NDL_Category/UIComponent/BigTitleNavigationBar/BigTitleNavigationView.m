//
//  BigTitleNavigationView.m
//  NDL_Category
//
//  Created by dzcx on 2018/6/29.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import "BigTitleNavigationView.h"

@interface BigTitleNavigationView ()

// containerView
@property (nonatomic, strong) UIView *navBarContainerView;
@property (nonatomic, strong) UIView *bottomContainerView;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UILabel *bigTitleLabel;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation BigTitleNavigationView

#pragma mark - Lazy Load
// button没有设置title titleLabel也被创建了hidden=YES
// leftButton
- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(leftButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarContainerView addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBarContainerView).offset(StatusBarH);
            make.left.equalTo(self.navBarContainerView);
            make.width.mas_equalTo(kNavBackButtonWidth);
            make.height.mas_equalTo(NavigationBarH);
        }];
    }
    return _leftButton;
}

// rightButton 右边可能会有很长的title
- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        /*
         _rightButton.backgroundColor = [UIColor yellowColor];
         _rightButton.titleLabel.backgroundColor = [UIColor redColor];
         _rightButton.imageView.backgroundColor = [UIColor cyanColor];
         */
        [_rightButton addTarget:self action:@selector(rightButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarContainerView addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBarContainerView).offset(StatusBarH);
            make.right.equalTo(self.navBarContainerView).offset(-kNavBigTitleLeadingToLeftEdge);
            //         make.width.mas_equalTo(kNavBackButtonWidth);// 不设置width,宽度包裹
            make.height.mas_equalTo(NavigationBarH);
        }];
    }
    return _rightButton;
}

// bigTitleLabel
- (UILabel *)bigTitleLabel
{
    if (!_bigTitleLabel) {
        // bigTitleLabel统一样式
        _bigTitleLabel = [[UILabel alloc] init];
        _bigTitleLabel.textColor = BigTitleTextColor;
        _bigTitleLabel.font = BigTitleFont;
        _bigTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.bottomContainerView addSubview:_bigTitleLabel];
        [_bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomContainerView);
            make.left.equalTo(self.bottomContainerView).offset(kNavBigTitleLeadingToLeftEdge);
            make.right.equalTo(self.bottomContainerView).offset(-kNavBigTitleLeadingToLeftEdge);
            make.height.mas_equalTo(kNavBigTitleHeight);
        }];
    }
    return _bigTitleLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        // textField rightView
        UIButton *textFieldRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        textFieldRightBtn.bounds = CGRectMake(0, 0, 20, 20);
        [textFieldRightBtn setImage:[UIImage imageNamed:@"common_textFieldRightViewImage_12x12"] forState:UIControlStateNormal];
        [textFieldRightBtn addTarget:self action:@selector(textFieldRightButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        
        // textField
        _textField = [[UITextField alloc] init];
        //      _textField.backgroundColor = [UIColor cyanColor];
        _textField.textColor = BigTitleTextColor;
        _textField.font = TextFieldBigTitleFont;
        _textField.tintColor = TextFieldCursorColor;
        //      _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //      _textField.clearsOnBeginEditing = YES;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.rightView = textFieldRightBtn;
        _textField.rightViewMode = UITextFieldViewModeWhileEditing;
        [self.bottomContainerView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomContainerView).offset(kNavBigTitleLeadingToLeftEdge);
            make.center.equalTo(self.bottomContainerView);
        }];
    }
    return _textField;
}

// lineView
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromHex(0xC8C8C8);
        [self addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _lineView;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self _setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // IBInspectable设置了 这边有值
    NSLog(@"awakeFromNib navBarBackgroundColor = %@", self.navBarBackgroundColor);
}

#pragma mark - Overrides
// 拦截触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"view touchesBegan");
}

#pragma mark - Private Methods
- (void)_setupUI
{
    // IBInspectable设置了 这边为null
    NSLog(@"_setupUI navBarBackgroundColor = %@", self.navBarBackgroundColor);
    
    // navBarContainerView
    self.navBarContainerView = [[UIView alloc] init];
    //   self.navBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.navBarContainerView];
    [self.navBarContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(TopExtendedLayoutH);
    }];
    
    // bottomContainerView
    self.bottomContainerView = [[UIView alloc] init];
    //   self.bottomContainerView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.bottomContainerView];
    [self.bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBarContainerView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}

#pragma mark - UIButton Actions
- (void)leftButtonDidClicked
{
    if (self.leftButtonBlock) {
        self.leftButtonBlock();
    }
}

- (void)rightButtonDidClicked
{
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
}

- (void)textFieldRightButtonDidClicked
{
    self.textField.text = @"";
    
    if (self.textFieldRightButtonBlock) {
        self.textFieldRightButtonBlock();
    }
}

#pragma mark - Setter
- (void)setNavBarBackgroundColor:(UIColor *)navBarBackgroundColor
{
    _navBarBackgroundColor = navBarBackgroundColor;
    self.navBarContainerView.backgroundColor = navBarBackgroundColor;
}

- (void)setBigTitleStr:(NSString *)bigTitleStr
{
    _bigTitleStr = [bigTitleStr copy];
    self.bigTitleLabel.text = bigTitleStr;
}

- (void)setPlaceHolderStr:(NSString *)placeHolderStr
{
    _placeHolderStr = placeHolderStr;
    self.textField.placeholder = placeHolderStr;
}

- (void)setLineViewShowFlag:(BOOL)lineViewShowFlag
{
    _lineViewShowFlag = lineViewShowFlag;
    [self.lineView setHidden:!lineViewShowFlag];
}

// left
// @"common_navBack_18x18"
- (void)setLeftButtonImage:(UIImage *)leftButtonImage
{
    NSLog(@"setLeftButtonImage");// IBInspectable设置了 会走这边setter 然后走awakeFromNib
    _leftButtonImage = leftButtonImage;
    [self.leftButton setImage:leftButtonImage forState:UIControlStateNormal];
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle
{
    _leftButtonTitle = [leftButtonTitle copy];
    [self.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
}

// right
- (void)setRightButtonImage:(UIImage *)rightButtonImage
{
    _rightButtonImage = rightButtonImage;
    [self.rightButton setImage:rightButtonImage forState:UIControlStateNormal];
    [self.rightButton setImage:rightButtonImage forState:UIControlStateHighlighted];
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle
{
    _rightButtonTitle = [rightButtonTitle copy];
    [self.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
}

- (void)setRightButtonTitleColor:(UIColor *)rightButtonTitleColor
{
    _rightButtonTitleColor = rightButtonTitleColor;
    [self.rightButton setTitleColor:rightButtonTitleColor forState:UIControlStateNormal];
}

@end
