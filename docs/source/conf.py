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
  # There are no options for the 'nature' theme
}

html_sidebars = {
  # 'Pages matching pattern': [list of templates to include...]
  '**': ['localtoc.html','searchbox.html'],
  
  'index': ['globaltoc.html', 'searchbox.html',],
  # This adds a differently styled TOC, I don't think it looks as good.
  # But it is global to the whole site....
  #'**': [ 'globaltoc.html', 'searchbox.html'],
}