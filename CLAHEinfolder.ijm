
//setBatchMode(true);

//fpath = "W:/scratch/gfriedri/caudtomm/ev_data/";
fpath = "//tungsten-nas.fmi.ch/tungsten/scratch/gfriedri/caudtomm/ev_data/";
series_id = "TC_231222_TC0028_231219beh1b2_sxpDp_odorexp004_RPB3144501500AG";

input = "" + fpath + series_id + "/trials/";

list = getFileList(input);
for (ifile = 0; ifile < list.length; ifile++){	
//for (ifile = 0; ifile < 1; ifile++){
	if (!endsWith(list[ifile], ".tif")) {
		continue;
	}

	//open(input + list[ifile]);
	run("Bio-Formats Importer", "open=" + input + list[ifile] + " " + "autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");

	mom = getTitle();
	//run("Subtract Background...", "rolling=50 sliding stack");
	//run("Kuwahara Filter", "sampling=3 stack");
	//run("Enhance Contrast...", "saturated=0.3 equalize process_all use");
	nplanes = nSlices;
	startSlice = 1;

	setBatchMode(true);
	histeq();
	setBatchMode(false);
	saveAs("Tiff", "" + fpath + series_id + "/trials_clahe/" + list[ifile] + "");
	
	mom = getTitle();
	
	for (i = startSlice; i <= nSlices; i++) {
	    setSlice(i);
	    
		selectWindow(mom);
		// check if nan plane
		if (!isNaN(getPixel(1, 1))) {
			navg = 50;
			for (id = i+1; id <= nSlices; id++) {
				if (isNaN(getPixel(1, 1))) {
					navg++;
				}
				if (id-i >= navg-1) {
					break
				}
			}
			run("Z Project...", "start=" + i + " stop=" + i+navg-1 + " projection=[Average Intensity]");
			rename("target");
			break
		}
//	
		startSlice++;
	}
	
	saveAs("Tiff", "" + fpath + series_id + "/trials_clahe_warpref/" + list[ifile] + "");

	run("Close All");

}

//setBatchMode(false);

function histeq() {

	blocksize = 40;
	histogram_bins = 256;
	maximum_slope = 5;
	mask = "*None*";
	fast =  false;
	process_as_composite = false;
	
	getDimensions( width, height, channels, slices, frames );
	isComposite = channels > 1;
	parameters =
	  "blocksize=" + blocksize +
	  " histogram=" + histogram_bins +
	  " maximum=" + maximum_slope +
	  " mask=" + mask;
	if ( fast )
	  parameters += " fast_(less_accurate)";
	if ( isComposite && process_as_composite ) {
	  parameters += " process_as_composite";
	  channels = 1;
	}
	  
	for ( f=1; f<=frames; f++ ) {
	  Stack.setFrame( f );
	  for ( s=1; s<=slices; s++ ) {
	    Stack.setSlice( s );
	    for ( c=1; c<=channels; c++ ) {
	      Stack.setChannel( c );
	      run( "Enhance Local Contrast (CLAHE)", parameters );
	    }
	  }
	}
}