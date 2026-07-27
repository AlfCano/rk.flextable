// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here

}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var file = getValue("rds_ld_file");
    var name = getValue("rds_ld_name");

    // Assign imported object directly to the Global Environment safely
    echo("assign('" + name + "', readRDS('" + file + "'), envir = .GlobalEnv)\n");
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Load Object from RDS results")).print();

    var file = getValue("rds_ld_file");
    var name = getValue("rds_ld_name");
    echo("rk.header('Object Loaded from RDS')\n");
    echo("rk.print('<b>Loaded from:</b> " + file + "<br><b>Available in workspace as:</b> <code>" + name + "</code>')\n");
  

}

