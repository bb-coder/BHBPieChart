//
//  BHBPieChart.m
//  BHBPieChart
//
//  Created by bihongbo on 16/2/22.
//  Copyright © 2016年 bihongbo. All rights reserved.
//

#import "BHBPieChart.h"

@interface BHBPieChart ()

@property (nonatomic,strong) CAShapeLayer   * backLine;

@property (nonatomic,assign) CGFloat        radius;

@property (nonatomic,strong) NSMutableArray *lines;

@property (nonatomic,strong) NSMutableArray *lineAngles;

@property (nonatomic,assign) CGFloat        totalNumber;

@property (nonatomic,strong) CADisplayLink  * cal;

@property (nonatomic,strong) CGFloat        displayCount;

@end

@implementation BHBPieChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lines = [NSMutableArray array];
        self.lineAngles = [NSMutableArray array];
        self.numbersArray = [NSArray array];
        self.colorsArray = [NSArray array];
        self.lineWidth = 30;
        self.radius = self.frame.size.width / 2 - self.lineWidth / 2;
        self.linespace = 2;
        NSLog(@"%@",NSStringFromCGRect(self.layer.frame));
        self.backLine = [self addLineWithStartAngle:-M_PI_2 andEndAngle:-M_PI_2 andColor:[UIColor grayColor]];
        [self.layer addSublayer:self.backLine];
        
        
    
        
    }
    return self;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setColorsArray:@[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]]];
    [self setNumbersArray:@[@(arc4random() % 1000),@(arc4random() % 1000),@(arc4random() % 1000)]];
}

- (void)setNumbersArray:(NSArray *)numbersArray{
    _numbersArray = numbersArray;
    if (self.numbersArray.count > 0) {
        self.backLine.hidden = YES;
    }else{
        self.backLine.hidden = NO;
    }
    [self showLineAnimation];
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
        if (i < colorsArray.count) {
            sl.strokeColor = [colorsArray[i] CGColor];
        }else{
            sl.strokeColor = [UIColor grayColor].CGColor;
        }
    }
}

- (CAShapeLayer *)addLineWithStartAngle:(CGFloat)start andEndAngle:(CGFloat)end andColor:(UIColor *)lineColor{
    CAShapeLayer * sl = [CAShapeLayer layer];
    sl.path = [self pathWithStartAngle:start andEndAngle:end];
    sl.fillColor = [UIColor clearColor].CGColor;
    sl.strokeColor = lineColor.CGColor;
    sl.lineWidth = self.lineWidth;
    sl.frame = self.layer.bounds;
    NSLog(@"%@",NSStringFromCGRect(sl.frame));
    return sl;
}

- (CGPathRef)pathWithStartAngle:(CGFloat)start andEndAngle:(CGFloat)end{
    CGFloat lineSpaceArc = asin((self.linespace / 2)/self.radius) * 2;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.radius startAngle:start + lineSpaceArc endAngle:end - lineSpaceArc clockwise:YES];
    return path.CGPath;
}

- (void)showLineAnimation{
    self.cal = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawRect)];
    [self.cal addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)drawRect{
    self.totalNumber = 0;
    [self.lineAngles removeAllObjects];
    [self.lineAngles addObject:@(-M_PI_2)];
    for (int i = 0; i < self.numbersArray.count; i ++) {
        self.totalNumber += [self.numbersArray[i] floatValue];
    }
    
    for (int i = 0; i < self.numbersArray.count; i ++) {
        [self.lineAngles addObject:@(([self.numbersArray[i] floatValue] / self.totalNumber) * 2 * M_PI + [self.lineAngles[i] floatValue])];
    }
    NSLog(@"%@",self.lineAngles);
    
    for (int i = 0; i < self.lineAngles.count - 1; i ++) {
        CAShapeLayer * sl;
        if (self.lines.count > i) {
            sl = self.lines[i];
            [self addLayerReplaceLineAnimation:sl andPath:[self pathWithStartAngle:[self.lineAngles[i] floatValue] andEndAngle:[self.lineAngles[i+1] floatValue]]];
        }else{
            if(i < self.colorsArray.count){
                sl = [self addLineWithStartAngle:[self.lineAngles[i] floatValue] andEndAngle:[self.lineAngles[i+1] floatValue] andColor:self.colorsArray[i]];
                [self.layer addSublayer:sl];
                [self.lines addObject:sl];
            }else{
                sl = [self addLineWithStartAngle:[self.lineAngles[i] floatValue] andEndAngle:[self.lineAngles[i+1] floatValue] andColor:[UIColor grayColor]];
                [self.layer addSublayer:sl];
                [self.lines addObject:sl];
            }
        }
    }

}

- (void)addLayerReplaceLineAnimation:(CAShapeLayer *)layer andPath:(CGPathRef)path{
    layer.path = path;
}

@end
