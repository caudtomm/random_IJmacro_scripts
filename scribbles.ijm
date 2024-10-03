thispath = "W:/scratch/gfriedri/caudtomm/tail_movies/200304/";

open(thispath + "200304_Aodor_005.avi");

makeRectangle(254, 223, 73, 67);
run("Crop");


run("8-bit");