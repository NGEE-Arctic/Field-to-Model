import datetime

# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'ModEx 2026'
copyright = '2026, ModEx Team, LANL, ORNL, UAF, LBNL'
author = 'ModEx 2026 Developers'
build_time = datetime.datetime.now(datetime.timezone.utc)
release = f'(updated: {build_time.strftime("%b %d %H:%M:%S UTC")})'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [  
  'sphinx_toolbox.collapse',
  'myst_parser',
  'sphinx.ext.autosectionlabel',
  'sphinx_multitoc_numbering',
]

source_suffix = {
  '.rst': 'restructuredtext',
  '.txt': 'markdown',
  '.md': 'markdown',
}

templates_path = ['_templates']
exclude_patterns = []

html_logo = '_static/NGEE_Arctic_logo_large.png'
autosectionlabel_prefix_document = True

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'nature' # alabaster, basic, nature, bizstyle, scrolls, sphinxdoc, agoago, traditional, haiku
html_static_path = ['_static']
html_css_files = [
    'css/custom.css',
]

html_theme_options = {
  # There aren't many options for the 'nature' theme
  # Tried playing with the sidebar width, but it didn't work very well and is
  # likely to cause problem with different resolutions and devices.
  # Some docs here: https://www.sphinx-doc.org/en/master/usage/theming.html
  #"sidebarwidth": '50%',
  #"sidebarwidth": 230, # in pixels, this seems to be the default
}

html_sidebars = {
  # 'Pages matching pattern': [list of templates to include...]
  
  '**': ['searchbox.html','localtoc.html', 'globaltoc.html', 'relations.html'],
  
  # This puts a different sidebar on the index page only...
  #'index': ['searchbox.html', 'globaltoc.html', 'searchbox.html',],
}