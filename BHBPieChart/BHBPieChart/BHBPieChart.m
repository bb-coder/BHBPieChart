//
//  BHBPieChart.m
//  BHBPieChart
//
//  Created by bihongbo on 16/2/22.
//  Copyright © 2016年 bihongbo. All rights reserved.
//

#import "BHBPieChart.h"

@interface BHBPieChart ()

@property (nonatomic,assign) CGFloat        radius;

@property (nonatomic,strong) NSMutableArray *lines;

@property (nonatomic,strong) NSMutableArray *lineAngles;

@property (nonatomic,strong) CADisplayLink * caLink;

@property (nonatomic,strong) NSArray       *startAnimationValues;

@property (nonatomic,assign) NSInteger     animationDurationInteval;

@property (nonatomic,strong) NSArray       *oldNumbers;

@end

@implementation BHBPieChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lines = [NSMutableArray array];
        _lineAngles = [NSMutableArray array];
        _numbersArray = [NSArray array];
        _colorsArray = [NSArray array];
        _allowAnimation = YES;
        _lineWidth = 30;
        _startAngle = -M_PI_2;
        _endAngle = 3 * M_PI_2;
        _animationDuration = 0.8;
        _animationDurationInteval = 0;
        _radius = self.frame.size.width / 2 - self.lineWidth / 2;
        _linespace = 2;
        _startAnimationValues = [BHBPieChart animationEasyInOutValuesDuration:_animationDuration];
        NSLog(@"%@",NSStringFromCGRect(self.layer.frame));
        
        
        
    }
    return self;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.animationType = kPieAnimationTypeChangeValue;
    self.linespace = 0;
    [self setColorsArray:@[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]]];
    [self setNumbersArray:@[@(0.5),@(0.5),@(0.5)]];
}

