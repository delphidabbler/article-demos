How to use the Environment Variable Demo program
================================================

This demo program demonstrates the use of the following routines, defined in
the PJEnvVars unit:

+ GetEnvVarValue
+ SetEnvVarValue
+ DeleteEnvVar
+ GetAllEnvVars
+ ExpandEnvVars
+ CreateEnvBlock

When the program first starts it displays the names of all the system's
environment variables in a list box.


1) Manipulating environment variables
-------------------------------------

Demonstrates: GetEnvVarValue, SetEnvVarValue, DeleteEnvVar, GetAllEnvVars

Click on a variable to display it's name and value in the edit boxes below the
list box.

To change the value of an existing variable edit the value in the "Variable
value" edit box and click the "Update" button.

To add a new variable enter it's name in the "Variable name" edit box and its
value in the "Variable value" edit box. If the named variable doesn't exist the
"Update" button's caption will change to "Add". Click the add button to add the
new variable. It will now be displayed in the list box along with the other
variables.

The environment variable with the name that is currently in the "Variable name"
edit box can be deleted by clicking the "Delete" button.

The environment block available to a program is of a fixed size. Attempting to
add environment variables (or enlarge the value string) when the block is full
results in an error. To check the size of the available buffer click the "Fill
environment block" button. This attempts to create 10,000 unique environment
variables. It will usually stop with an error show how many variables were
added. To check the size of the block create a new variable (Z say) with a one
character value. Continue adding one character to this value until an error
message is displayed. The block size will be 32 bytes more than the size
displayed in the window. Try creating a new process with the existing
(full) environment block + one more variable (see below for the method). The new
process will have a larger environment block and clicking the "Fill environment
block" button for that process will show that additional variables can be added.
On the Windows 98 system where the demo was originally written the initial
process received a 16Kb environment block and this was then increased as
required in 4Kb block increments. This figure is massively increaed on Windows
NT systems.

*** NOTE: Sometimes at least one "empty" item is included in the environment
variables list, because the environment has at least one entry not in the form
Name=Value. You can't edit these values.


2) Handling environment blocks for child processes
--------------------------------------------------

Demonstrates: CreateEnvBlock

When a child process is spawned it can either inherit the parent program's
environment block or be given a new custom block. Click the "Exec child app"
button to experiment with child processes.

In the resulting dialog box you can spawn a new child process. This process will
be another instance of this application, but it will display and manipulate
the environment passed to it.

What kind of environment is used is selected by the dialog's radio buttons.

+ "Current environment":
  A copy of the current environment is passed to the child process automatically
  by Windows.
  
+ "Environment variables defined below":
  Only the environment variables defined in the memo control are passed to the
  child process - it does not get a copy of the current environment.
  
+ "Current environment + variables below":
  A copy of the current environment in addition to those defined in the memo
  control are passed to the new process.

To define new environment variables enter the variables in the form NAME=VALUE,
one per line.

To create the process, click the "Spawn new process button". This spawns a new
instance of this application with the required environment then closes this
dialog box.

Note that any change made to the environment in a child process do not affect
the parent's environment. Similarly, changes to the parent's environment made
after a child process has been spawned are not reflected in the child process's
environment.


3) Expanding environment variables
----------------------------------

Demonstrates: ExpandEnvVars, GetAllEnvVars

Select the "Expand vars" button. In the resulting dialog box enter some text in
the top memo control. Embed environment variable references by either entering
variable names surrounded by % characters (%ENVVAR%) or by selecting the
required variable from the drop down list.

Clicking the "Expand environment variables" button displays the expanded string
in the lower memo control.
