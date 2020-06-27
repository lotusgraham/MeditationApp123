#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Postal address for 3D Secure flows
 */
@interface BTThreeDSecurePostalAddress : NSObject <NSCopying>

/**
 Optional. Given name associated with the address
 */
@property (nonatomic, nullable, copy) NSString *givenName;

/**
 Optional. Surname associated with the address
 */
@property (nonatomic, nullable, copy) NSString *surname;

/**
 Optional. Line 1 of the Address (eg. number, street, etc)
 */
@property (nonatomic, nullable, copy) NSString *streetAddress;

/**
 Optional. Line 2 of the Address (eg. suite, apt #, etc.)
 */
@property (nonatomic, nullable, copy) NSString *extendedAddress;

/**
 Optional. Line 3 of the Address (eg. suite, apt #, etc.)
 */
@property (nonatomic, nullable, copy) NSString *line3;

/**
 Optional. City name
 */
@property (nonatomic, nullable, copy) NSString *locality;

/**
 Optional. 2 letter code for US states, and the equivalent for other countries
 */
@property (nonatomic, nullable, copy) NSString *region;

/**
 Optional. Zip code or equivalent is usually required for countries that have them. For a list of countries that do not have postal codes please refer to http://en.wikipedia.org/wiki/Postal_code
 */
@property (nonatomic, nullable, copy) NSString *postalCode;

/**
 Optional. 2 letter country code
 */
@property (nonatomic, nullable, copy) NSString *countryCodeAlpha2;

/**
 Optional. The phone number associated with the address
 @note Only numbers. Remove dashes, parentheses and other characters
 */
@property (nonatomic, nullable, copy) NSString *phoneNumber;

/**
 
 Optional. First name associated with the address
 */
@property (nonatomic, nullable, copy) NSString *firstName DEPRECATED_MSG_ATTRIBUTE("Use givenName instead.");

/**
 Optional. Last name associated with the address
 */
@property (nonatomic, nullable, copy) NSString *lastName DEPRECATED_MSG_ATTRIBUTE("Use surname instead.");

@end

NS_ASSUME_NONNULL_END

