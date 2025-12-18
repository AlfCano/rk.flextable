# rk.flextable

> **Publication-Ready Tables for RKWard**

![Version](https://img.shields.io/badge/Version-0.0.2-blue.svg)
![License](https://img.shields.io/badge/License-GPL--3-green.svg)

**rk.flextable** is an RKWard plugin that provides a graphical interface for the powerful [`flextable`](https://davidgohel.github.io/flextable/) package. It allows users to easily create, format, and export professional tables for scientific publications and reports directly from the RKWard GUI, without writing complex R code.

## Features

*   **GUI-Driven Creation**: Convert any R dataframe into a formatted table with a few clicks.
*   **One-Click Themes**: Apply professional styles instantly (Scientific/Booktabs, Minimal, Zebra, Boxed, etc.).
*   **Advanced Styling**:
    *   **Header Control**: Bold text and center alignment.
    *   **Zebra Striping**: Apply alternating background colors to rows for readability.
    *   **Conditional Formatting**: Highlight specific cells based on values (e.g., color cells where `P.Value < 0.05`).
*   **Smart Refinements**: Automatic column width adjustment (`autofit`) and footer generation.
*   **Export Capabilities**: Save your formatted tables directly to:
    *   Microsoft Word (`.docx`)
    *   Microsoft PowerPoint (`.pptx`)
    *   HTML

## Installation

You can install this plugin directly from GitHub using `devtools` within RKWard:

```r
require(devtools)
install_github("AlfCano/rk.flextable")
```

Once installed, restart RKWard to ensure the new menu items appear correctly.

## Usage

The plugin is located in the main menu under:
**Data -> Reporting (flextable)**

It consists of two main tools:

### 1. Create Table
Use this tool to generate and style the table object. The interface is divided into three tabs:

#### Tab 1: Data & Theme
*   **Dataframe**: Select the data you want to format.
*   **Theme**: Choose a preset look (e.g., `Scientific` for academic papers, `Striped` for business reports).
*   **Refinements**: Toggle autofit and footers.

#### Tab 2: Style
*   **Headers**: Apply **Bold** text or **Center** alignment to the header row.
*   **Rows**: Enable **Zebra Striping** and choose a custom background color for alternating rows.

#### Tab 3: Conditional Formatting
*   **Enable**: Turn on rule-based highlighting.
*   **Rule Definition**: "Highlight cell if **[Column]** is **[<, >, ==]** to **[Value]**".
*   **Color**: Select the background color for the highlighted cells.
    *   *Example:* Highlight column `p.value` where values are `< 0.05` in `orange`.

### 2. Export Table
Use this tool to save your table to a file.
*   **Input**: Select the `flextable` object created in the previous step (default name `my_ft`).
*   **Format**: Choose Word, PowerPoint, or HTML.
*   **Output**: Select a destination file path.

## Requirements

*   **RKWard**: 0.7.5 or higher.
*   **R Packages**:
    *   `flextable`
    *   `magrittr`
    *   `officer` (automatically installed with flextable)

## Author

**Alfonso Cano Robles**
*   Email: alfonso.cano@correo.buap.mx

Assisted by Gemini, a large language model from Google.

## License

This project is licensed under the **GPL (>= 3)**.
