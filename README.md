# QuasarDB documentation repository

This repository functions as the starting point for QuasarDB documentation. It is part of a build pipeline and used by [qdb-doc-engine](https://github.com/bureau14/qdb-doc-engine).

The current build process (as reflected in TeamCity) is as follows:

## Assemble all sources

This step assembles all the documentation sources as; at the moment of writing, this essentially means checking out all API repositories (qdb-api-java, qdb-api-go, etc) and checking out this repository. Any change in any of these repositories will automatically trigger this project.

This is a significant change since the previous iteration of the documentation pipeline: qdb-doc-engine used to pull in its dependencies itself, but this ultimately proved fragile and inflexible when dealing with versioning. By leveraging TeamCity assemble the dependencies, we get flexible branch/version management and build triggers for free.

In TeamCity, this is currently the first step of the build of the [Documentation -> Doc Engine](https://teamcity.quasardb.net/viewType.html?buildTypeId=Documentation_DocEngine) project.

## Generate documentation (qdb-doc-engine)

Once all documentation is assembled, it needs to be parsed, merged and converted into (among others) HTML. This is the second stepo of the [Documentation -> Doc Engine](https://teamcity.quasardb.net/viewType.html?buildTypeId=Documentation_DocEngine) build, and it generates both all RST files and the HTML output.

## Validation

Before we publish the documentation, we validate it in the [Documentation -> Validation](https://teamcity.quasardb.net/viewType.html?buildTypeId=Documentation_Validation) project for things such as dead links. If we were to validate code samples and queries of our documentation in the future, this would be the place to integrate it.

## Deployment

Only when the validation step succeeds, a deploy is triggered and the documentation will be pushed to our webserver. Based on the branch being deployed, TeamCity will automatically put the documentation in the correct path such that `/master/` refers to the master branch and `/1.2.3` refers to the version branch.

# TODO

There still is one problem with the current build pipeline: As you can see in the build chain below, it is as if the build of `qdb-doc engine` is the main repository that contains all documentation, but that is not in fact the case. `qdb-doc-engine` is a tool to build documentation, but the `qdb-documentation` (this repository) is actually what we want to build. We should separate the two projects: `qdb-doc-engine` should trigger to build its docker container, and `qdb-documentation` should run inside that docker container. 



# Build chain

For completeness sake, this is what the build pipeline looks like:

![alt text](https://raw.githubusercontent.com/bureau14/qdb-documentation/master/build-chain.png)
