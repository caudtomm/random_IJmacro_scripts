

fpathIn = "W:\\scratch\\gfriedri\\caudtomm\\tail_movies\\191203_stimulus_responses\\";
//inputExt = ".avi";

//list = getFileList(fpathIn);

//for (i = 0; i < list.length; i++) {
//	if(endsWith(list[i], inputExt)) {
//		processFile(fpathIn, fpathIn, list[i]);
//	}
//}


//function processFile(input_path, output_path, fname) {
//	print("Processing: " + input_path + fname);
//	open(input_path + fname);
//}


fname = getTitle();
makeRectangle(241, 306, 129, 122);
run("Plot Z-axis Profile");
