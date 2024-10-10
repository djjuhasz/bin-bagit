# bin-bagit

**bin-bagit** an experiment in building a Docker image running
<https://github.com/LibraryOfCongress/bagit-python> as a single file binary.

**bin-bagit** uses:

- <https://github.com/astral-sh/uv> for Python package management
- <https://github.com/six8/pyinstaller-alpine> to build a single file binary for
  Alpine Linux from the `bagit-python` package

## Notes

- `setuptools` is a dependency for <https://pypi.org/project/bagit/1.8.1/> (it
  imports  `pkg_resources`) but is not in listed in the `requirements.txt` file.
- The `pkg_resources` import has been removed from the bagit-python git
  repository as of <https://github.com/LibraryOfCongress/bagit-python/commit/44f21392604e3930af9f0b6f9f0937ea3d56fe2e> but I haven't taken the time to
  build `bagit-python` from the source.

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
