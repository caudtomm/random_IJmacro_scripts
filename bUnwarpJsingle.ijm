
//setBatchMode(true);

fpath = "W:/scratch/gfriedri/caudtomm/ev_data/";
series_id = "TC_220201_TC0004_01_sxpDp";

input = "" + fpath + series_id + "/reg_stacks/";

list = getFileList(input);
for (ifile = 0; ifile < 1; ifile++){
	open(input + list[ifile]);

	mom = getTitle();
	
	run("Make Substack...", "  slices=400-419");
	close(mom);
	rename(mom);
	
	nplanes = nSlices;
	startSlice = 1;

	//run("Non-local Means Denoising", "sigma=5 stack");
	histeq();
	
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
	
		startSlice++;
	}
	
	selectWindow(mom);
	//run("Make Substack...", "  slices=1-" + startSlice + "");
	//rename("ResultStack");
	//run("32-bit");

	for (i = startSlice; i <= nplanes; i++) {
		if (i > startSlice) {
			selectWindow("ResultStack");
			rename("ResultStack1");
		}
	    
		selectWindow(mom);
		run("Make Substack...", "  slices=" + i + "");
		rename("thisplane");
		
		// check if nan plane
		if (isNaN(getPixel(1, 1))) {
			rename("regplane");
		} else {
			run("bUnwarpJ", "source_image=thisplane target_image=target registration=Mono image_subsample_factor=0 initial_deformation=[Very Coarse] final_deformation=Fine divergence_weight=0 curl_weight=0 landmark_weight=0 image_weight=1 consistency_weight=10 stop_threshold=0.0001");
			toclose = getTitle();
			run("Make Substack...", "  slices=1");
			run("32-bit");
			rename("regplane");
			close(toclose);
		}

		if (i > startSlice) {
			run("Concatenate...", "  title=ResultStack image1=ResultStack1 image2=regplane image3=[-- None --]");
		} else {
			rename("ResultStack");
		}
		close("thisplane");
	}
	
	run("16-bit");
	//close("target");

	//saveAs("Tiff", "" + fpath + series_id + "/provaimagej/" + mom + "");

	//run("Close All");

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