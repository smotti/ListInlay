# Description

An attempt to build a list inlay with Elm and Bootstrap.

# Dependencies

* Elm
* Python 2.x/3.x
* Python Modules
  * Flask
  * Flask-Cors

# Build

Run the build script:

```
$ ./build.sh
```

# Usage

Start the flask web app that provides a RESTful HTTP API:

```
$ python api.py
```
  
After compilation and starting the api just open **index.html** in a browser of
your choice.

# TODO

* ~~Fix multiselectable~~
  * Was working before, but not anymore, I think it stopped working after
    moving the panel-body
    * Moving the panel-body into the panel-heading certainly works but that
      ain't the solution
    * The solution is to set the data-parent attribute to false, or remove
      it because false is the default (See [here](http://getbootstrap.com/javascript/#collapse-options) for details)
  * Or maybe the sorting of the entries list
    * Nope that ain't it, confirmed by implementing the fetching of details
      only when necessary. When we have fetched details of all entries no
      sorting will occur but the multiselect is still broken.
* ~~Only fetch entry detailf if we didn't do so previously~~
