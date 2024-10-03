fpath = "//tungsten-nas.fmi.ch/tungsten/scratch/gfriedri/caudtomm/ev_data/TC_230711_TC0028_230708beh2b4_sxpDp_odorexp004_RPB3144501500AG/tail_movies/";
extension = ".avi";

setBatchMode(true);

files = getFileList(fpath);
files = Array.sort(files);
for (i=0; i < files.length; i++) {
	outname = substring(files[i], 0, lengthOf(files[i])-4) + ".csv";
	if(!File.isDirectory(fpath + files[i]) & endsWith(files[i], extension) & !File.exists(fpath + outname)) {
		print(files[i]);
		open(fpath + files[i]);
		mom = getTitle();

		// LED
		selectWindow(mom);
		makeRectangle(776,294,83,123);
		outfile = "" + fpath + "LED_vals/" + outname + "";
		run("Measure Stack...");
		saveAs("Measurements",  outfile);
		close("Results");

		// Lip
		selectWindow(mom);
		makeRectangle(451,522,16,18);
		outfile = "" + fpath + "Lip_vals/" + outname + "";
		run("Measure Stack...");
		saveAs("Measurements",  outfile);
		close("Results");

		// Tail
		selectWindow(mom);
		run("Select None");
		run("Duplicate...", "title=mom_copy duplicate");
		makeRectangle(222,206,318,194);
		getdiffstack("" + fpath + "Tail_vals/" + outname + "");

		run("Close All");

	}
}

setBatchMode(false);




function getdiffstack(outfile) {
	run("Crop");
	run("8-bit");
	//save(fpath + files[i]);
	
	thisimg = getTitle();
	run("Make Substack...", "  slices=1");
	selectWindow(thisimg);
	run("Make Substack...", "  slices=2-" + nSlices() + "");
	substack = getTitle();
	run("Concatenate...", "open image1=[" + substack + "] image2=[Substack (1)] image3=[-- None --]");
	imageCalculator("Subtract create stack", "Untitled",thisimg);
	selectWindow("Result of Untitled");
	
	run("Measure Stack...");

	saveAs("Measurements",  outfile);
	close("Results");
	close(thisimg);
	close(substack);
	close("Result of Untitled");
	close("Untitled");
}
