Test code blocks in Markdown files.

This project contains the following:

- `test/generate-tests.sh`: Script to prepare Markdown code blocks for testing. 
  It copies Markdown files to a temporary directory and substitutes real configuration values for placeholders in code blocks.
- `test/run-tests.sh`: Script to pass Markdown test files to test runners for execution and reporting. Currently, this just passes the files created by `test/generate-tests.sh`
to `pytest --codeblocks` for testing Python and shell code samples.

## Set configuration values

`test/generate-tests.sh` assumes you have set environment variables for substituting placeholders in code blocks.

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
sh ./test/generate-tests.sh -f ./examples
```

To force regenerating all files:

```sh
sh ./test/generate-tests.sh -f ./examples -a
```

The default output directory is `./tmp`. Use the `-o` option to specify a different directory.

## Test code blocks in test files

Pass `./tmp` files to test runners:

```sh
sh ./test/run-tests.sh
```

### Test runners

_Experimental--work in progress_

`pytest` with the `--codeblocks` extension extracts code from python and shell Markdown code blocks
and executes assertions for the code.
If you don't assert a value, `--codeblocks` considers a non-zero exit code to be a failure.

To assert the output of a code block, place the

```<!--pytest-codeblocks:expected-output-->```

comment tag in your Markdown after the code block and include the expected output--for example:

```python
print("Hello, world!")
```
<!--pytest-codeblocks:Hello, world!-->

Or, to output the expectation in your Markdown content, include it in a separate code block--for example:

<!--pytest-codeblocks:expected-output-->
If successful, the output is the following:

```
Hello, world!
```

`python --codeblocks` uses Python's `subprocess.run()` to execute shell code.

#### Future and related ideas

The `codedown` NPM package extracts code from Markdown code blocks for each language and
can pipe the output to a test runner for the language.

`pytest` and `pytest-codeblocks` use the Python `Assertions` module to keep testing overhead low.
Node.js also provides an `Assertions` package.

The `runmd` NPM package runs `javascript` code blocks in Markdown and generates a new Markdown file with the code block output inserted.

## Troubleshoot

### Pytest collected 0 items

Potential reasons:

- See the test discovery options in `pytest.ini`.
- For Python code blocks, use the following delimiter:

    ```python
    ...
    ```

  `pytest --codeblocks` ignores code blocks that use ```py```.