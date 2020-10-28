# CPASS DATABASE
Database scripts for CPass. Both in single-script mode (inside the `/src` folder) and in aggregate form (inside the `/dist` folder).

## Development
Every script inside the `/dist` folder MUST be idempotent, meaning that repeated executions of the script MUST have the same result on the database (sequences notwithstanding).
The scripts inside `/src` SHOULD be idempotent, but it is not imperative.

The scripts inside the `/dist` folder have the following logic:
- they are contained in a folder representing the version of the installation unit (as referenced in the `pom.xml`)
- they contain an `all.sql` file if the ENTIRE database is present (mainly for version 1.0.0, being the starting version)
- they contain a `delta.sql` file representing the differences to be applied to the previous version
- they contain multiple `<profile>.sql` files representing the possible customizations for a single profile (most of the time they should be unused)

## Configuration
In case a new profile is to be added, it MUST be referenced in the `<profiles>` section of the `pom.xml`, and the corresponding `<profile>.sql` file MUST be added in the `/dist` folder.
