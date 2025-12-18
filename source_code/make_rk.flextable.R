local({
  # =========================================================================================
  # 1. Package Definition and Metadata
  # =========================================================================================
  require(rkwarddev)
  # Ensure we have a compatible version
  if(packageVersion("rkwarddev") < "0.07") stop("Please update rkwarddev")

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
      version = "0.0.1",
      url = "https://github.com/AlfCano/rk.flextable",
      license = "GPL (>= 3)"
    )
  )

  # Menu Location: Data -> Reporting (flextable)
  # We use a simple hierarchy list to avoid ambiguity
  common_hierarchy <- list("data", "Reporting (flextable)")

  # =========================================================================================
  # 2. COMPONENT 1: Create Table (THE MAIN COMPONENT)
  #    Defined as raw objects here, passed to top-level skeleton args later.
  # =========================================================================================

  help_create <- rk.rkh.doc(
    title = rk.rkh.title(text = "Create Publication Table"),
    summary = rk.rkh.summary(text = "Converts a dataframe into a formatted 'flextable' object suitable for Word/PowerPoint."),
    usage = rk.rkh.usage(text = "Select a dataframe, choose a theme, and apply specific formatting options.")
  )

  # UI Widgets
  ft_selector <- rk.XML.varselector(id.name = "ft_selector")

  ft_df <- rk.XML.varslot(
    label = "Dataframe to format",
    source = "ft_selector",
    classes = "data.frame",
    required = TRUE,
    id.name = "ft_df"
  )

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

  ft_opts <- rk.XML.frame(
    rk.XML.cbox(label = "Autofit column widths", value = "1", chk = TRUE, id.name = "ft_autofit"),
    rk.XML.cbox(label = "Bold Header", value = "1", chk = TRUE, id.name = "ft_bold_header"),
    rk.XML.cbox(label = "Center Align Header", value = "1", chk = TRUE, id.name = "ft_center_header"),
    rk.XML.cbox(label = "Add Footer (Row count)", value = "1", id.name = "ft_footer"),
    label = "Refinements"
  )

  # Save Object
  ft_save <- rk.XML.saveobj(label = "Save table object as", chk = TRUE, initial = "my_ft", id.name = "ft_save_obj")

  # Dialog Layout (No Preview Widget)
  dialog_create <- rk.XML.dialog(
    label = "Create Table",
    child = rk.XML.row(
      ft_selector,
      rk.XML.col(ft_df, ft_theme, ft_opts, ft_save)
    )
  )

  # JS Logic
  js_body_create <- '
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
            cmd += " %>% flextable::bold(part = \\\"header\\\")";
        }

        if (do_center == "1") {
            cmd += " %>% flextable::align(align = \\\"center\\\", part = \\\"header\\\")";
        }

        if (do_footer == "1") {
             cmd += " %>% flextable::add_footer_lines(values = paste(\\\"n =\\\", nrow(" + df + ")))";
        }

        if (do_autofit == "1") {
            cmd += " %>% flextable::autofit()";
        }
    }
  '

  js_calc_create <- paste0(js_body_create, '
    if (cmd != "") {
        echo("my_ft <- " + cmd + "\\n");
    }
  ')

  # Simple Printout (Runs on Submit)
  js_print_create <- '
    if (typeof is_preview === "undefined" || !is_preview) {
      echo("if (exists(\\\"my_ft\\\")) {\\n");
      echo("  rk.header(\\"Flextable Created\\");\\n");
      echo("  print(my_ft)\\n");
      echo("}\\n");
    }
  '

  # NOTE: We DO NOT wrap this in rk.plugin.component here.
  # We pass these raw objects to the top-level skeleton arguments.


  # =========================================================================================
  # 3. COMPONENT 2: Export Table (THE SUB COMPONENT)
  #    Defined as a full component object to be passed in the 'components' list.
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

  # We wrap this one in rk.plugin.component because it's a sub-component
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
  # 4. BUILD SKELETON
  # =========================================================================================

  rk.plugin.skeleton(
    about = package_about,
    path = ".",

    # -------------------------------------------------------------------------
    # MAIN COMPONENT ("Create Table")
    # Defined here at the top level. This creates rk.flextable.xml / .js
    # -------------------------------------------------------------------------
    xml = list(dialog = dialog_create),
    js = list(
        require = c("flextable", "magrittr"),
        calculate = js_calc_create,
        printout = js_print_create
    ),
    rkh = list(help = help_create),

    # -------------------------------------------------------------------------
    # SUB COMPONENTS ("Export Table")
    # Defined in the list. This creates Export_Table.xml / .js
    # -------------------------------------------------------------------------
    components = list(
        component_export
    ),

    # -------------------------------------------------------------------------
    # PLUGIN MAP
    # Defines the menu hierarchy for the Main component.
    # The Sub-component handles its own via the 'hierarchy' arg in rk.plugin.component
    # -------------------------------------------------------------------------
    pluginmap = list(
        name = "Create Table", # Label for the Main Component
        hierarchy = common_hierarchy
    ),

    create = c("pmap", "xml", "js", "desc", "rkh"),
    load = TRUE,
    overwrite = TRUE,
    show = FALSE
  )

  cat("\nPlugin package 'rk.flextable' (v0.0.1) generated successfully.\n")
  cat("  1. rk.updatePluginMessages(path=\".\")\n")
  cat("  2. devtools::install(\".\")\n")
})
