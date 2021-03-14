#import <UIKit/UIKit.h>

@interface TVSViewController : UIViewController
- (IBAction)track:(id)sender;
- (IBAction)trackUser:(id)sender;
- (IBAction)trackAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt_userid;
@property (weak, nonatomic) IBOutlet UITextField *txt_actionname;
@property (weak, nonatomic) IBOutlet UITextField *txt_product;
@property (weak, nonatomic) IBOutlet UITextField *txt_orderid;
@property (weak, nonatomic) IBOutlet UITextField *txt_revenue;
@property (weak, nonatomic) IBOutlet UITextField *txt_promocode;
@end
