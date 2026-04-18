local({
  # =========================================================================================
  # 1. Package Definition and Metadata
  # =========================================================================================
  require(rkwarddev)
  rkwarddev.required("0.10-3")

  package_about <- rk.XML.about(
    name = "rk.flextable",
    author = person(
      given = "Alfonso",
      family = "Cano Robles",
      email = "alfonso.cano@correo.buap.mx",
      role = c("aut", "cre")
    ),
    about = list(
      desc = "An RKWard plugin for creating, formatting, and exporting publication-ready tables using the flextable library.",
      version = "0.0.3",
      url = "https://github.com/AlfCano/rk.flextable",
      license = "GPL (>= 3)"
    )
  )

  # Menu Location
  common_hierarchy <- list("data", "Reporting (flextable)")

  # =========================================================================================
  # 2. JS Helper (Variable Parsing)
  # =========================================================================================
  js_parse_helper <- "
    function getColName(fullPath) {
        if (!fullPath) return '';
        if (fullPath.indexOf('$') > -1) {
            return fullPath.split('$')[1];
        } else if (fullPath.indexOf('[[') > -1) {
             var parts = fullPath.split('[[');
             return parts[1].replace(']]', '').replace(/[\"']/g, '');
        }
        return fullPath;
    }
  "

  # =========================================================================================
  # 3. COMPONENT 1: Create Table (MAIN)
  # =========================================================================================

  help_create <- rk.rkh.doc(
    title = rk.rkh.title(text = "Create Publication Table"),
    summary = rk.rkh.summary(text = "Converts a dataframe into a formatted 'flextable' object suitable for Word/PowerPoint."),
    usage = rk.rkh.usage(text = "Select a dataframe, choose a theme, and apply specific formatting options.")
  )

  # --- Tab 1: Data & Theme ---
  ft_selector <- rk.XML.varselector(id.name = "ft_selector")

  ft_df <- rk.XML.varslot(label = "Dataframe to format", source = "ft_selector", classes = "data.frame", required = TRUE, id.name = "ft_df")

  ft_theme <- rk.XML.dropdown(
    label = "Apply Theme",
    options = list(
      "Scientific (theme_booktabs)" = c(val = "booktabs", chk = TRUE),
      "Minimal (theme_vanilla)" = c(val = "vanilla"),
      "Boxed (theme_box)" = c(val = "box"),
      "Striped (theme_zebra)" = c(val = "zebra"),
      "Colorful (theme_alafoli)" = c(val = "alafoli"),
      "Dark (theme_vader)" = c(val = "vader"),
      "None (No theme)" = c(val = "none")
    ),
    id.name = "ft_theme"
  )

  ft_autofit <- rk.XML.cbox(label = "Autofit column widths", value = "1", chk = TRUE, id.name = "ft_autofit")
  ft_footer <- rk.XML.cbox(label = "Add Footer (Row count)", value = "1", id.name = "ft_footer")

  # --- Tab 2: Formatting (Bold, Zebra) ---
  ft_bold_header <- rk.XML.cbox(label = "Bold Headers", value = "1", chk = TRUE, id.name = "ft_bold_header")
  ft_center_header <- rk.XML.cbox(label = "Center Align Headers", value = "1", chk = TRUE, id.name = "ft_center_header")

  ft_zebra <- rk.XML.cbox(label = "Apply Alternating Row Colors (Zebra)", value = "1", id.name = "ft_zebra")
  ft_zebra_col <- rk.XML.input(label = "Zebra Color", initial = "#F0F0F0", id.name = "ft_zebra_color") # Light Gray default

  # --- Tab 3: Conditional Formatting ---
  ft_cond_enable <- rk.XML.cbox(label = "Enable Conditional Formatting", value = "1", id.name = "ft_cond_enable")

  ft_cond_col <- rk.XML.varslot(label = "Target Column (Numeric)", source = "ft_selector", id.name = "ft_cond_col")

  ft_cond_op <- rk.XML.dropdown(label = "Operator", options = list(
      "Less than (<)" = c(val = "<", chk=TRUE),
      "Greater than (>)" = c(val = ">"),
      "Equal to (==)" = c(val = "=="),
      "Not Equal (!=)" = c(val = "!="),
      "Less or Equal (<=)" = c(val = "<="),
      "Greater or Equal (>=)" = c(val = ">=")
  ), id.name = "ft_cond_op")

  ft_cond_val <- rk.XML.input(label = "Comparison Value (e.g. 0.05)", initial = "0.05", id.name = "ft_cond_val")
  ft_cond_color <- rk.XML.input(label = "Highlight Color", initial = "orange", id.name = "ft_cond_bg")

  # Save Object
  ft_save <- rk.XML.saveobj(label = "Save table object as", chk = TRUE, initial = "my_ft", id.name = "ft_save_obj")

  # Dialog Layout
  dialog_create <- rk.XML.dialog(
    label = "Create Table",
    child = rk.XML.row(
      ft_selector,
      rk.XML.col(
          rk.XML.tabbook(tabs = list(
              "Data & Theme" = rk.XML.col(ft_df, ft_theme, ft_autofit, ft_footer),
              "Style" = rk.XML.col(
                  rk.XML.frame(ft_bold_header, ft_center_header, label="Headers"),
                  rk.XML.frame(ft_zebra, ft_zebra_col, label="Rows")
              ),
              "Conditional Formatting" = rk.XML.col(
                  ft_cond_enable,
                  rk.XML.frame(ft_cond_col, ft_cond_op, ft_cond_val, ft_cond_color, label="Rule: Highlight Cell if...")
              )
          )),
          ft_save
      )
    )
  )

  # JS Logic
  js_body_create <- paste0(js_parse_helper, '
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
        if (do_bold == "1") cmd += " %>% flextable::bold(part = \\\"header\\\")";
        if (do_center == "1") cmd += " %>% flextable::align(align = \\\"center\\\", part = \\\"header\\\")";

        if (do_zebra == "1") {
            // Apply alternate row colors to odd rows
            cmd += " %>% flextable::bg(i = seq(1, nrow(" + df + "), 2), bg = \\\"" + zebra_col + "\\\")";
        }

        // 3. Conditional Formatting
        if (do_cond == "1" && cond_var_full != "") {
            var colName = getColName(cond_var_full);
            // Syntax: bg(i = ~ col < 0.05, j = "col", bg = "orange")
            // Formula must use the raw column name
            var formula = "~ " + colName + " " + cond_op + " " + cond_val;
            cmd += " %>% flextable::bg(i = " + formula + ", j = \\\"" + colName + "\\\", bg = \\\"" + cond_bg + "\\\")";
        }

        // 4. Extras
        if (do_footer == "1") cmd += " %>% flextable::add_footer_lines(values = paste(\\\"n =\\\", nrow(" + df + ")))";
        if (do_autofit == "1") cmd += " %>% flextable::autofit()";
    }
  ')

  js_calc_create <- paste0(js_body_create, '
    if (cmd != "") {
        echo("my_ft <- " + cmd + "\\n");
    }
  ')

  js_print_create <- '
    if (typeof is_preview === "undefined" || !is_preview) {
      echo("if (exists(\\\"my_ft\\\")) {\\n");
      echo("  rk.header(\\"Flextable Created\\");\\n");
      echo("  print(my_ft)\\n");
      echo("}\\n");
    }
  '

  # =========================================================================================
  # 4. COMPONENT 2: Export Table
  # =========================================================================================

  help_export <- rk.rkh.doc(
    title = rk.rkh.title(text = "Export Flextable"),
    summary = rk.rkh.summary(text = "Export a previously created flextable object to Word (.docx) or PowerPoint (.pptx)."),
    usage = rk.rkh.usage(text = "Select a 'flextable' object from your workspace and specify the output file location.")
  )

  xp_selector <- rk.XML.varselector(id.name = "xp_selector")

  xp_obj <- rk.XML.varslot(
    label = "Flextable Object",
    source = "xp_selector",
    required = TRUE,
    id.name = "xp_obj"
  )

  xp_fmt <- rk.XML.radio(
    label = "Export Format",
    options = list(
        "Microsoft Word (.docx)" = c(val = "docx", chk = TRUE),
        "PowerPoint (.pptx)" = c(val = "pptx"),
        "HTML (.html)" = c(val = "html")
    ),
    id.name = "xp_fmt"
  )

  xp_file <- rk.XML.browser(
    label = "Output File",
    type = "savefile",
    required = TRUE,
    id.name = "xp_file"
  )

  dialog_export <- rk.XML.dialog(
    label = "Export Flextable",
    child = rk.XML.row(
      xp_selector,
      rk.XML.col(xp_obj, xp_fmt, xp_file)
    )
  )

  js_body_export <- '
    var obj = getValue("xp_obj");
    var fmt = getValue("xp_fmt");
    var file_path = getValue("xp_file");

    var cmd = "";

    if (obj && file_path) {
        if (fmt == "docx") {
            cmd = "flextable::save_as_docx(" + obj + ", path = \\\"" + file_path + "\\\")";
        } else if (fmt == "pptx") {
            cmd = "flextable::save_as_pptx(" + obj + ", path = \\\"" + file_path + "\\\")";
        } else {
            cmd = "flextable::save_as_html(" + obj + ", path = \\\"" + file_path + "\\\")";
        }
    }
  '

  js_calc_export <- "// No calculation phase for export"

  js_print_export <- paste0(js_body_export, '
    if (cmd != "") {
         echo("rk.header(\\"Exporting Flextable...\\", level=4);\\n");
         echo(cmd + "\\n");
         echo("rk.print(\\"File saved to: " + file_path + "\\")\\n");
    }
  ')

  component_export <- rk.plugin.component(
    "Export Table",
    xml = list(dialog = dialog_export),
    js = list(
        require = c("flextable", "magrittr"),
        calculate = js_calc_export,
        printout = js_print_export
    ),
    hierarchy = common_hierarchy,
    rkh = list(help = help_export)
  )


  # =========================================================================================
  # 5. BUILD SKELETON
  # =========================================================================================

  rk.plugin.skeleton(
    about = package_about,
    path = ".",
    xml = list(dialog = dialog_create),
    js = list(
        require = c("flextable", "magrittr"),
        calculate = js_calc_create,
        printout = js_print_create
    ),
    rkh = list(help = help_create),
    components = list(
        component_export
    ),
    pluginmap = list(
        name = "Create Table",
        hierarchy = common_hierarchy
    ),
    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  cat("\nPlugin package 'rk.flextable' (v0.0.2) generated successfully.\n")
  cat("  1. rk.updatePluginMessages(path=\".\")\n")
  cat("  2. devtools::install(\".\")\n")
})
