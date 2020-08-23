#import "TraceAESenAndDe.h"
#import "TraceFBEncryptorAES.h"
//#import "GTMBase64.h"

#define kKey @"XYDeviceInfoRangwoguoba"

@implementation TraceAESenAndDe


/*!
 *  加密以后再 base64 转成字符串
 *
 *  @param str 需要加密的字符串
 *
 *  @return NSData数据
 */
+(NSData *)En_AESandBase64ToData:(NSString *)str
{
    NSData *data_aes = [TraceFBEncryptorAES encryptData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                               key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString* encodeResult = [data_aes base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return [[NSString stringWithFormat:@"%@",encodeResult] dataUsingEncoding:NSUTF8StringEncoding];
}

/*!
 *  加密以后再 base64 转成字符串
 *
 *  @param str 需要加密的字符串
 *
 *  @return NSString数据
 */
+(NSString *)En_AESandBase64EnToString:(NSString *)str
{
    NSData *data_aes = [TraceFBEncryptorAES encryptData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                               key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString* encodeResult = [data_aes base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return [NSString stringWithFormat:@"%@",encodeResult];

}


/* 以上为加密
 =================================== ===================================
 =================================== ===================================
  以下为解密*/

/*!
 *  base64 转换以后解密
 *
 *  @param str 需要解密的 base64字符串
 *
 *  @return 解密后字符串
 */
+(NSString *)De_Base64andAESDeToString:(NSString *)str
{
    
    NSData *data_dec = [TraceFBEncryptorAES decryptData:[[NSData alloc] initWithBase64EncodedString:str options:0]
                                               key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];

    return [[NSString alloc]initWithData:data_dec encoding:NSUTF8StringEncoding];
    
}

/*!
 *  base64 转换以后解密
 *
 *  @param str 需要解密的 base64字符串
 *
 *  @return 解密后NSData
 */
+(NSData *)De_Base64andAESToData:(NSString *)str
{
    return [TraceFBEncryptorAES decryptData:[[NSData alloc] initWithBase64EncodedString:str options:0]
                                   key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
}

/*!
 *  base64 转换以后解密
 *
 *  @param str 需要解密的 base64字符串
 *
 *  @return 解密后字典
 */
+(NSDictionary *)De_Base64andAESToDictionary:(NSString *)str
{
    NSData *data_dec = [TraceFBEncryptorAES decryptData:[[NSData alloc] initWithBase64EncodedString:str options:0]
                                               key:[kKey dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSString *str_dec = [[NSString alloc]initWithData:data_dec encoding:NSUTF8StringEncoding];
    if (!str_dec) {
        return nil;
    }

    NSDictionary *jsonObjects = nil;// [[NSDictionary alloc]init];
    NSError *e = nil;

    jsonObjects = [NSJSONSerialization JSONObjectWithData: [str_dec dataUsingEncoding:NSUTF8StringEncoding]
                                                  options: NSJSONReadingMutableContainers
                                                    error: &e];

    if (e) {
        return  nil;
    }

    return jsonObjects;
    
}

@end
