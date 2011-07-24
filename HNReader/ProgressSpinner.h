//
//  ProgressSpinner.h

#import <UIKit/UIKit.h>

/////////////////////////////////////////////////////////////////////////////////////////////

typedef enum {
    /** Progress is shown using an UIActivityIndicatorView. This is the default. */
    ProgressSpinnerModeIndeterminate,
    /** Progress is shown using a MBRoundProgressView. */
	ProgressSpinnerModeDeterminate,
	/** Shows a custom view */
	ProgressSpinnerModeCustomView
} ProgressSpinnerMode;

typedef enum {
    /** Opacity animation */
    ProgressSpinnerAnimationFade,
    /** Opacity + scale animation */
    ProgressSpinnerAnimationZoom
} ProgressSpinnerAnimation;

/////////////////////////////////////////////////////////////////////////////////////////////

@class ProgressSpinner;

/////////////////////////////////////////////////////////////////////////////////////////////

@interface PSRoundProgressView : UIProgressView {}

- (id)initWithDefaultSize;

@end

/////////////////////////////////////////////////////////////////////////////////////////////

@interface ProgressSpinner : UIView {
	
	ProgressSpinnerMode mode;
    ProgressSpinnerAnimation animationType;
	
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	BOOL useAnimation;
	
    float yOffset;
    float xOffset;
	
	float width;
	float height;
	
	BOOL taskInProgress;
	float autoStopValue;
	float minShowTime;
	NSTimer *autoStopTimer;
	NSTimer *minShowTimer;
	NSDate *showStarted;
	
	UIView *indicator;
	UILabel *label;
	UILabel *detailsLabel;
	
	float progress;
	
	NSString *labelText;
	NSString *detailsLabelText;
	float opacity;
	UIFont *labelFont;
	UIFont *detailsLabelFont;
	
    BOOL isFinished;
	BOOL removeFromSuperViewOnHide;
	
	UIView *customView;
	
	CGAffineTransform rotationTransform;
}

+ (ProgressSpinner *)showProgressSpinnerAddedTo:(UIView *)view animated:(BOOL)animated;

+ (BOOL)hideProgressSpinnerForView:(UIView *)view animated:(BOOL)animated;

- (id)initWithWindow:(UIWindow *)window;

- (id)initWithView:(UIView *)view;

@property (retain) UIView *customView;

@property (assign) ProgressSpinnerMode mode;

@property (assign) ProgressSpinnerAnimation animationType;

@property (copy) NSString *labelText;

@property (copy) NSString *detailsLabelText;

@property (assign) float opacity;

@property (assign) float xOffset;

@property (assign) float yOffset;

@property (assign) float autoStopValue;


@property (assign) float minShowTime;

@property (assign) BOOL taskInProgress;

@property (assign) BOOL removeFromSuperViewOnHide;

@property (retain) UIFont* labelFont;

@property (retain) UIFont* detailsLabelFont;

@property (assign) float progress;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

@end
