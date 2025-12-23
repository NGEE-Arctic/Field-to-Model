# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'ModEx 2025'
copyright = '2025, ModEx Team, LANL, ORNL, UAF, LBNL'
author = 'ModEx 2025 Developers'
release = '0.0.1'

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

