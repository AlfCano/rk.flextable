// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(flextable)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated
//
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Export Table results")).print();

    var obj = getValue("xp_obj"); var fmt = getValue("xp_fmt"); var file = getValue("xp_file");
    if (obj && file) {
        if (fmt == "docx") echo("flextable::save_as_docx(" + obj + ", path = \"" + file + "\")\n");
        else if (fmt == "pptx") echo("flextable::save_as_pptx(" + obj + ", path = \"" + file + "\")\n");
        else echo("flextable::save_as_html(" + obj + ", path = \"" + file + "\")\n");
        echo("rk.header(\"Exporting Flextable...\", level=4);\n");
        echo("rk.print(\"File saved to: " + file + "\")\n");
    }
  

}

