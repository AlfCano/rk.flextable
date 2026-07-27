// this code was generated using the rkwarddev package.
// perhaps don't make changes here, but in the rkwarddev script instead!



function preprocess(is_preview){
	// add requirements etc. here
	echo("require(flextable)\n");
}

function calculate(is_preview){
	// read in variables from dialog


	// the R code to be evaluated

    var obj = getValue("adv_obj");
    var theme = getValue("adv_theme");
    var layout = getValue("adv_layout");
    var width = getValue("adv_width");
    var caption = getValue("adv_caption");
    var cap_size = getValue("adv_cap_size");
    var footer = getValue("adv_footer");
    var foot_size = getValue("adv_foot_size");

    // REGLA #3: Usamos exactamente "my_ft_adv" como se definió en el rk.XML.saveobj
    echo("my_ft_adv <- " + obj + "\n");

    if (theme !== "none") {
        echo("my_ft_adv <- flextable::theme_" + theme + "(my_ft_adv)\n");
    }

    echo("my_ft_adv <- flextable::set_table_properties(my_ft_adv, width = " + width + ", layout = '" + layout + "')\n");

    if (caption !== "") {
        echo("require(officer)\n");
        // CORRECCIÓN: Usamos fp_text() que es 100% compatible con cualquier versión de officer
        echo("my_ft_adv <- flextable::set_caption(my_ft_adv, caption = flextable::as_paragraph(flextable::as_chunk('" + caption + "', props = officer::fp_text(font.size = " + cap_size + "))))\n");
    }

    if (footer !== "") {
        echo("my_ft_adv <- flextable::add_footer_lines(my_ft_adv, '" + footer + "')\n");
        echo("my_ft_adv <- flextable::fontsize(my_ft_adv, size = " + foot_size + ", part = 'footer')\n");
        echo("my_ft_adv <- flextable::italic(my_ft_adv, italic = TRUE, part = 'footer')\n");
    }
  
}

function printout(is_preview){
	// printout the results
	new Header(i18n("Advanced Formatting results")).print();
echo("rk.header('Advanced Flextable Formatting')\nprint(my_ft_adv)\n");
	//// save result object
	// read in saveobject variables
	var advSave = getValue("adv_save");
	var advSaveActive = getValue("adv_save.active");
	var advSaveParent = getValue("adv_save.parent");
	// assign object to chosen environment
	if(advSaveActive) {
		echo(".GlobalEnv$" + advSave + " <- my_ft_adv\n");
	}

}

