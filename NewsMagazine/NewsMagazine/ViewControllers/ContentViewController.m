//
//  ContentViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/27/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "ContentViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+HTML.h"
#import "MHHelper.h"
#import "IOSMacroFunctionHelper.h"


@interface ContentViewController (){
    CGFloat navHeight;
}
- (void) relayoutViews;

@end

@implementation ContentViewController
@synthesize article;

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
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        navHeight = 64.0f;
    }else {
        navHeight = 44.0f;
    }
    [self relayoutViews];    
}

- (void) relayoutViews {
    NSDictionary * source = [self.article objectForKey:@"source"];
    [self.sourceImage setImageWithURL:[NSURL URLWithString:[source objectForKey:@"thumbnail"]]];
    [self.sourceLabel setText:[source objectForKey:@"name"]];
    [self.pubdateLabel setText:[MHHelper getRelativeTimeWithUnixTime:[[self.article objectForKey:@"pubdate"]doubleValue] ]];
    
    [self.contentTitle setText:[[[[self.article objectForKey:@"title"]stringByDecodingHTMLEntities]stringByDecodingHTMLEntities]stringByDecodingHTMLEntities]];
    [self.contentAuthor setText:[[self.article objectForKey:@"author"]stringByDecodingHTMLEntities]];
    [self.body setText:[[[[self.article objectForKey:@"body"]stringByDecodingHTMLEntities]stringByDecodingHTMLEntities]stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"]];
    
    CGFloat y = navHeight;
    if([[self.article objectForKey:@"images"]count]>0) {
        
        NSDictionary * image = [[self.article objectForKey:@"images"]objectAtIndex:0];
        NSDictionary * iphoneSize = [[image objectForKey:@"sizes"]objectForKey:@"iphone"];
        [self.view addSubview:self.contentImage];
        if([[iphoneSize objectForKey:@"h"]floatValue]-navHeight >=[[UIScreen mainScreen]applicationFrame].size.height){
            self.contentImage.frame = CGRectMake(0,0, [[iphoneSize objectForKey:@"w"]floatValue], self.view.frame.size.height);
            
        }else{ 
        self.contentImage.frame = CGRectMake(0,y, [[iphoneSize objectForKey:@"w"]floatValue], [[iphoneSize objectForKey:@"h"]floatValue]);
        }
        y = y + [[iphoneSize objectForKey:@"h"]floatValue];
        [self.contentImage setImageWithURL:[NSURL URLWithString:[iphoneSize objectForKey:@"url"]]];
        
        self.contentImage.contentMode = UIViewContentModeScaleAspectFill;
      
        
    }else {
        [self.contentImage removeFromSuperview];
    }
    
    [self layotLabelsWithInitialY:y];
}
- (void) layotLabelsWithInitialY:(CGFloat) y  {
    CGFloat footerheight = 60.0f;
    CGFloat contentLimitY = self.view.frame.size.height - footerheight;
    self.contentTitle.frame = CGRectMake(10.0f, 0, 300, self.contentTitle.frame.size.height);
    [self.contentTitle sizeToFit];
    
    if((y + self.contentTitle.frame.size.height)  > contentLimitY) {
        self.contentTitle.textColor = [UIColor whiteColor];
        self.contentTitle.frame = CGRectMake(10.0f, 0.0f, 150.0f, 0.0f);
        self.contentTitle.font = [UIFont boldSystemFontOfSize:30.0f];
        [self.view bringSubviewToFront:self.contentTitle];
        [self.contentTitle sizeToFit];
        self.contentTitle.frame = CGRectMake(10.0f, contentLimitY-self.contentTitle.frame.size.height - 30.0f, 300, self.contentTitle.frame.size.height);
        self.contentImage.frame = CGRectMake(0, 0, self.contentImage.superview.frame.size.width, self.contentImage.superview.frame.size.height);
        [self.contentAuthor removeFromSuperview];
        [self.body removeFromSuperview];
        
        UIColor * requiredColor = [self reverseColor:[self getDominantColor:self.contentImage.image]];
        
        self.contentTitle.textAlignment = NSTextAlignmentRight;
        self.contentTitle.textColor = requiredColor;
        self.sourceLabel.textColor = requiredColor;
        self.pubdateLabel.textColor = requiredColor;
    } else{
        CGFloat totalY = y;
        totalY = totalY + 10.0f;
        self.contentTitle.frame = CGRectMake(10.0f, totalY, 300, 0);
        [self.contentTitle sizeToFit];
        totalY = totalY + self.contentTitle.frame.size.height;
        if((totalY + self.contentTitle.frame.size.height) > contentLimitY) {
                self.contentTitle.frame = CGRectMake(10.0f,  - self.contentTitle.frame.size.height + navHeight + 20.0f,  self.contentTitle.frame.size.width,  self.contentTitle.frame.size.height);
              self.contentImage.frame = CGRectMake(0, 0, self.contentImage.superview.frame.size.width,  self.contentImage.superview.frame.size.height);
            UIColor * requiredColor = [self reverseColor:[self getDominantColor:self.contentImage.image]];
            
            self.contentTitle.textAlignment = NSTextAlignmentRight;
            self.contentTitle.textColor = requiredColor;
            self.sourceLabel.textColor = requiredColor;
            self.pubdateLabel.textColor = requiredColor;
        }
        self.contentAuthor.frame = CGRectMake(10.0f, totalY, 300, 0);
        [self.contentAuthor sizeToFit];
        totalY = totalY + self.contentAuthor.frame.size.height + 5.0f;
        if((totalY + self.contentAuthor.frame.size.height) > contentLimitY) {
            [self.contentAuthor removeFromSuperview];
        }
     
        self.body.frame = CGRectMake(10.0f, totalY, 300, self.view.frame.size.height - totalY - footerheight);
        
        totalY = totalY + self.body.frame.size.height;
        if(totalY > contentLimitY) {
            [self.body removeFromSuperview];
        }
    }
    [self.view bringSubviewToFront:self.sourceContainer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentImage:nil];
    [self setContentTitle:nil];
    [self setContentAuthor:nil];
    [self setBody:nil];
    [self setDelegate:nil];
    [self setSourceImage:nil];
    [self setSourceLabel:nil];
    [self setSourceContainer:nil];
    [self setPubdateLabel:nil];
    
    [super viewDidUnload];
}
- (IBAction)didTapArticle:(UIButton *)sender {
    if(self.delegate)
        [self.delegate didTapArticle:self.article];
}

struct pixel {
    unsigned char r, g, b, a;
};

- (UIColor*) getDominantColor:(UIImage*)image
{
    NSUInteger red = 0;
    NSUInteger green = 0;
    NSUInteger blue = 0;
    
    
    // Allocate a buffer big enough to hold all the pixels
    
    struct pixel* pixels = (struct pixel*) calloc(1, image.size.width * image.size.height * sizeof(struct pixel));
    if (pixels != nil)
    {
        
        CGContextRef context = CGBitmapContextCreate(
                                                     (void*) pixels,
                                                     image.size.width,
                                                     image.size.height,
                                                     8,
                                                     image.size.width * 4,
                                                     CGImageGetColorSpace(image.CGImage),
                                                     kCGImageAlphaPremultipliedLast
                                                     );
        
        if (context != NULL)
        {
            // Draw the image in the bitmap
            
            CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);
            
            // Now that we have the image drawn in our own buffer, we can loop over the pixels to
            // process it. This simple case simply counts all pixels that have a pure red component.
            
            // There are probably more efficient and interesting ways to do this. But the important
            // part is that the pixels buffer can be read directly.
            
            NSUInteger numberOfPixels = image.size.width * image.size.height;
            for (int i=0; i<numberOfPixels; i++) {
                red += pixels[i].r;
                green += pixels[i].g;
                blue += pixels[i].b;
            }
            
            
            red /= numberOfPixels;
            green /= numberOfPixels;
            blue/= numberOfPixels;
            
            
            CGContextRelease(context);
        }
        
        free(pixels);
    }
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

- (UIColor*) reverseColor :(UIColor*) color {
    // oldColor is the UIColor to invert
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    
    UIColor *newColor = [[UIColor alloc] initWithRed:(componentColors[0] >= 0.5f?0.0f:1.0f)
                                               green:(componentColors[1] >= 0.5f?0.0f:1.0f)
                                                blue:(componentColors[2] >= 0.5f?0.0f:1.0f)
                                               alpha:componentColors[3]];
    return newColor;
}


@end
