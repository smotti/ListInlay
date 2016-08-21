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

* Fix multiselectable
  * Was working before, but not anymore, I think it stopped working after
    moving the panel-body
  * Or maybe the sorting of the entries list
* Only fetch entry details if we didn't so previously
