# rk.flextable

> **Publication-Ready Tables for RKWard**

**rk.flextable** is an RKWard plugin that provides a graphical interface for the powerful [`flextable`](https://davidgohel.github.io/flextable/) package. It allows users to easily create, format, and export professional tables for scientific publications and reports directly from the RKWard GUI, without writing complex R code.

## Features

*   **GUI-Driven Creation**: Convert any R dataframe into a formatted table with a few clicks.
*   **One-Click Themes**: Apply professional styles instantly (Scientific/Booktabs, Minimal, Zebra, Boxed, etc.).
*   **Smart Refinements**:
    *   Automatic column width adjustment (`autofit`).
    *   Header formatting (Bold, Center alignment).
    *   Automatic footer generation (e.g., row counts).
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

Once installed, you may need to restart RKWard or go to **Settings -> Configure RKWard -> Plugins** to activate it.

## Usage

The plugin is located in the main menu under:
**Data -> Reporting (flextable)**

It consists of two main tools:

### 1. Create Table
Use this tool to generate the table object from your data.
*   **Input**: Select a dataframe from your workspace.
*   **Themes**: Choose from standard `flextable` themes (e.g., `theme_booktabs` for scientific papers).
*   **Options**: Toggle bold headers, centering, or footers.
*   **Output**: Saves a `flextable` object to your workspace (default name: `my_ft`).

### 2. Export Table
Use this tool to save your table to a file.
*   **Input**: Select the `flextable` object created in the previous step.
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
