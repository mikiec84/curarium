Curarium::Application.config.local = YAML.load_file(Rails.root.join('config/config.yml'))[Rails.env]

Curarium::ANNOTATION_THUMBNAILS_FOLDER = 'annotation_thumbnails'
Curarium::ANNOTATION_THUMBNAILS_PATH = Rails.public_path.join( Curarium::ANNOTATION_THUMBNAILS_FOLDER )
