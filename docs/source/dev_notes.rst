General Notes
===========================================================

 - This Sphinx project is configured to use MyST parser to allow writing in 
   Markdown as well as reStructuredText. 
 
 - Markdown is easier to write, but reStructuredText is much more powerful for
   advanced formatting. 
   
 - If you want collapse blocks, use reStructuredText.

 - The :code:`sphinx-autobuild` extension (which is enabled) would be super
   handy, but for some reason the hot reloading is not working; changes to the
   source files in the host editor don't trigger any events in the dev server.

 - There is some custom CSS in the :code:`source/_static/css/custom.css` file to
   style the collapse blocks. You can edit that file to change the colors,
   borders, etc. See the comments in the CSS file for more details.