package checkFilesEqual;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class checkFilesEqual {

	public static void main(String[] args) {
		equalFiles("Output-C//SHA1-Output-C", "Output-JAVA//SHA1-Output-JAVA", "SHA1");
		equalFiles("Output-C//MD5-Output-C", "Output-JAVA//MD5-Output-JAVA", "MD5");
		equalFiles("Output-C//SHA256-Output-C", "Output-JAVA//SHA256-Output-JAVA", "SHA-128");
		equalFiles("Output-C//SHA224-Output-C", "Output-JAVA//SHA224-Output-JAVA", "SHA-256");
		equalFiles("Output-C//SHA384-Output-C", "Output-JAVA//SHA384-Output-JAVA", "SHA-384");
		equalFiles("Output-C//SHA512-Output-C", "Output-JAVA//SHA512-Output-JAVA", "SHA-512");
		equalFiles("Output-C//SHA3_224-Output-C", "Output-JAVA//SHA3_224-Output-JAVA", "SHA3-224");
		equalFiles("Output-C//SHA3_256-Output-C", "Output-JAVA//SHA3_256-Output-JAVA", "SHA3-256");
		equalFiles("Output-C//SHA3_384-Output-C", "Output-JAVA//SHA3_384-Output-JAVA", "SHA3-384");
		equalFiles("Output-C//SHA3_512-Output-C", "Output-JAVA//SHA3_512-Output-JAVA", "SHA3-512");
		equalFiles("Output-C//AES_128cipher-Output-C", "Output-JAVA//AES_128cipher-Output-JAVA", "AES_128 cipher");
		equalFiles("Output-C//AES_192cipher-Output-C", "Output-JAVA//AES_192cipher-Output-JAVA", "AES_192 cipher");
		equalFiles("Output-C//AES_256cipher-Output-C", "Output-JAVA//AES_256cipher-Output-JAVA", "AES_256 cipher");
		equalFiles("Output-C//BLOWFISHcipher-Output-C", "Output-JAVA//BLOWFISHcipher-Output-JAVA", "BLOWFISH cipher");
		equalFiles("Output-C//AES_128decipher-Output-C", "Output-JAVA//AES_128decipher-Output-JAVA",
				"AES_128 decipher");
		equalFiles("Output-C//AES_192decipher-Output-C", "Output-JAVA//AES_192decipher-Output-JAVA",
				"AES_192 decipher");
		equalFiles("Output-C//AES_256decipher-Output-C", "Output-JAVA//AES_256decipher-Output-JAVA",
				"AES_256 decipher");
		equalFiles("Output-C//BLOWFISHdecipher-Output-C", "Output-JAVA//BLOWFISHdecipher-Output-JAVA",
				"BLOWFISH decipher");
	}

	public static void equalFiles(String file1, String file2, String alg) {
		boolean equal = true;
		try {
			File f = new File(GetExecutionPath() + "//" + file1 + ".txt");
			BufferedReader b = new BufferedReader(new FileReader(f));

			File f2 = new File(GetExecutionPath() + "//" + file2 + ".txt");
			BufferedReader b2 = new BufferedReader(new FileReader(f2));

			String readLine = "";
			String readLine2 = "";
			int i = 1;
			while ((readLine = b.readLine()) != null && (readLine2 = b2.readLine()) != null) {

				if (!readLine.equals(readLine2)) {
					System.out.println(i + "       " + readLine);

					equal = false;
				}
				i++;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (equal)
			System.out.println(alg + "...OK");
		else
			System.out.println("Error");
	}

	public static String GetExecutionPath() {
		String absolutePath = checkFilesEqual.class.getProtectionDomain().getCodeSource().getLocation().getPath();
		absolutePath = absolutePath.substring(0, absolutePath.lastIndexOf("/"));
		absolutePath = absolutePath.replaceAll("%20", " "); 
		return absolutePath;
	}
}
