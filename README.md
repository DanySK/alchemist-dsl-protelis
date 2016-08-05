# **WARNING**
This project has been discontinued. Please refer to the [Alchemist][Alchemist] website for up to date informations on how to run Protelis code in an Alchemist simulated environment.

# Alchemist DSL for Protelis

A language that allows writing [Alchemist][Alchemist] simulations running Protelis.

## Setup
* Download [the latest Eclipse for Java SE developers][eclipse]. Arch Linux users can use the package extra/eclipse-java, which is rather up-to-date.
* Install Xtext
	* In Eclipse, click Help -> Eclipse Marketplace...
	* In the search form enter "xtext", then press Enter
	* One of the retrieved entries should be "Xtext 2.8.x", click Install
	* Follow the instructions, accept the license, wait for Eclipse to download and install the product, accept the installation and restart the IDE.
* Install the Protelis Eclipse plug-in
	* In Eclipse, click Help -> Install New Software
	* In the text field labelled "Work with:", enter: ``http://hephaestus.apice.unibo.it/protelis-dsl/stable/``
		* If you want to work with the last nightly, choose instead: ``http://hephaestus.apice.unibo.it/alchemist-build/alchemist-protelis-parser/alchemist.protelis.repository/target/repository/``
	* Protelis will appear in the plugin list. Select it and click Next.
	* Follow the instructions, accept the license, wait for Eclipse to download and install the product, 
* Install the Protelis Simulations Eclipse plug-in
	* In Eclipse, click Help -> Install New Software
	* In the text field labelled "Work with:", enter: ``http://hephaestus.apice.unibo.it/protelis-simulation-dsl/stable/``
		* If you want to work with the last nightly, choose instead: ``http://hephaestus.apice.unibo.it/alchemist-build/alchemist-dsl-protelis/alchemist.protelisdsl.repository/target/repository/``

	* Press Enter
	* Protelis DSL will appear in the plugin list. Select it and click Next.
	* Follow the instructions, accept the license, wait for Eclipse to download and install the product, 

### Test installation

