// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(flextable)\n");	echo("require(magrittr)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    function getColName(fullPath) {
        if (!fullPath) return '';
        if (fullPath.indexOf('$') > -1) {
            return fullPath.split('$')[1];
        } else if (fullPath.indexOf('[[') > -1) {
             var parts = fullPath.split('[[');
             return parts[1].replace(']]', '').replace(/["']/g, '');
        }
        return fullPath;
    }
  
    var df = getValue("ft_df");
    var theme = getValue("ft_theme");
    var do_autofit = getValue("ft_autofit");
    var do_footer = getValue("ft_footer");
    
    // Style Tab
    var do_bold = getValue("ft_bold_header");
    var do_center = getValue("ft_center_header");
    var do_zebra = getValue("ft_zebra");
    var zebra_col = getValue("ft_zebra_color");
    
    // Conditional Tab
    var do_cond = getValue("ft_cond_enable");
    var cond_var_full = getValue("ft_cond_col");
    var cond_op = getValue("ft_cond_op");
    var cond_val = getValue("ft_cond_val");
    var cond_bg = getValue("ft_cond_bg");

    var cmd = "";

    if (df) {
        cmd = "flextable::flextable(" + df + ")";

        // 1. Theme
        if (theme != "none") {
            cmd += " %>% flextable::theme_" + theme + "()";
        }

        // 2. Formatting
        if (do_bold == "1") cmd += " %>% flextable::bold(part = \"header\")";
        if (do_center == "1") cmd += " %>% flextable::align(align = \"center\", part = \"header\")";
        
        if (do_zebra == "1") {
            // Apply alternate row colors to odd rows
            cmd += " %>% flextable::bg(i = seq(1, nrow(" + df + "), 2), bg = \"" + zebra_col + "\")";
        }

        // 3. Conditional Formatting
        if (do_cond == "1" && cond_var_full != "") {
            var colName = getColName(cond_var_full);
            // Syntax: bg(i = ~ col < 0.05, j = "col", bg = "orange")
            // Formula must use the raw column name
            var formula = "~ " + colName + " " + cond_op + " " + cond_val;
            cmd += " %>% flextable::bg(i = " + formula + ", j = \"" + colName + "\", bg = \"" + cond_bg + "\")";
        }

        // 4. Extras
        if (do_footer == "1") cmd += " %>% flextable::add_footer_lines(values = paste(\"n =\", nrow(" + df + ")))";
        if (do_autofit == "1") cmd += " %>% flextable::autofit()";
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

