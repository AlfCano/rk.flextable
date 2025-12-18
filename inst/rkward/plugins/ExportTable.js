// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(flextable)\n");	echo("require(magrittr)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated
// No calculation phase for export
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Export Table results")).print();

    var obj = getValue("xp_obj");
    var fmt = getValue("xp_fmt");
    var file_path = getValue("xp_file");

    var cmd = "";

    if (obj && file_path) {
        if (fmt == "docx") {
            cmd = "flextable::save_as_docx(" + obj + ", path = \"" + file_path + "\")";
        } else if (fmt == "pptx") {
            cmd = "flextable::save_as_pptx(" + obj + ", path = \"" + file_path + "\")";
        } else {
            cmd = "flextable::save_as_html(" + obj + ", path = \"" + file_path + "\")";
        }
    }
  
    if (cmd != "") {
         echo("rk.header(\"Exporting Flextable...\", level=4);\n");
         echo(cmd + "\n");
         echo("rk.print(\"File saved to: " + file_path + "\")\n");
    }
  

}