* Open Eclipse on a workspace of your choice
* Click on File -> New -> Java Project
* Give the project a name, then click "Finish"
* Find the ``src`` folder
* Create a ``test.psim`` file
* Eclipse will prompt you with a question: "Do you want to add the Xtext nature to the project "(your project name here")?". Answer "Yes"
	* If Eclipse does not ask you to add such nature, right click on the project, go to Configure -> Add Xtext Nature
* Open the ``test.psim`` file
* It should show an error
* Type the following (you can use ctrl + space, or your user defined shortcut, and use autocompletion): 
```
val x = 1

default environment
linking nodes in range 1.5
 
protelis program prog 
1
@x,x
  
place 100 nodes within rect (0,0,9,9) with program prog 
```
* A folder named ``src-gen`` will appear, containing a ``test.xml`` file. This file can be loaded by [Alchemist][alchemist-git]
* If such file is correctly generated, your installation has been successful.

## Usage

### Writing simulations


### Running a simulation in Alchemist

To understand how to simulate, refer to the [Alchemist main project][alchemist-git] website. The simulator can be downloaded from [here](https://github.com/DanySK/alchemist/releases)


## Build Status
[![Build Status](https://drone.io/github.com/DanySK/alchemist-dsl-protelis/status.png)](https://drone.io/github.com/DanySK/alchemist-dsl-protelis/latest)


### Javadocs

Javadocs for latest build is available [here][Javadoc]. Please note that such documentation may be not in sync with the version you are importing in your project, even if you point at the latest release, since such documention is re-generated by our nightly build system and is updated with the latest commit (if the build passes).
The documentation for any specific version of this library is released on Maven Central along with the code and the compiled jar file.


## Notes for Developers


### Importing the project
The project has been developed using Eclipse, and can be imported in such IDE.

## Project structure

* *alchemist.protelisdsl.parent*:
  the build point, which should pull in all of the others
* *alchemist.protelisdsl*:
  specifies the Protelis DSL and associated utilities using XText
* *alchemist.protelisdsl.target*:
  specifies the Eclipse runtime environment that the DSL plugin should
  be compatible with.
* *alchemist.protelisdsl.ui*:
  Contains the Eclipse plugin to support Protelis editing
* *alchemist.protelisdsl.repository*:
  Packages for the automated install website for Eclipse
* *alchemist.protelisdsl.tests*:
  Makes sure that you can fire up an instance of Eclipse that can
  load the plugin


#### Recommended configuration
* Download [the latest Eclipse for Java SE developers][eclipse]. Arch Linux users can use the package extra/eclipse-java, which is rather up-to-date.
* Install Xtext
	* In Eclipse, click Help -> Eclipse Marketplace...
	* In the search form enter "xtext", then press Enter
	* One of the retrieved entries should be "Xtext 2.8.x", click Install
	* Follow the instructions, accept the license, wait for Eclipse to download and install the product, accept the installation and restart the IDE.


#### Import Procedure
* Open Eclipse
* Click File -> Import -> Git -> Projects from Git -> Next
* Clone URI -> Next
* Paste `git@github.com:DanySK/alchemist-dsl-protelis.git` as URI -> Next -> Next
* Select the directory where you want to clone the repository. Beware that it **does not** point to the current Eclipse workspace by default
* Next -> Next -> Finish
* The projects will appear in your projects list.
* Once the repositories are imported, there will likely be a lot of errors.
* First, if there are "Plugin execution not covered by lifecycle configuration" errors, go to Eclipse Preferences > Maven > Errors/Warnings and switch this error type to warning.  This is OK because Eclipse uses its own build system, and can ignore these Maven problems (which are not due to the Maven configuration, but lack of certain current Eclipse/Maven integrations).
* Second, go to alchemist.protelisdsl project and run ``src/it.unibo.alchemist.language.protelisdsl/GenerateProtelisDSL.mwe2`` as an MWE2 workflow (ignoring the fact that there are errors).  This generates the DSL using Xtext, and should resolve all of the outstanding errors.


#### Building the project
While developing, you can rely on Eclipse to build the project, it will generally do decent job.
If you want to generate the artifacts, you can rely on Maven. Just point a terminal on the project's root and issue

```bash
cd alchemist.protelis.parent
mvn clean install -q
```

If you do not have a working graphical environment on your build machine, then make sure to skip testing, because they require to fire up an instance of Eclipse
```bash
cd alchemist.protelis.parent
mvn clean install -q -DskipTests=true
```

This will trigger the creation of the artifacts the executions of the tests, the generation of the documentation and of the project reports.


#### Release numbers explained
We release often. We are not scared of high version numbers, they are just numbers in the end.
We use a three level numbering, following the model of [Semantic Versioning][SemVer]:

* **Update of the minor number**: there are some small changes, and no backwards compatibility is broken. Probably, it is better saying that there is nothing suggesting that any project that depends on this one may have any problem compiling or running. Raise the minor version if there is just a bug fix, or a code improvement, such that no interface, constructor, or non-private member of a class is modified either in syntax or in semantics. Also, no new classes should be provided.
	* Example: switch from 1.2.3 to 1.2.4 
* **Update of the middle number**: there are changes that should not break any backwards compatibility, but the possibility exists. Raise the middle version number if there is a remote probability that projects that depend upon this one may have problems compiling if they update. For instance, if you have added a new class, since a depending project may have already defined it, that is enough to trigger a mid-number change. Also updating the version ranges of a dependency, or adding a new dependency, should cause the mid-number to raise. As for minor numbers, no changes to interfaces, constructors or non-private member of classes are allowed. If mid-number is update, minor number should be reset to 0.
	* Example: switch from 1.2.3 to 1.3.0 
* **Update of the major number**: *non-backwards-compatible change*. If a change in interfaces, constructors, or public member of some class have happened, a new major number should be issued. This is also the case if the semantics of some method has changed. In general, if there is a high probability that projects depending upon this one may experience compile-time or run-time issues if they switch to the new version, then a new major number should be adopted. If the major version number is upgraded, the mid and minor numbers should be reset to 0.
	* Example: switch from 1.2.3 to 2.0.0 


[Alchemist]: http://alchemistsimulator.github.io/
[alchemist-git]: https://github.com/AlchemistSimulator/
[Javadoc]: http://hephaestus.apice.unibo.it/alchemist-build/alchemist-dsl-protelis/alchemist.protelisdsl/target/apidocs/
[eclipse]: https://eclipse.org/downloads/
[SemVer]: http://semver.org/spec/v2.0.0.html
