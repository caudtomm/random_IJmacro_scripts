
fpath = "W:/scratch/gfriedri/caudtomm/ev_data/";
series_id = "TC_240105_TC0028_240101beh1b2_sxpDp_odorexp004_RPB3144501500AG";

input = "" + fpath + series_id + "/trials/";

list = getFileList(input);
for (ifile = 0; ifile < list.length; ifile++){
	if (!endsWith(list[ifile], ".tif")){
		continue;
	}
	print(list[ifile]);
	run("Bio-Formats Importer", "open=" + input + list[ifile] + " " + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
}
