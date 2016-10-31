/**
 * 
 */
package com.a1rdr0p.SEproject.security;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * @author lanxuan
 *
 */
public class MD5 {//MD5加密模块
	public static String convertMD5(String pw) {
		  try {  
		        MessageDigest messageDigest =MessageDigest.getInstance("MD5");  
		        byte[] inputByteArray = pw.getBytes();  
		        messageDigest.update(inputByteArray);  
		        byte[] resultByteArray = messageDigest.digest();  
		        return byteArrayToHex(resultByteArray);  
		     } catch (NoSuchAlgorithmException e) {  
		        return null;  
		     }  
		 }
		    public static String byteArrayToHex(byte[] byteArray) {  
		        char[] hexDigits = {'0','1','2','3','4','5','6','7','8','9', 'A','B','C','D','E','F' };   
		        char[] resultCharArray =new char[byteArray.length * 2];  
		        int index = 0; 
		        for (byte b : byteArray) {  
		           resultCharArray[index++] = hexDigits[b>>> 4 & 0xf];  
		           resultCharArray[index++] = hexDigits[b& 0xf];  
		        }
		        return new String(resultCharArray);  
		    }
}