- (void)setNumbersArray:(NSArray *)numbersArray{
    NSMutableArray * tempArray = [NSMutableArray array];
    NSMutableArray * tempColorArray = [NSMutableArray arrayWithArray:self.colorsArray];
    for (int i = 0; i < numbersArray.count; i++){
        NSNumber * num = numbersArray[i];
        if (num.floatValue != 0) {
            [tempArray addObject:num];
        }else{
            if(i < tempColorArray.count)
            [tempColorArray removeObjectAtIndex:i];
        }
    }
    numbersArray = [tempArray copy];
    self.colorsArray = [tempColorArray copy];
    self.oldNumbers = _numbersArray;
    _numbersArray = numbersArray;
    [self.caLink invalidate];
    self.caLink = nil;
    self.animationDurationInteval = 0;
    if(self.animationType == kPieAnimationTypeLiner)
    [self.lines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    for (int i = 0; i < numbersArray.count; i ++) {
        CAShapeLayer * sl;
        if (self.lines.count > i) {
            sl = self.lines[i];
            [self.layer addSublayer:sl];
            
        }else{
            if(i < self.colorsArray.count){
                sl = [self addLineWithColor:self.colorsArray[i]];
                [self.layer addSublayer:sl];
                [self.lines addObject:sl];
            }else{
                sl = [self addLineWithColor:[UIColor grayColor]];
                [self.layer addSublayer:sl];
                [self.lines addObject:sl];
            }
        }
    }
    if (self.allowAnimation) {
        if(self.animationType == kPieAnimationTypeLiner){
            [self startLinerAnimation];
        }else if(self.animationType == kPieAnimationTypeChangeValue){
            [self startChangeValueAnimation];
        }
        
    }else{
        [self linerAnimation];
    }
    
}

- (void)addNumber:(NSNumber *)number{
    self.numbersArray = [self.numbersArray arrayByAddingObject:number];
}

- (void)addColor:(UIColor *)color{
    self.colorsArray = [self.colorsArray arrayByAddingObject:color];
}

- (void)setColorsArray:(NSArray *)colorsArray{
    _colorsArray = colorsArray;
    for (int i = 0; i < self.lines.count; i ++) {
        CAShapeLayer * sl = self.lines[i];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (i < colorsArray.count) {
            sl.strokeColor = [colorsArray[i] CGColor];
        }else{
            sl.strokeColor = [UIColor grayColor].CGColor;
        }
        [CATransaction commit];
    }
}

- (CAShapeLayer *)addLineWithColor:(UIColor *)lineColor{
    CAShapeLayer * sl = [CAShapeLayer layer];
    sl.frame = self.layer.bounds;
    sl.lineWidth = self.lineWidth;
    sl.fillColor = [UIColor clearColor].CGColor;
    sl.strokeColor = lineColor.CGColor;
    return sl;
}

#pragma mark animation

- (void)startChangeValueAnimation{
    if (self.oldNumbers.count <= 0) {
        [self startLinerAnimation];
    }else{
        self.caLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(ChangeValueAnimation)];
        [self.caLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
}
- (void)startLinerAnimation{
    self.caLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(linerAnimation)];
    [self.caLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)ChangeValueAnimation{
    if (self.animationDurationInteval >= self.animationDuration * 60) {
        [self.caLink invalidate];
        self.caLink = nil;
        self.animationDurationInteval = 0;
        return;
    }
    CGFloat rate = [self.startAnimationValues[self.animationDurationInteval] floatValue];
    if (rate + 0.01 >= 1) {
        rate = 1;
    }
    if (!self.allowAnimation) {
        self.animationDurationInteval = 0;
        rate = 1;
    }
    NSMutableArray * numbersArray = [NSMutableArray array];
    int i;
    for (i = 0; i < self.oldNumbers.count; i ++) {
        if (i < self.numbersArray.count) {
            [numbersArray addObject:@(([self.numbersArray[i] floatValue] - [self.oldNumbers[i] floatValue]) * rate + [self.oldNumbers[i] floatValue])];
        }else{
            [numbersArray addObject:@((0 - [self.oldNumbers[i] floatValue]) * rate + [self.oldNumbers[i] floatValue])];
        }
    }
    if(i < self.numbersArray.count){
    for (; i < self.numbersArray.count; i ++) {
        CAShapeLayer * sl = [self addLineWithColor:self.colorsArray[i]];
        [self.lines addObject:sl];
        [self.layer addSublayer:sl];
        [numbersArray addObject:@([self.numbersArray[i] floatValue] * rate)];
    }
    }
    
    NSMutableArray * tempArray = [NSMutableArray array];
    NSMutableArray * tempColorArray = [NSMutableArray arrayWithArray:self.colorsArray];
    for (int i = 0; i < numbersArray.count; i++){
        NSNumber * num = numbersArray[i];
        if (num.floatValue != 0) {
            [tempArray addObject:num];
        }else{
            if(i < tempColorArray.count)
            [tempColorArray removeObjectAtIndex:i];
        }
    }
    numbersArray = [tempArray copy];
    self.colorsArray = [tempColorArray copy];
    [self drawPieWithEndAnlge:self.endAngle andNumber:numbersArray];
    self.animationDurationInteval ++;
}

- (void)linerAnimation{
    if (self.animationDurationInteval >= self.animationDuration * 60) {
        [self.caLink invalidate];
        self.caLink = nil;
        self.animationDurationInteval = 0;
        return;
    }
    CGFloat rate = [self.startAnimationValues[self.animationDurationInteval] floatValue];
    if (rate + 0.01 >= 1) {
        rate = 1;
    }
    if (!self.allowAnimation) {
        self.animationDurationInteval = 0;
        rate = 1;
    }
    CGFloat endAngle = self.startAngle + (self.endAngle - self.startAngle) * rate;
    [self drawPieWithEndAnlge:endAngle andNumber:self.numbersArray];
    self.animationDurationInteval ++;
}

- (void)drawPieWithEndAnlge:(CGFloat)endAngle andNumber:(NSArray *)numbersArray{
    
    NSLog(@"%@ st:%f en:%f",numbersArray,self.startAngle,endAngle);
    CGFloat total = [[numbersArray valueForKeyPath:@"@sum.floatValue"] floatValue];
    if (total == 0) {
        return;
    }
    CGFloat linespaceAngle = 2 * asinf((self.linespace / 2) / self.radius);
    [self.lineAngles removeAllObjects];
    [self.lineAngles addObject:@(self.startAngle)];
    if (endAngle - self.startAngle < numbersArray.count * linespaceAngle) {
        return;
    }
    for (int i = 0; i < numbersArray.count; i ++) {
        [self.lineAngles addObject:@(([numbersArray[i] floatValue] / total) * (endAngle - self.startAngle - numbersArray.count *  linespaceAngle) + [self.lineAngles[i] floatValue])];
    }
    for (int i = 0; i < numbersArray.count; i ++) {
        CAShapeLayer * sl = self.lines[i];
        CGFloat layerStartAngle = [self.lineAngles[i] floatValue] + (i + 1)  * linespaceAngle;
        CGFloat layerEndAngle = [self.lineAngles[i + 1] floatValue] + (i + 1)  * linespaceAngle;
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.radius startAngle:layerStartAngle endAngle:layerEndAngle clockwise:YES];
        sl.path = path.CGPath;
    }
}

+(NSMutableArray *) animationEasyInOutValuesDuration:(CGFloat)duration{
    
    NSInteger numOfPoints  = duration * 60;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:numOfPoints];
    for (NSInteger i = 0; i < numOfPoints; i++) {
        [values addObject:@(0.0)];
    }
    for (NSInteger point = 0; point<numOfPoints; point++) {
        
        CGFloat x = (CGFloat)point / (CGFloat)numOfPoints;
        CGFloat value = 1/(1+powf(M_E, (0.5-x)*12));
        
        values[point] = @(value);
    }
    return values;
}

-(void)dealloc{
    [_caLink invalidate];
    _caLink = nil;
}

@end
