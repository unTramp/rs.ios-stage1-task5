#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    
    NSDictionary* countryNumberLenght = @{@"RU":@10,
                                          @"KZ":@10,
                                          @"MD":@8,
                                          @"AM":@8,
                                          @"BY":@9,
                                          @"UA":@9,
                                          @"TJ":@9,
                                          @"TM":@8,
                                          @"AZ":@9,
                                          @"KG":@9,
                                          @"UZ":@9};
    
    NSDictionary* countryCode = @{@"7":@"RU",
                                  @"7":@"KZ",
                                  @"373":@"MD",
                                  @"374": @"AM",
                                  @"375": @"BY",
                                  @"380": @"UA",
                                  @"992": @"TJ",
                                  @"993": @"TM",
                                  @"994": @"AZ",
                                  @"996": @"KG",
                                  @"998": @"UZ"};
    
    NSDictionary* numsAreaCode = @{@"RU":@3,
                                   @"KZ":@3,
                                   @"MD":@2,
                                   @"AM":@2,
                                   @"BY":@2,
                                   @"UA":@2,
                                   @"TJ":@2,
                                   @"TM":@2,
                                   @"AZ":@2,
                                   @"KG":@2,
                                   @"UZ":@2};
    
    NSMutableString* inputNumber = [NSMutableString stringWithString:string];
    
    NSMutableString* areaCode = [NSMutableString string];
    NSInteger numberLenght = 0;
    NSString* myCode = @"";
    NSString* keyCountry = @"KZ";
    
    inputNumber = [self removePlus:inputNumber];
    inputNumber = [self cutSymbolsOveTwelve:inputNumber];


    for (NSString* code in countryCode) {
        if ([inputNumber hasPrefix:code]) {
            myCode = code;
            [inputNumber deleteCharactersInRange:NSMakeRange(0, [code length])];
            numberLenght = [countryNumberLenght[countryCode[myCode]] integerValue];
            break;
        }
    }
    
    
    if ([myCode isEqualToString:@""]) {
        inputNumber = [self cutSymbolsOveTwelve:inputNumber];
        string = [NSString stringWithFormat:@"+%@", inputNumber];
        return @{KeyPhoneNumber: string, KeyCountry: @""};
    }
    
    if ([inputNumber length] == 0) {
        NSString* result = [NSString stringWithFormat:@"+%@", myCode];
        return @{KeyPhoneNumber: result, KeyCountry: countryCode[myCode]};
    }
    
    if ([inputNumber length] <= [numsAreaCode[countryCode[myCode]] integerValue]) {
        NSString* result = [NSString stringWithFormat:@"+%@ (%@",myCode, inputNumber];
        if ([self isKZ:string] == true) {
            return @{KeyPhoneNumber: result, KeyCountry: keyCountry};
        }
        return @{KeyPhoneNumber: result, KeyCountry: countryCode[myCode]};
    } else {
        if ([numsAreaCode[countryCode[myCode]] integerValue] <= [inputNumber length]) {
            NSRange myRange = NSMakeRange(0, [numsAreaCode[countryCode[myCode]] integerValue]);
            NSString* subString = [inputNumber substringWithRange:myRange];
            [inputNumber deleteCharactersInRange:myRange];
            areaCode = [NSMutableString stringWithFormat:@"(%@)", subString];
        }
        NSInteger clearLocalNum = numberLenght - [numsAreaCode[countryCode[myCode]] integerValue];
        if ([inputNumber length] > clearLocalNum) {
            NSString* subString = [inputNumber substringToIndex:clearLocalNum];
            inputNumber = [NSMutableString stringWithString:subString];
        }
        
        if (numberLenght == 8) {
            if ([inputNumber length] > 3) {
                [inputNumber insertString:@"-" atIndex:3];
            } else {
                NSString* result = [NSString stringWithFormat:@"+%@ %@ %@", myCode, areaCode, inputNumber];
                result = [result substringToIndex: [result length]];
                if ([self isKZ:string] == true) {
                    return @{KeyPhoneNumber: result, KeyCountry: keyCountry};
                }
                return @{KeyPhoneNumber: result, KeyCountry: countryCode[myCode]};
            }
        } else {
            if ([inputNumber length] > 3) {
                [inputNumber insertString:@"-" atIndex:3];
            } else {
                NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",myCode, areaCode, inputNumber];
                if ([self isKZ:string] == true) {
                    return @{KeyPhoneNumber: result, KeyCountry: keyCountry};
                }
                return @{KeyPhoneNumber: result, KeyCountry: countryCode[myCode]};
            }
            
            if ([inputNumber length] > 6) {
                [inputNumber insertString:@"-" atIndex:6];
            } else {
                NSString* result = [NSString stringWithFormat:@"+%@ %@ %@", myCode, areaCode, inputNumber];
                if ([self isKZ:string] == true) {
                    return @{KeyPhoneNumber: result, KeyCountry: keyCountry};
                }
                return @{KeyPhoneNumber: result, KeyCountry: countryCode[myCode]};
            }
        }

        NSString* result = [NSString stringWithFormat:@"+%@ %@ %@",myCode, areaCode, inputNumber];
        if ([self isKZ:string] == true) {
            return @{KeyPhoneNumber: result, KeyCountry: keyCountry};
        }
        return @{KeyPhoneNumber: result, KeyCountry: countryCode[myCode]};
    }
}



- (NSMutableString*)removePlus:(NSMutableString*)inputNumber{
    NSString* plusChar = [inputNumber substringWithRange:NSMakeRange(0, 1)];
    if ([plusChar isEqualToString:@"+"]) {
        [inputNumber deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return inputNumber;
}


- (NSMutableString*)cutSymbolsOveTwelve:(NSMutableString*)inputNumber{
    if ([inputNumber length] > 12) {
        NSString* completeString = [inputNumber substringToIndex:12];
        inputNumber = [NSMutableString stringWithString:completeString];
    }
    return inputNumber;
}

- (BOOL)isKZ:(NSString*)string{
    if ([string hasPrefix:@"77"]){
        return true;
    }
    return false;
}


@end
