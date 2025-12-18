// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(flextable)\n");	echo("require(magrittr)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var df = getValue("ft_df");
    var theme = getValue("ft_theme");
    var do_autofit = getValue("ft_autofit");
    var do_bold = getValue("ft_bold_header");
    var do_center = getValue("ft_center_header");
    var do_footer = getValue("ft_footer");

    var cmd = "";

    if (df) {
        cmd = "flextable::flextable(" + df + ")";

        if (theme != "none") {
            cmd += " %>% flextable::theme_" + theme + "()";
        }

        if (do_bold == "1") {
            cmd += " %>% flextable::bold(part = \"header\")";
        }
        
        if (do_center == "1") {
            cmd += " %>% flextable::align(align = \"center\", part = \"header\")";
        }

        if (do_footer == "1") {
             cmd += " %>% flextable::add_footer_lines(values = paste(\"n =\", nrow(" + df + ")))";
        }

        if (do_autofit == "1") {
            cmd += " %>% flextable::autofit()";
        }
    }
  
    if (cmd != "") {
        echo("my_ft <- " + cmd + "\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Create Table results")).print();

    if (typeof is_preview === "undefined" || !is_preview) {
      echo("if (exists(\"my_ft\")) {\n");
      echo("  rk.header(\"Flextable Created\");\n");
      echo("  print(my_ft)\n");
      echo("}\n");
    }
  
	//// save result object
	// read in saveobject variables
	var ftSaveObj = getValue("ft_save_obj");
	var ftSaveObjActive = getValue("ft_save_obj.active");
	var ftSaveObjParent = getValue("ft_save_obj.parent");
	// assign object to chosen environment
	if(ftSaveObjActive) {
		echo(".GlobalEnv$" + ftSaveObj + " <- my_ft\n");
	}

}

