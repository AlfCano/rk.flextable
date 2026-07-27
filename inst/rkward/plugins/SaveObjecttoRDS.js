// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var obj = getValue("rds_sv_obj");
    var file = getValue("rds_sv_file");
    echo("export_path <- '" + file + "'\n");
    echo("if(!endsWith(export_path, '.rds')) export_path <- paste0(export_path, '.rds')\n");
    echo("saveRDS(" + obj + ", file = export_path)\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Save Object to RDS results")).print();
echo("rk.header('Object Exported to RDS')\nrk.print(paste0('<b>Saved to:</b> ', export_path))\n");

}

