# bin-bagit

**bin-bagit** is an experiment in building a Docker image containing
<https://github.com/LibraryOfCongress/bagit-python> as a single file binary.

**bin-bagit** uses:

- <https://github.com/astral-sh/uv> for Python package management
- <https://pyinstaller.org/> to build the single file binary from the
  `bagit-python` package

## Usage

### Build the image

```bash
docker build -t bagit .
```

### Validate a bag

To validate a bag at `/home/myname/test` in your local filesystem.

```bash
docker run --rm -v /home/myname/test:/src:ro -t bagit --validate /src
```
