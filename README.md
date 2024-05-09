## Oberon-based Data Frame Tool

This is a simple tool written in Oberon for interacting with tabular data (data frames). It provides functionalities for loading, manipulating, analyzing, and saving data in a structured format.

**Requirements**

* **Oberon Compiler:** You'll need an Oberon compiler to run this project. The recommended compiler is:
    * **Vishap Oberon Compiler (VOC):** Follow the installation instructions provided on the VOC GitHub repository [here](https://github.com/vishaps/voc)

**Installation**

**Clone this Repository:** Use Git to clone this repository to your local machine.

**Building the Tool**

This repository includes a `GNUmakefile` to simplify the build process. 

1. **Open Terminal:** Open a terminal window and navigate to the directory containing the cloned repository.
2. **Run Make:** Execute the following command in the terminal:

```bash
make
```

This will build the tool.

**Using the Tool Directly (Optional)**

While the `makefile` simplifies the build process, it's entirely optional.  If you have your preferred method for compiling Oberon programs using VOC or another compiler, feel free to use that approach directly.

**Usage**

Once you've built the data frame tool, you might want to delve deeper into its inner workings.  A tool called `showdef` (availability depends on your Oberon compiler) can be helpful for this purpose.

**Using `showdef` (Optional)**

If your Oberon compiler includes `showdef`, you can use it to explore the structure of each module within the data frame tool. This can be particularly beneficial for:

* **Understanding how different parts of the tool interact**
* **Learning about the functions and procedures available in each module**
* **Familiarizing yourself with the codebase if you plan to contribute or modify it**

**Important Note:** Using `showdef` is completely optional. It's primarily for those who want to gain a deeper understanding of the tool's internal structure. You can still effectively use the data frame tool without utilizing `showdef`.
