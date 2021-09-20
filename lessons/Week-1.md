Week 1: Data Import, Manipulation, and GitHub
================

# Objectives:

-   Set up and configure GitHub for use within RStudio.  
-   Importing data in R (a quick overview).  
-   Data manipulation in R (a quick overview).

# Setup GitHub

Follow instructions on [Using Git with
RStudio](https://jennybc.github.io/2014-05-12-ubc/ubc-r/session03_git.html).

For a Windows machine, generally, it is:

-   Download and install [Git](https://git-scm.com/download/win).  
-   In RStudio, create an SSH key pair (follow instructions
    [here](https://happygitwithr.com/ssh-keys.html#create-an-ssh-key-pair)):
    -   Go to Tools &gt; Global Options… &gt; Git/SVN.  
    -   Point to the executable “git.exe” (/Program Files/Git/)  
    -   Create RSA key in RStudio.  
    -   Copy RSA key. Add the generated key by clicking “new SSH key”
        into GitHub under your profile’s settings &gt; SSH and GPG keys,
        and pasting it.
-   Open git bash executable, and change directory (`cd`) to the folder
    you want to save the repo in.  
-   Run the following:  

<!-- -->

    git clone https://github.com/engineerchange/r-dsandml-exercises.git

-   Open .Rproj file in RStudio.  
-   Then go to Tools &gt; Project Options… &gt; Git/Svn to configure.  
-   From there, you should see a “Git” tab in the Environment pane where
    you can Commit, Pull, and Push.

## Resources

### GitHub

-   [Using Git with
    RStudio](https://jennybc.github.io/2014-05-12-ubc/ubc-r/session03_git.html),
    Jenny Bryan  
-   [Happy Git with R](https://happygitwithr.com/), Jenny Bryan
