Test code blocks in Markdown files.

This project contains the following:

- `util/generate-tests.sh`: Script to prepare Markdown code blocks for testing. 
  It copies Markdown files to a temporary directory and substitutes real configuration values for placeholders in code blocks.
- `util/run-tests.sh`: Script to pass Markdown test files to test runners for execution and reporting.

## Set configuration values

`util/generate-tests.sh` assumes you have set environment variables for substituting placeholders in code blocks.

Additionally, some code samples may specify a `.env` configuration file.
For those, create a `.env` file and set your own configuration properties there--for example, in `.env.influxdbv3`:

```
INFLUX_HOST=https://us-east-1-1.aws.cloud2.influxdata.com
INFLUX_TOKEN=3S3SFrpFbnNR_pZ3Cr6LMN...==
INFLUX_ORG=28d1f2f........c
INFLUX_DATABASE=get-started
```

Using a `.env` is generally preferable to using environment variables.

## Generate tests

Generate test files for Markdown files that have changed relative to your git `master` branch:

```sh
sh ./util/generate-tests.sh -f ./examples
```

To force regenerating all files:

```sh
sh ./util/generate-tests.sh -f ./examples -a
```

The default output directory is `./tmp`. Use the `-o` option to specify a different directory.

## Test code blocks in test files

Pass `./tmp` files to test runners:

```sh
sh ./util/run-tests.sh
```

### Test runners

_Experimental--work in progress_

pytest with the --codeblocks extension can extract code in python and shell code blocks and execute similar to unit tests (a non-zero exit code is a failure).
To assert the output of a code block, add the

`<!--pytest-codeblocks:expected-output-->`

comment tag after the code block and include the expected output--for example:

```python
print("Hello, world!")
```
<!--pytest-codeblocks:Hello, world!-->

Or, to output the expectation, include it in its own code block--for example:

<!--pytest-codeblocks:expected-output-->
If successful, the output is the following:

```
Hello, world!
```

#### Other potential tools

The `runmd` NPM package runs `javascript` code blocks in Markdown and generates a new Markdown file with the code block output inserted.

The `codedown` NPM package extracts code from Markdown code blocks for each language and
can pipe the output to a test runner for the language.

## Troubleshoot

### Python

`pytest --codeblocks` expects Python code blocks to use the following delimiter:

```python
...
```

It ignores code blocks in ```py```.