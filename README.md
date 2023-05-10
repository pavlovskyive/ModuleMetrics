## KPI: Software Development Methods course

# swift-metrics

`swift-metrics` is a command-line tool for calculating various code metrics for Swift projects. 

This tool can analyze a directory of Swift files and calculate the number of lines of code, empty lines, physical and logical lines, and lines with comments, as well as the commenting level.

It also supports multithreading for faster analysis of large codebases.

`swift-metrics` can be easily integrated into your existing build process and can help you gain insights into the complexity and quality of your codebase. It is an open-source project and can be customized or extended as needed to fit your specific requirements.

# Installation

Apple Silicone:

```zsh
sudo chmod +x ./install_arm64.sh
./install_arm64.sh
```

Intel:

```zsh
sudo chmod +x ./install_intel.sh
./install_intel.sh
```

# Usage

```zsh
swift-metrics /path/to/directory <batch (optional)>
```

*Note: `batch` referred to maximum concurrent number of files to process. Default value is `10`.*