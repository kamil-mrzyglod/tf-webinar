output "file" {
  value = local_file.foo.content
}

output "file_sensitive" {
  value = local_sensitive_file.foo.content
  sensitive = true
}