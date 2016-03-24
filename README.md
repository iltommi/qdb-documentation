qdb-doc
=======

This repository contains a small build system and submodules from the various version branches of bureau14/qdb-branch-doc.

**Clone a working copy of qdb-doc:**

    git clone git@github.com:bureau14/qdb-doc
    git submodule init
    git submodule update

**Building all the versions of qdb-branch-doc:**

    make html (or other target; all targets from previous build system should work)

**Building a specific version of qdb-branch-doc only:**

    make VER=1.1.0 html

**Building one or more specific versions of qdb-branch-doc:**

    make VER="1.1.0 1.1.1 1.1.2 1.8.6" html


**Pulling changes from bureau14/qdb-branch-doc into qdb-doc:**

    git submodule update --remote --merge
    git commit -a

**Adding a version submodule of qdb-branch-doc to qdb-doc:**

See commit b9506d59b1314070daf01c61d34988efde757872 in qdb-doc repo for an example.

First, add the submodule.

    git submodule add -b 1.2.0 git@github.com:bureau14/qdb-branch-doc.git source/1.2.0

Then, edit the "all_versions" variable in the qdb-doc/source/shared/_static/version_switch.js file. For example,

    var all_versions = {
      // 'url_string': 'display_name_when_not_active'
      '1.1.2': '1.1.2'
    };

becomes:

    var all_versions = {
      // 'url_string': 'display_name_when_not_active'
      '1.1.2': '1.1.2',
      '1.2.0': '1.2.0'
    };

Note the comma after the 1.1.2 string!


**Removing a version submodule of qdb-branch-doc from qdb-doc (requires git 1.8.5.2+):**

    git rm source/1.2.0
    rm -rf .git/modules/source/1.2.0

