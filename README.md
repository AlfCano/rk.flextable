# rk.flextable

> **Publication-Ready Tables for RKWard**

![Version](https://img.shields.io/badge/Version-0.0.4-blue.svg)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![RKWard](https://img.shields.io/badge/Platform-RKWard-green)
[![R Linter](https://github.com/AlfCano/rk.flextable/actions/workflows/lintr.yml/badge.svg)](https://github.com/AlfCano/rk.flextable/actions/workflows/lintr.yml)
![AI Gemini](https://img.shields.io/badge/AI-Gemini-4285F4?logo=googlegemini&logoColor=white)

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
*   **Advanced Table Formatting**: Add table captions (titles), custom footers with font size control, and adjust table width proportions or fixed layouts.
*   **Workspace Management (RDS)**: Save and load any R object (dataframes, tables, models, plots) natively as `.rds` files directly from the GUI.
    
## 🌍 Internationalization

The interface is fully localized to match your RKWard language settings:

*   🇺🇸 **English** (Default)
*   🇪🇸 **Spanish** (`es`)
*   🇫🇷 **French** (`fr`)
*   🇩🇪 **German** (`de`)
*   🇧🇷 **Portuguese** (Brazil) (`pt_BR`)    

## Installation

You can install this plugin directly from GitHub using `remotes` within RKWard:

```r
require(remotes)
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

### 3. Advanced Formatting
Use this tool to refine an already created flextable with publication-ready details.
*   **Layout & Theme**: Apply extended themes (Colorful, Dark, Neon/Retro), adjust table width proportions (0.1 to 1.0), and switch between Autofit and Fixed layouts.
*   **Caption & Footer**: Add a main table title (caption) and source notes (footer), dynamically adjusting their font sizes via the `officer` package.

---

The plugin also adds a new utility menu under:
**File -> Workspace & RDS**

### 4. Save Object to RDS
Easily export any R object from your workspace (a styled flextable, a dataframe, or a statistical model) into an `.rds` file to preserve its exact structure for future sessions.

### 5. Load Object from RDS
Import any `.rds` file back into your RKWard environment safely, assigning it a custom variable name without overwriting existing data.

---

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
