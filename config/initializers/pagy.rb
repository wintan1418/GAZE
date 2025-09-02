# Pagy initializer
require 'pagy/extras/metadata'
require 'pagy/extras/overflow'

# Set default items per page
Pagy::DEFAULT[:items] = 20

# Handle overflowing pages
Pagy::DEFAULT[:overflow] = :last_page