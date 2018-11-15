# Scrape Project

This is a very simple Python script that will apply an XSLT stylesheet
to a web page or HTML file to generate output as determined by the
stylesheet.

While one might try to use **xsltproc** to convert the downloaded HTML
files, it is often unable to parse the HTML file, even with `--html` flag
set.  This script uses the `libxml2` and `libxslt` libraries to offer a
much more forgiving HTML parser.

## Installation

Download from GitHub:

~~~sh
git clone https://github.com/cjungmann/scrape.git
~~~

There is an *install* script that copies the python script and the
*sanitize.xsl* stylesheet to /usr/local/lib, then makes a link in the
/usr/local/bin directory to the *scrape* program.

To install:
~~~sh
sudo ./install
~~~

To uninstall:
~~~sh
sudo ./install --uninstall
~~~

For instructions (largely the same as these):
~~~sh
./install --help
~~~
(Actually, any argument after *./install* besides *--uninstall* will
print a usage message.)

## Usage

There are several ways this utility can be used.  In all cases, the
result is written to **stdout**.  In the likely event that the results
must be saved, simple add *> result.html* the call the **scrape**.

1. The standard usage is to provide both an XSL stylesheet and an
   HTML file.
   ~~~sh
   scrape sample.xsl sample.html
   ~~~

1. Use default *sanitize.xsl* stylesheet to create a valid XHTML
   document from the HTML.  The valid XHTML can be used with *xsltproc*
   or an XSL debugger like [Oxygen](www.oxygenxml.com).

   ~~~sh
   scrape messysample.html > cleansample.html
   ~~~

1. In either of the first two forms, the HTML filename can be
   replace with *-* to read the HTML file from **stdin**.

   ~~~sh
   wget -O- www.dustyfeet.com | scrape - > dustyfeet.html
   ~~~

There is an example section at the bottom of this document that
explains the sample files `avssnames.htm` and `avss.xsl` and how
they are created.

### Usage Suggestion

Creating a stylesheet to scrape data from a website usually requires
several iterations of the stylesheet to get the right data.  I
recommend using the third form from above to create a proper XHTML
file from the web page.  Having a sanitized XHTML file allows the
use of *xsltproc* to help debug the stylesheet as it is being developed.

## Requirements

I developed this script on Ubuntu Linux, so the instructions are mainly
valid for that environment.

The prerequisite packages listed below should also be available on Windows,
Mac, and other Linux platforms.  However, some additional setup may be
required to get the script running, especially in the case of Windows.

As far as other Linux distributions, the difference is mainly in how the
software is installed.  I'm assuming the use of **apt get**, but some
distributions use other package managers, and some may require building
the libraries from source.


### Required Libraries

- [libxml2](http://xmlsoft.org/) is installed by default
- [libxslt1.1](http://xmlsoft.org/XSLT/) is installed by default
- [libxml2 Python Bindings](http://xmlsoft.org/python.html)


### Installing Libraries

~~~sh
sudo apt-get install python-libxml2 python-libxslt1
~~~

#### Documentation for libxml2.py 

There is extensive documentation for the C interfaces to `libxml2`
online.  Look at the [Reference Manual](http://xmlsoft.org/html/index.html)
and the [Code Examples](http://xmlsoft.org/examples/index.html) to
get a handle on how the library is designed to be used.

Python documentation is pretty sparse, or at least hard to find.
Fortunately, the files included in the *python-libxml2* package can
help bridge the gap between the C and Python implementations.

On my computer, the helpful files are found in two locations,
- `/usr/share/doc/python-libxml2` has README and an `examples`
  subdirectory with several code samples.
- `/usr/lib/python2.7/dist-packages/libxml2.py` is the actual
  wrapper around `libxml2.so` and includes all the constants
  you'll see in the online C++ documentation.

If these locations are not valid on your computer, use the package
manager to see where the files are stored.

~~~sh
dpkg -L python-libxml2
~~~

#### Documentation for libxslt

Similar to the libxml2 library, one can find documentation in similar
locations.

- `/usr/share/doc/python-libxslt1` and look at README and the files under
  `examples`.  The libxslt use in this script is minimal and `examples/basic.py`
  is sufficient to understand what to do.

  Note that the code **does not** call `xsldoc.freeDoc()` unless `parseStylesheetDoc()`
  fails.  The stylesheet object returned by `parseStylesheetDoc() automatically
  closes the document that initializes it, resulting in a double-free exception
  if `xsldoc.freeDoc()` is called.
  
- `/usr/lib/python2.7/dist-packages/libxslt.py` to look at option values.

## AVSS Example

I originally developed this script to scrape baby names and frequencies of use
for a name generator.  I found an [Automated Vital Statistics System](http://www.avss.ucsb.edu/)
that hosts a page with [baby name databases](http://www.avss.ucsb.edu/name.htm).

I could have written code to get the website as part of the script, but
since you need the HTML page to know how to write the XSL stylesheet,
I left that out.  The stylesheet is custom-written for the source, and
usually requires some trial-and-error to make a good stylesheet, so it
is better to download the HTML page.

My [name generating project](https://github.com/cjungmann/namegen) includes
a [script file](https://github.com/cjungmann/namegen/blob/master/builddoc) that can serve as a more complete example of how to use this utility to accomplish a scraping task.