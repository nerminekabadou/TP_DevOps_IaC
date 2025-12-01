# Affiche le nom du conteneur de la base de données
output "db_container_name" {
  description = "Nom du conteneur de la base de données."
  value       = docker_container.db_container.name
}

# Affiche l'URL d'accès à l'application web
output "app_access_url" {
  description = "URL d'accès à l'application web."
  value       = "http://localhost:${docker_container.app_container.ports[0].external}"
}
