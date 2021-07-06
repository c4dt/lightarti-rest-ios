# arti-ios

iOS library for REST requests using arti.
This uses the code from [arti-rest](https://github.com/c4dt/arti-rest).
As such it is important to notice:

- arti itself mentions it's not ready for prime-time. In their
  [README](https://gitlab.torproject.org/tpo/core/arti/-/blob/main/README.md), they write
  **you should probably not use Arti in production**
- the current code implements caching of the tor-directory listing to avoid having
  to download some megabytes of node descriptors every so often. Again, given the right
  circumstances, this can be effective and secure enough. Under other circumstances
  this is something you don't want to do.

If you want to use this for your project, be sure to contact us in this repo.
We'll be happy to discuss enhancements and limitations of our solution.

## Directory cache

This version comes with a mandatory cache of the tor directory data.
This means that the app itself will have to download this data and make
it available in a directory to the library.

For more information, see [Directory Cache](https://github.com/c4dt/arti-rest/blob/directory_scripts/tools/README.md)