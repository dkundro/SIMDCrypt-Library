package testGenerator;

import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.Security;
import java.util.Random;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.ShortBufferException;
import javax.crypto.spec.SecretKeySpec;

import org.bouncycastle.crypto.CryptoException;
import org.bouncycastle.crypto.engines.BlowfishEngine;
import org.bouncycastle.crypto.paddings.PaddedBufferedBlockCipher;
import org.bouncycastle.crypto.params.KeyParameter;
import org.bouncycastle.jcajce.provider.digest.SHA3;
import org.bouncycastle.util.encoders.Base64;
import org.bouncycastle.util.encoders.Hex;

public class testGenerator {

	public static void main(String[] args) throws FileNotFoundException, UnsupportedEncodingException,
	InvalidKeyException, NumberFormatException, NoSuchAlgorithmException, NoSuchProviderException,
	NoSuchPaddingException, ShortBufferException, IllegalBlockSizeException, BadPaddingException {
		generateTestFile("Input//MD5-Input", Integer.parseInt(args[0]));
		generateTestFile("Input//SHA1-Input", Integer.parseInt(args[0]));
		generateTestFile("Input//SHA224-Input", Integer.parseInt(args[0]));
		generateTestFile("Input//SHA256-Input", Integer.parseInt(args[0]));
		generateTestFile("Input//SHA384-Input", Integer.parseInt(args[0]));
		generateTestFile("Input//SHA512-Input", Integer.parseInt(args[0]));
		generateTestFile("Input//SHA3_224-Input", Integer.parseInt(args[0]));
		generateTestFile("Input//SHA3_256-Input", Integer.parseInt(args[0]));
		generateTestFile("Input//SHA3_384-Input", Integer.parseInt(args[0]));
		generateTestFile("Input//SHA3_512-Input", Integer.parseInt(args[0]));
		generateTestFileCipher("Input//AES_128cipher-Input", Integer.parseInt(args[0]), 16, 16);
		generateTestFileCipher("Input//AES_192cipher-Input", Integer.parseInt(args[0]), 16, 24);
		generateTestFileCipher("Input//AES_256cipher-Input", Integer.parseInt(args[0]), 16, 32);
		generateTestFileCipher("Input//BLOWFISHcipher-Input", Integer.parseInt(args[0]), 8, 32);
		generateTestFileAESDecipher("Input//AES_128decipher-Input", Integer.parseInt(args[0]), 16, 16);
		generateTestFileAESDecipher("Input//AES_192decipher-Input", Integer.parseInt(args[0]), 16, 24);
		generateTestFileAESDecipher("Input//AES_256decipher-Input", Integer.parseInt(args[0]), 16, 32);
		generateTestFileBlowfishDecipher("Input//BLOWFISHdecipher-Input", Integer.parseInt(args[0]), 8, 32);
	}

	public static String GetExecutionPath() {
		String absolutePath = testGenerator.class.getProtectionDomain().getCodeSource().getLocation().getPath();
		absolutePath = absolutePath.substring(0, absolutePath.lastIndexOf("/"));
		absolutePath = absolutePath.replaceAll("%20", " ");
		return absolutePath;
	}

	public static void generateTestFile(String archivo, int cantidad)
			throws FileNotFoundException, UnsupportedEncodingException {
		PrintWriter writer = new PrintWriter(GetExecutionPath() + "//" + archivo + ".txt", "UTF-8");
		Random random = new Random();
		for (int i = 0; i < cantidad; i++)
			writer.println(randomString(random.nextInt(4000)));
		writer.close();
	}

	public static void generateTestFileCipher(String archivo, int cantidad, int size, int keySize)
			throws FileNotFoundException, UnsupportedEncodingException {
		PrintWriter writer = new PrintWriter(GetExecutionPath() + "//" + archivo + ".txt", "UTF-8");
		for (int i = 0; i < cantidad; i++) {
			writer.println(randomString(size));
			writer.println(randomString(keySize));
		}
		writer.close();
	}

	public static void generateTestFileAESDecipher(String archivo, int cantidad, int size, int keySize)
			throws FileNotFoundException, UnsupportedEncodingException, InvalidKeyException, NoSuchAlgorithmException,
			NoSuchProviderException, NoSuchPaddingException, ShortBufferException, IllegalBlockSizeException,
			BadPaddingException {
		PrintWriter writer = new PrintWriter(GetExecutionPath() + "//" + archivo + ".txt", "UTF-8");
		for (int i = 0; i < cantidad; i++) {
			String msg = randomString(size);
			String key = randomString(keySize);
			writer.println(msg);
			writer.println(AES(msg, key));
			writer.println(key);
		}
		writer.close();
	}

	public static void generateTestFileBlowfishDecipher(String archivo, int cantidad, int size, int keySize)
			throws FileNotFoundException, UnsupportedEncodingException, InvalidKeyException, NoSuchAlgorithmException,
			NoSuchProviderException, NoSuchPaddingException, ShortBufferException, IllegalBlockSizeException,
			BadPaddingException {
		PrintWriter writer = new PrintWriter(GetExecutionPath() + "//" + archivo + ".txt", "UTF-8");
		for (int i = 0; i < cantidad; i++) {
			String msg = randomString(size);
			String key = randomString(keySize);
			writer.println(msg);
			writer.println(BLOWFISH(msg, key));
			writer.println(key);
		}
		writer.close();
	}

	public static String AES(String msg, String keyString)
			throws NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, InvalidKeyException,
			ShortBufferException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
		byte[] input = msg.getBytes();
		byte[] keyBytes = keyString.getBytes();
		SecretKeySpec key = new SecretKeySpec(keyBytes, "AES");
		Cipher cipher = Cipher.getInstance("AES/ECB/PKCS7Padding", "BC");

		// encryption pass

		cipher.init(Cipher.ENCRYPT_MODE, key);
		byte[] cipherText = new byte[cipher.getOutputSize(input.length)];
		int ctLength = cipher.update(input, 0, input.length, cipherText, 0);
		ctLength += cipher.doFinal(cipherText, ctLength);

		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < cipherText.length / 2; i++) {
			sb.append(Integer.toString((cipherText[i] & 0xff) + 0x100, 16).substring(1));
		}

		return sb.toString();
	}

	public static String BLOWFISH(String msg, String keyString)
			throws NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, InvalidKeyException,
			ShortBufferException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
		byte[] input = msg.getBytes();
		byte[] keyBytes = keyString.getBytes();
		SecretKeySpec key = new SecretKeySpec(keyBytes, "BLOWFISH");
		Cipher cipher = Cipher.getInstance("BLOWFISH/ECB/PKCS7Padding", "BC");

		// encryption pass

		cipher.init(Cipher.ENCRYPT_MODE, key);
		byte[] cipherText = new byte[cipher.getOutputSize(input.length)];
		int ctLength = cipher.update(input, 0, input.length, cipherText, 0);
		ctLength += cipher.doFinal(cipherText, ctLength);

		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < cipherText.length / 2; i++) {
			sb.append(Integer.toString((cipherText[i] & 0xff) + 0x100, 16).substring(1));
		}

		return sb.toString();
	}

	public static String randomString(int size) {
		String SALTCHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890abcdefghijklmnopqrstuvwxyz";
		StringBuilder salt = new StringBuilder();
		Random rnd = new Random();
		while (salt.length() < size) { // length of the random string.
			int index = (int) (rnd.nextFloat() * SALTCHARS.length());
			salt.append(SALTCHARS.charAt(index));
		}
		String saltStr = salt.toString();
		return saltStr;
	}

}
