package testing;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.Security;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.ShortBufferException;
import javax.crypto.spec.SecretKeySpec;
import org.bouncycastle.jcajce.provider.digest.SHA3;
import org.bouncycastle.util.encoders.Hex;

public class generateOutputJava {

	public static void main(String[] args) throws Exception {
		applyFonFileContent("SHA1", "Input//SHA1-Input", "Output-JAVA//SHA1-Output-JAVA");
		applyFonFileContent("MD5", "Input//MD5-Input", "Output-JAVA//MD5-Output-JAVA");
		applyFonFileContent("SHA256", "Input//SHA256-Input", "Output-JAVA//SHA256-Output-JAVA");
		applyFonFileContent("SHA224", "Input//SHA224-Input", "Output-JAVA//SHA224-Output-JAVA");
		applyFonFileContent("SHA384", "Input//SHA384-Input", "Output-JAVA//SHA384-Output-JAVA");
		applyFonFileContent("SHA512", "Input//SHA512-Input", "Output-JAVA//SHA512-Output-JAVA");
		applyFonFileContent("SHA3_224", "Input//SHA3_224-Input", "Output-JAVA//SHA3_224-Output-JAVA");
		applyFonFileContent("SHA3_256", "Input//SHA3_256-Input", "Output-JAVA//SHA3_256-Output-JAVA");
		applyFonFileContent("SHA3_384", "Input//SHA3_384-Input", "Output-JAVA//SHA3_384-Output-JAVA");
		applyFonFileContent("SHA3_512", "Input//SHA3_512-Input", "Output-JAVA//SHA3_512-Output-JAVA");
		applyFonFileContent("AEScipher", "Input//AES_128cipher-Input", "Output-JAVA//AES_128cipher-Output-JAVA");
		applyFonFileContent("AEScipher", "Input//AES_192cipher-Input", "Output-JAVA//AES_192cipher-Output-JAVA");
		applyFonFileContent("AEScipher", "Input//AES_256cipher-Input", "Output-JAVA//AES_256cipher-Output-JAVA");
		applyFonFileContent("BLOWFISHcipher", "Input//BLOWFISHcipher-Input", "Output-JAVA//BLOWFISHcipher-Output-JAVA");
		applyFonFileContent("AESdecipher", "Input//AES_128decipher-Input", "Output-JAVA//AES_128decipher-Output-JAVA");
		applyFonFileContent("AESdecipher", "Input//AES_192decipher-Input", "Output-JAVA//AES_192decipher-Output-JAVA");
		applyFonFileContent("AESdecipher", "Input//AES_256decipher-Input", "Output-JAVA//AES_256decipher-Output-JAVA");
		applyFonFileContent("BLOWFISHdecipher", "Input//BLOWFISHdecipher-Input",
				"Output-JAVA//BLOWFISHdecipher-Output-JAVA");

	}

	public static void applyFonFileContent(String F, String archivo, String output)
			throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException,
			ShortBufferException, IllegalBlockSizeException, BadPaddingException {
		try {
			File f = new File(GetExecutionPath() + "//" + archivo + ".txt");
			BufferedReader b = new BufferedReader(new FileReader(f));

			PrintWriter writer = new PrintWriter(GetExecutionPath() + "//" + output + ".txt", "UTF-8");
			String aux = "";
			String readLine = "";
			while ((readLine = b.readLine()) != null) {
				switch (F) {
				case "MD5":
					writer.println(MD5(readLine));
					break;
				case "SHA1":
					writer.println(SHA1(readLine));
					break;
				case "SHA224":
					writer.println(SHA224(readLine));
					break;
				case "SHA256":
					writer.println(SHA256(readLine));
					break;
				case "SHA384":
					writer.println(SHA384(readLine));
					break;
				case "SHA512":
					writer.println(SHA512(readLine));
					break;
				case "SHA3_224":
					writer.println(SHA3_224(readLine));
					break;
				case "SHA3_256":
					writer.println(SHA3_256(readLine));
					break;
				case "SHA3_384":
					writer.println(SHA3_384(readLine));
					break;
				case "SHA3_512":
					writer.println(SHA3_512(readLine));
					break;
				case "AEScipher":
					aux = b.readLine();
					writer.println(AES(readLine, aux));
					break;
				case "BLOWFISHcipher":
					aux = b.readLine();
					writer.println(BLOWFISH(readLine, aux));
					break;
				case "AESdecipher":
					aux = b.readLine();
					aux = b.readLine();
					writer.println(readLine);
					break;
				case "BLOWFISHdecipher":
					aux = b.readLine();
					aux = b.readLine();
					writer.println(readLine);
					break;
				}
			}
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static String GetExecutionPath() {
		String absolutePath = generateOutputJava.class.getProtectionDomain().getCodeSource().getLocation().getPath();
		absolutePath = absolutePath.substring(0, absolutePath.lastIndexOf("/"));
		absolutePath = absolutePath.replaceAll("%20", " ");
		return absolutePath;
	}

	public static String MD5(String msg) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] bytes = md.digest(msg.getBytes(StandardCharsets.UTF_8));
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < bytes.length; i++) {
				sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return "error";
	}

	public static String SHA1(String msg) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-1");
			byte[] bytes = md.digest(msg.getBytes(StandardCharsets.UTF_8));
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < bytes.length; i++) {
				sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return "error";
	}

	public static String SHA224(String msg) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-224");
			byte[] bytes = md.digest(msg.getBytes(StandardCharsets.UTF_8));
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < bytes.length; i++) {
				sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return "error";
	}

	public static String SHA256(String msg) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			byte[] bytes = md.digest(msg.getBytes(StandardCharsets.UTF_8));
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < bytes.length; i++) {
				sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return "error";
	}

	public static String SHA384(String msg) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-384");
			byte[] bytes = md.digest(msg.getBytes(StandardCharsets.UTF_8));
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < bytes.length; i++) {
				sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return "error";
	}

	public static String SHA512(String msg) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-512");
			byte[] bytes = md.digest(msg.getBytes(StandardCharsets.UTF_8));
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < bytes.length; i++) {
				sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
			}
			return sb.toString();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return "error";
	}

	public static String SHA3_224(String msg) {
		SHA3.DigestSHA3 digestSHA3 = new SHA3.Digest224();
		byte[] digest = digestSHA3.digest(msg.getBytes());

		return Hex.toHexString(digest);
	}

	public static String SHA3_256(String msg) {
		SHA3.DigestSHA3 digestSHA3 = new SHA3.Digest256();
		byte[] digest = digestSHA3.digest(msg.getBytes());

		return Hex.toHexString(digest);
	}

	public static String SHA3_384(String msg) {
		SHA3.DigestSHA3 digestSHA3 = new SHA3.Digest384();
		byte[] digest = digestSHA3.digest(msg.getBytes());

		return Hex.toHexString(digest);
	}

	public static String SHA3_512(String msg) {
		SHA3.DigestSHA3 digestSHA3 = new SHA3.Digest512();
		byte[] digest = digestSHA3.digest(msg.getBytes());

		return Hex.toHexString(digest);
	}

	public static String AES(String msg, String keyString)
			throws NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, InvalidKeyException,
			ShortBufferException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
		byte[] input = msg.getBytes();
		byte[] keyBytes = keyString.getBytes();
		SecretKeySpec key = new SecretKeySpec(keyBytes, "AES");
		Cipher cipher = Cipher.getInstance("AES/ECB/PKCS7Padding", "BC");

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

}
