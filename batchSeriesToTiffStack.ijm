inpath = "C:/Users/caudtomm/Desktop/2020_invivo_data/TC_200717_TC0004_01_sxpDp/figures/plotCosDMatInTime/tmp/";

extension = ".tif";

files = getFileList(inpath);
files = Array.sort(files);
for (i=0; i < files.length; i++) {
	print(files[i]);
	if(!File.isDirectory(inpath + files[i]) & endsWith(files[i], extension)) {
		if (!isOpen("StackOut")) {
			open(inpath + files[i]);
			rename("StackOut");
		} else {
			mergeImgs(inpath + files[i]);
		}
	}
}

saveAs("Tiff", "" + inpath + "StackOut.tif");

print("DONE!")


function mergeImgs(filename) {

	stackname = "StackOut";

	open(filename);
	thisImg = getTitle();

	run("Concatenate...", "  title=" + stackname + " image1=" + stackname + " image2=" + thisImg + "");
	
	
}
