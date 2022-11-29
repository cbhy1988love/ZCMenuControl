//
//  TYDefineConst.h
//  TestMenuControl
//
//  Created by cai on 2022/11/29.
//

#ifndef TYDefineConst_h
#define TYDefineConst_h

#define kAppWindow                  [UIApplication sharedApplication].delegate.window
#define SCREENWIDTH                 [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT                [[UIScreen mainScreen] bounds].size.height
#define is_iPhoneX                  (SCREENHEIGHT/SCREENWIDTH > 2.0 ? YES : NO)
#define kLineHeight                 (1.0/[UIScreen mainScreen].scale)

#define kBottomSafeAreaHeight       (is_iPhoneX ? 34: 0) //安全区域高度


#define kColor(x)                   [UIColor colorWithHexString:x]
#define kColorA(x, a)               (([(UIColor *)x isKindOfClass:UIColor.class]) ? ([(UIColor *)x colorWithAlphaComponent:a]) : ([[UIColor colorWithHexString:(NSString *)x] colorWithAlphaComponent:a]))



#endif /* TYDefineConst_h */
